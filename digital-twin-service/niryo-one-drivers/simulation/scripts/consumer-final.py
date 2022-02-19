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

import rospy
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
import datetime
import json
import requests
from sensor_msgs.msg import Joy
from std_msgs.msg import Bool

class Predictor:
  def __init__(self):
    self.session = requests.Session()

  def predict(self, input_data):
    url = 'http://10.5.4.21:5000/predict'
    rsp = self.session.post(url, data = json.dumps({"data": input_data}), headers = {'Content-Type': 'application/json'})
    forecast = rsp.json()
    print(str(datetime.datetime.now()) + ": " + str(forecast) + ": forecasted answer")
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
    rospy.init_node('niryo_one_movement_prediction_var')
    self.old = rospy.Time.now()
    self.pub = rospy.Publisher('/niryo_one_follow_joint_trajectory_controller/command',
                               JointTrajectory, queue_size=1, tcp_nodelay=True)
    self.sub = rospy.Subscriber('/niryo_one_follow_joint_trajectory_controller/command',
                                JointTrajectory,
                                self.callback_command_received)
    self.sub = rospy.Subscriber('/enable_predictions',
                                Bool,
                                self.callback_enable_predictions)
    self.sub_joy=rospy.Subscriber('/joy',
                                Joy,
                                self.callback_gripper_state)

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

  def callback_predict(self):
    if(self.gripper_state != self.gripper_last_state):
      print("GRIPPER STATE CHANGEEEEE")
      self.timer.cancel()
      self.timer = Timer(2,self.callback_predict)
      self.timer.start()
      self.gripper_last_state=self.gripper_state
      return
    print("executing prediction: " + str(self.pred))
    self.pred+=1
    now = rospy.Time.now()
    self.prediction = self.predictor.predict([[0,0,0,0,0,0,now.secs * 1000000000 + now.nsecs,True]])
    self.move_to_position(self.prediction)

  def callback_command_received(self, joint_trajectory):
    if(self.enable_predictions==True):
      now = rospy.Time.now()
      cmd_stamp=joint_trajectory.header.stamp
      #print((now-self.old).to_nsec()/float(1000000))
      print(str(datetime.datetime.now()) + ": " + str(joint_trajectory.points[0].positions)+": "+str(joint_trajectory.header.seq))   
      self.old = now
      #print("command arrived")
      #print((now - joint_trajectory.header.stamp).to_nsec()/float(1000000))
      if (joint_trajectory.header.seq == 1):
          if self.timer != None:
              self.timer.cancel()
          #print(joint_trajectory.points[0].time_from_start.to_nsec()/float(1000000000)+0.01)
          self.timer = Timer(joint_trajectory.points[0].time_from_start.to_nsec()/float(1000000000) + 0.001,self.callback_predict)
          self.timer.start()
          r = self.predictor.update(joint_trajectory.points[0].positions,now)
          return

      if (joint_trajectory._connection_header['callerid']=='niryo_one_movement_prediction_var'):
          positions = joint_trajectory.points[0].positions
          self.cmds.append(positions)
          r = self.predictor.update(joint_trajectory.points[0].positions,now)
          #self.prediction = self.predictor.predict([elem for elem in self.cmds])
          return
      else:
          if self.timer != None:
            self.timer.cancel()
          self.timer = Timer(joint_trajectory.points[0].time_from_start.to_nsec()/float(1000000000) + 0.002, self.callback_predict)
          self.timer.start()
          positions = joint_trajectory.points[0].positions
          r = self.predictor.update(joint_trajectory.points[0].positions,now)
          #self.prediction = self.predictor.predict([elem for elem in self.cmds])

ai = AIAgent()
rospy.spin()
