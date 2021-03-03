#!/usr/bin/python3
import sys
import zenoh
from zenoh import Zenoh, Value
import time
from datetime import datetime
import rospy
from sensor_msgs.msg import JointState

# Data pushed by a robot
storage_path = '/mystorage'

def callback_joint_states(joint_states, args):
    global sample_id
    position = joint_states.position
    position = [round(pos, 4) for pos in position]
    x1, x2, y1, y2, z1, z2 = position
    # Zenoh data format
    value = { 'x1': str(x1), 'y1': str(y1), 'z1': str(z1),
              'x2': str(x2), 'y2': str(y2), 'z2': str(z2) }

    now = datetime.now()
    minute_id = str(now.minute)
    second_id = str(now.second)
    

    # Zenoh path
    sample_path = minute_id + '/' + second_id + '/' + str(sample_id)
    workspace.put(sample_path, value)
    sample_id = sample_id + 1

if __name__=="__main__":
    if len(sys.argv) < 3:
        print("Usage <address of zenohd router> <rostopic> <rostopic hz>")
    address = sys.argv[1]
    rostopic = sys.argv[2]
    sample_id = 0

    conf = {
      'mode': 'client',
      'peer': '{}'.format(address),
    }

    print("Opening Zenoh session...")
    zenoh = Zenoh(conf)

    # Create a new storage called my-storage
    path = '/@/router/local/plugin/storages/backend/memory/storage/my-storage'

    # Workspace creation
    print("New Zenoh workspace...")
    storage = zenoh.workspace()

    # Clearing the router
    print("Clearing the router first..")
    try:
        storage.delete(storage_path)
        print("Clear router")
    except Exception:
        print("Router is good")
        pass

    # Storage creation
    print("Creating storage...")
    value = {"path_expr": storage_path + '/**'}
    storage.put(path, value)
    workspace = zenoh.workspace(storage_path)
    now = datetime.now()
    print("Robot data acquisition started at:", now)

    # Setting up ROS publisher node
    rospy.init_node('zenoh_subscriber', disable_signals=True)
    sub = rospy.Subscriber(rostopic, JointState, callback_joint_states,
                           (zenoh, workspace, sample_id))

    rospy.spin()
    zenoh.close()
    now = datetime.now()
    print("Robot data acquisition stopped at:", now)
    print("Number of samples acquired:", sample_id - 1)
