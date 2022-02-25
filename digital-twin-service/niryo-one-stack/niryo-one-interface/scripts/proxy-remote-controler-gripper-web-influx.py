#!/usr/bin/env python

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

import csv
import sys
import time
import datetime
from threading import Timer
from collections import deque 
import signal
import numpy as np
from random import randrange
import random
import rospy
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
from niryo_one_python_api.niryo_one_api import *
from sensor_msgs.msg import Joy
from std_msgs.msg import Bool
from collections import deque
from flask import Flask, jsonify, request
from threading import Thread
from influxdb import InfluxDBClient
from os import environ

WEBSERVER_IP='0.0.0.0'
WEBSERVER_PORT= 9999

def signal_handler(sig, frame):
  sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

rospy.init_node('niryo_one_keystick')
#pub = rospy.Publisher('/foreco/controller/command', JointTrajectory, queue_size=1, tcp_nodelay=True)

pub = rospy.Publisher('/proxy_consumer/command', JointTrajectory, queue_size=1, tcp_nodelay=True)

pub_enable_predictions=rospy.Publisher('/enable_predictions', Bool, queue_size=1, tcp_nodelay=True)

joy_pub = rospy.Publisher('/joy', Joy, queue_size=1, tcp_nodelay=True)

influx_client = InfluxDBClient('10.5.4.21')


monitoring = True if environ.get("MONITORING", "false").lower() == "true" else False

consecutive = 0
loss = 0

gripper_state = 1

random.seed(3)
start_remote_control=False

# If freq_decrease==1 -> 20ms control loop
#    freq_decrease==2 -> 40ms control loop
#    freq_decrease==3 -> 60ms control loop
freq_decrease=1
seq=0
dis=0
#n = NiryoOne()
#n.change_tool(TOOL_GRIPPER_2_ID)
last_command=[0.0,0.0,0.0,0.0,0.0,0.0]
cmd_stable=deque(maxlen=10)

app = Flask(__name__)

@app.route("/start/", methods=['POST'])
def start_post():
  global start_remote_control, thread, seq, loss
  data = request.json
  loss_rate = data['loss_rate']
  loss=int(loss_rate)
  seq=0
  start_remote_control = True
  thread = Thread(target = run_remote_control)
  thread.start()
  return jsonify({'success': True}), 200


@app.route("/update/", methods=['POST'])
def update_post():
  global loss
  data = request.json
  loss_rate = data['loss_rate']
  loss=int(loss_rate)
  return jsonify({'success': True}), 200

@app.route("/stop/", methods=['POST'])
def stop_post():
  global start_remote_control, thread
  start_remote_control = False
  thread.join()
  return jsonify({'success': True}), 200

@app.route("/prediction/", methods=['POST'])
def prediction_post():
  global pub_enable_predictions 
  msg=Bool()
  msg.data=True
  data = request.json
  if(data['prediction']=="1"):
      msg.data=True
      pub_enable_predictions.publish(msg)
  else:
      msg.data=False
      pub_enable_predictions.publish(msg)
  return jsonify({'success': True}), 200

def move_to_position(pos, cmd_speed=0.15):
  global freq_decrease,seq
  rtime = rospy.Time.now()
  msg = JointTrajectory()
  msg.header.stamp = rtime
  msg.header.seq=seq
  seq+=1
  msg.joint_names = ['joint_1', 'joint_2', 'joint_3',
                     'joint_4', 'joint_5', 'joint_6']

  point = JointTrajectoryPoint()
  point.positions = pos
  point.time_from_start = rospy.Duration(cmd_speed)
  msg.points = [point]
  print(str(datetime.datetime.now()) + ": " + str(pos) +": " + str(msg.header.seq))
  pub.publish(msg)


def fill_stable_queue(position):
    global last_command, cmd_stable
    difference=[]
    if(last_command==[0.0,0.0,0.0,0.0,0.0,0.0]):
        last_command=position
    else:
        zip_object = zip(position, last_command)
        for position_i, last_command_i in zip_object:
            difference.append(position_i-last_command_i)
        difference=[round(num,2) for num in difference]
        last_command=position
        if cmd_stable:
            #res=[round(num,2) for num in difference]
            #res1=[round(num,2) for num in cmd_stable[0]]
            if(difference==cmd_stable[0]):
                cmd_stable.append(difference)
            else:
                cmd_stable.clear()
        else:
            cmd_stable.append(difference)

def run_remote_control():
  global gripper_state, consecutive, loss, joy_pub, pub, n, last_command, seq, freq_decrease, cmd_stable, start_remote_control, monitoring, influx_client
  random.seed(3)
  dis=0
  dataset='/home/niryo/catkin_ws/src/niryo_one_bringup/scripts/milan-4-cubes-10.csv'
  with open(dataset) as f:
    f.readline() # skip header line
    valid=0
    while start_remote_control:
      line = f.readline().split(',')
      #print(line)
      pos =  [float(line[4]),
             float(line[5]),
             float(line[6]),
             0.00,
             0.00,
             0.00]
      
      fill_stable_queue(pos)
      gripper=float(line[10])
      if(gripper_state != gripper):
          if(gripper == 1):
              joy_msg=Joy()
              joy_msg.buttons=[0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
              joy_pub.publish(joy_msg)
              #n.open_gripper(TOOL_GRIPPER_2_ID, 100)
              print("OPENING GRIPPER")
              gripper_state = 1
              time.sleep(2)
          else:
              joy_msg=Joy()
              joy_msg.buttons=[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
              joy_pub.publish(joy_msg)
              #n.close_gripper(TOOL_GRIPPER_2_ID, 100)
              print("CLOSING GRIPPER")
              gripper_state = 2
              time.sleep(2)
          
      if randrange(100) > loss:
        if valid%freq_decrease==0:
          move_to_position(pos)
          if monitoring:
            json_body = [
            {                      
              "measurement": "robot_joints",
              "tags": 
              {
                "predictions": "False" # TODO tags?
              },
              "fields": 
              {
                "joint_1": pos[0],
                "joint_2": pos[1],
                "joint_3": pos[2] 
              }
            }]
            try:
              influx_client.write_points(json_body)      
            except Exception as e:
              print(e)
          #print("moving")
          #print(pos)
        time.sleep(0.15)
      else:
        if(len(cmd_stable)==10):
            time.sleep(0.15)
            print("Discard: " + str(dis))
            dis+=1
            print(str(datetime.datetime.now()) + ": " + str(pos) + ": discarded" )
            for i in range(0, consecutive*freq_decrease):
              line = f.readline().split(',')
              rand_delay=0.30+(randrange(1600))/10000
              #print(rand_delay)
              #time.sleep(rand_delay)
              pos =  [float(line[4]),
                      float(line[5]),
                      float(line[6]),
                      float(line[7]),
                      float(line[8]),
                      float(line[9])]
              #move_to_position(pos)
              print("Discard: " + str(dis))
              print(str(datetime.datetime.now()) + ": " + str(pos) + ": discarded" )
              dis+=1
              #print("Delay: " + str(rand_delay))
              time.sleep(0.15)
        else:
            move_to_position(pos)
            time.sleep(0.15) 
  
      valid+=1
  
  f.closed

thread = Thread(target = run_remote_control)

if __name__ == "__main__":
  app.run(host=WEBSERVER_IP, port=WEBSERVER_PORT)
