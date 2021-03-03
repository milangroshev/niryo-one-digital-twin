#!/usr/bin/python2

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
import socket

import rospy
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
from moveit_ros_planning_interface import _moveit_move_group_interface
from moveit_commander import MoveGroupCommander
from niryo_one_python_api.niryo_one_api import *

from niryo_one_msgs.srv import SetInt


def move_to_position_control(c, pos, cmd_speed = 0.020):
  msg = JointTrajectory()
  msg.header.stamp = rospy.Time.now()
  msg.joint_names = ['joint_1', 'joint_2',
                     'joint_3', 'joint_4',
                     'joint_5', 'joint_6']

  point = JointTrajectoryPoint()
  point.positions = pos
  point.time_from_start = rospy.Duration(cmd_speed)
  msg.points = [point]
  c.publish(msg)
  time.sleep(cmd_speed)

def move_to_position_moveit(m, pos):
  m.go(pos, wait=True)

def move_to_position_interface(n, pos):
  n.move_joints(pos)

### MAIN ###
rospy.init_node('niryo_one_web_interface')

### Initialize all the interfacing clients
c = rospy.Publisher('/niryo_one_follow_joint_trajectory_controller/command',
                    JointTrajectory, queue_size=1)
time.sleep(2)
  
m = MoveGroupCommander("arm")
time.sleep(2)

n = NiryoOne()
n.change_tool(TOOL_GRIPPER_2_ID)
is_gripper_closed = True
is_calibrated = False
time.sleep(2)

print("[ROS-MIDDLEWARE] All interfacing clients are initializaed!")
###

IP = '127.0.0.1'
PORT = 5005

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind((IP, PORT))

while True:
  try:
    message, addr = s.recvfrom(1024)
    if not message: continue

    print("[ROS-MIDDLEWARE] Message:", message)
    str_split = message.decode().split(',')
    str_split = [x.rstrip() for x in str_split]
    
    if str_split[0] == "calibration":
      if float(str_split[1]) == 0: # calibration release
        request_request = rospy.ServiceProxy('/niryo_one/request_new_calibration', SetInt)
        request_request(1)
        is_calibrated = False
      elif float(str_split[1]) == 1: # calibration auto
        n.calibrate_auto()
        is_calibrated = True
      elif float(str_split[1]) == 2: # calibration manual
        n.calibrate_manual()
        is_calibrated = True

    elif str_split[0] == "joystick":
      if float(str_split[1]) == 0:
        n.enable_joystick(False)
      elif float(str_split[1]) == 1:
        n.enable_joystick(True)

    elif (str_split[0] == "control" or str_split[0] == "moveit" or str_split[0] == "interface") and is_calibrated == True:
      # Map message values to Niryo One joints
      position = [float(str_split[1]), float(str_split[2]), float(str_split[3]), float(str_split[5]), float(str_split[4]), float(str_split[6])]

      # Conversion to joint values of Niryo One
      position[0] = (position[0] - 90)
      position[1] = (position[1] - 90)
      position[2] = (position[2] - 180)
      position[3] = (position[3] - 90)
      position[4] = (position[4] - 180)
      position[5] = (position[5] - 0)
      # Convert to rad
      position = [x * 3.14 / 180 for x in position]
      # Adjustment of middle joint to face the initial position of web interface
      position[2] += 1.57

      # Publish position to the Niryo One
      if str_split[0] == "interface":
        move_to_position_interface(n, position)
      elif str_split[0] == "moveit":
        move_to_position_moveit(m, position)
      elif str_split[0] == "control":
        move_to_position_control(c, position, float(str_split[7]) / 1000)
      else:
        print("[ROS-MIDDLEWARE] Wrong interfacing option...")

      if float(str_split[8]) == 0:
        if is_gripper_closed == False:
          n.close_gripper(TOOL_GRIPPER_2_ID, 500)
          is_gripper_closed = True
      else:
        if is_gripper_closed == True:
          n.open_gripper(TOOL_GRIPPER_2_ID, 500)
          is_gripper_closed = False 

    s.sendto("success", addr)
  except socket.timeout:
    pass # Do nothing, listen again
  except:
    s.sendto("error", addr)

