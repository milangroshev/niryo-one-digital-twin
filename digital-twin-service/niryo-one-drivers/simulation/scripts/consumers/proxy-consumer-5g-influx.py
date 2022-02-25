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

import time
from threading import Timer
from collections import deque 
from influxdb import InfluxDBClient
import rospy
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
import datetime
import json
import requests
from sensor_msgs.msg import Joy
from std_msgs.msg import Bool
from os import environ
from threading import Thread




class Predictor:
  def __init__(self):
    self.session = requests.Session()

  def predict(self, input_data):
    url = 'http://10.5.4.21:5000/predict'
    #before_predict=rospy.Time.now()
    rsp = self.session.post(url, data = json.dumps({"data": input_data}), headers = {'Content-Type': 'application/json'})
    #after_predict=rospy.Time.now()
    #print((after_predict-before_predict).to_nsec()/float(1000000))
    forecast = rsp.json()
    msg = str(datetime.datetime.now()) + ": " + str(forecast) + ": forecasted answer"
    rospy.loginfo(msg)
    return [forecast[0][0], forecast[0][1], forecast[0][2], forecast[0][3], forecast[0][4], forecast[0][5]]

  def update(self, input_data,timestamp):
    url = 'http://10.5.4.21:5000/predict'
    api_data = [[input_data[0],input_data[1],input_data[2],input_data[3],input_data[4],input_data[5],timestamp.secs * 1000000000 + timestamp.nsecs,False]]
    #print(json.dumps({"data": api_data}))
    rsp = self.session.post(url, data = json.dumps({"data": api_data}), headers = {'Content-Type': 'application/json'})
    return True

class AIAgent:
  def __init__(self):
    self.predictor = Predictor()
    self.prediction = [[0, 0, 0, 0, 0, 0, 0, True]]
    self.timer = None
    self.pred = 0
    self.enable_predictions=False
    self.gripper_state=1
    self.gripper_last_state=1
    self.not_predict=True
    rospy.init_node('niryo_one_movement_prediction_var')
    self.last_cmd_stamp = rospy.Time.now()
    self.old = rospy.Time.now()
    self.pub = rospy.Publisher('/niryo_one_follow_joint_trajectory_controller/command',
                               JointTrajectory, queue_size=1, tcp_nodelay=True)
    self.sub = rospy.Subscriber('/proxy_consumer/command',
                                JointTrajectory,
                                self.callback_command_received)
    self.sub = rospy.Subscriber('/enable_predictions',
                                Bool,
                                self.callback_enable_predictions)
    self.sub_joy=rospy.Subscriber('/joy',
                                Joy,
                                self.callback_gripper_state)
    self.influx_client = InfluxDBClient('10.5.4.21')
    self.monitoring = False

  def callback_gripper_state(self,msg):
    if(msg.buttons[1]==1):
      self.gripper_state=2
    elif(msg.buttons[2]==1):
      self.gripper_state=1

  def callback_enable_predictions(self,msg):
    self.enable_predictions=msg.data
    if self.timer != None:
      self.timer.cancel()
      self.pred=0

  def move_to_position(self, pos, cmd_speed = 0.15):
    rtime = rospy.Time.now()
    msg = JointTrajectory()
    msg.header.stamp = rtime
    msg.joint_names = ['joint_1', 'joint_2', 'joint_3',
                       'joint_4', 'joint_5', 'joint_6']
    point = JointTrajectoryPoint()
    point.positions = pos
    point.time_from_start = rospy.Duration(cmd_speed)
    msg.points = [point]
    self.pub.publish(msg)
    self.last_cmd_stamp = rospy.Time.now()

  def callback_predict(self):
    if(self.gripper_state != self.gripper_last_state):
      #print("GRIPPER STATE CHANGEEEEE")
      self.timer.cancel()
      self.timer = Timer(5,self.callback_predict)
      self.timer.start()
      self.gripper_last_state=self.gripper_state
      return
    if self.timer != None:
      self.timer.cancel()
    self.timer = Timer(0.160, self.callback_predict)
    self.timer.start()
    msg = "executing prediction: " + str(self.pred)
    rospy.loginfo(msg)
    self.pred+=1
    now = rospy.Time.now()
    self.prediction = self.predictor.predict([[0,0,0,0,0,0,now.secs * 1000000000 + now.nsecs,True]])
    self.move_to_position(self.prediction)
    if self.monitoring:
      json_body = [
        {
          "measurement": "robot_joints",
          "tags":
          {
            "predictions": "True" # TODO tags?
          },
          "fields":
          {
            "joint_1": self.prediction[0],
            "joint_2": self.prediction[1],
            "joint_3": self.prediction[2]
          }
        }]
      try:
        self.influx_client.write_points(json_body)
      except Exception as e:
        print(e)

  
  def callback_command_received(self, joint_trajectory):
    now=rospy.Time.now()
    print(((now-self.old).to_nsec())/float(1000000))
    self.old=now
    if(self.enable_predictions==True):
      if self.timer != None:
          self.timer.cancel()
      self.timer = Timer(joint_trajectory.points[0].time_from_start.to_nsec()/float(1000000000) + 0.010, self.callback_predict)
      self.timer.start()
    self.move_to_position(joint_trajectory.points[0].positions)
    str_msg = str(datetime.datetime.now()) + ": " + str(joint_trajectory.points[0].positions)
    rospy.loginfo(str_msg)
    if self.monitoring:
      json_body = [
        {
          "measurement": "robot_joints",
          "tags":
          {
            "predictions": "False" # TODO tags?
          },
          "fields":
          {
            "joint_1": msg[0],
            "joint_2": msg[1],
            "joint_3": msg[2]
          }
        }]
      try:
        self.influx_client.write_points(json_body)
      except Exception as e:
        print(e)
    r = self.predictor.update(joint_trajectory.points[0].positions,now)

ai = AIAgent()
rospy.spin()

