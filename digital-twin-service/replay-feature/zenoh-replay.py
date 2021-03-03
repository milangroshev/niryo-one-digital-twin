#!/usr/bin/python3
import os
import sys
import rospy
from zenoh import Zenoh, Value
from datetime import datetime, timedelta
import json
from flask import Flask, Blueprint, request, after_this_request
from sensor_msgs.msg import JointState
from numpy import linspace
from pprint import pprint


# Data pushed by a robot
storage_path = '/mystorage'

def create_app(workspace, rostopic, sample_rate, duration):
    app = Flask(__name__)
    return app

def get_zenoh_data(workspace, selector):
    zenoh_data = []
    for data in workspace.get(selector):
        _, _, m, s, n = data.path.split('/')
        m = int(m)
        s = int(s)
        n = int(n)
        timestamp = data.timestamp.time.strftime("%Y/%m/%d, %H:%M:%S")
        zenoh_entry = {'m': m, 's': s, 'n': n,
                        'value': data.value.get_content(), 'timestamp': timestamp}
        zenoh_data.append(zenoh_entry)
    return zenoh_data

def get_data(workspace, duration):
    x2 = datetime.now()
    delta = timedelta(seconds=duration)
    x1 = x2 - delta
    x2_min = x2.minute
    x2_sec = x2.second
    x1_min = x1.minute
    x1_sec = x1.second
    selected_data = []
    if x2_min > x1_min: 
        l1 = linspace(x1_sec, 59, 59 - x1_sec + 1, dtype=int)
        l2 = linspace(0, x2_sec, x2_sec + 1, dtype=int)
        for l in l1:
           selector = storage_path + '/' + str(x1_min) + '/' +  str(l) + '/**'
           zenoh_data = get_zenoh_data(workspace, selector)
           selected_data = selected_data + sorted(zenoh_data, key=lambda k: k['n'])
        for l in l2:
           selector = storage_path + '/' + str(x2_min) + '/' +  str(l) + '/**'
           zenoh_data = get_zenoh_data(workspace, selector)
           selected_data = selected_data + sorted(zenoh_data, key=lambda k: k['n'])
    elif x1_min == x2_min:
        l = linspace(x1_sec, x2_sec, x2_sec - x1_sec + 1, dtype=int)
        for ll in l:
           selector = storage_path + '/' + str(x1_min) + '/' + str(ll) + '/**'
           zenoh_data = get_zenoh_data(workspace, selector)
           selected_data = selected_data + sorted(zenoh_data, key=lambda k: k['n'])
    
    return selected_data

# def get_last_minute_data(workspace):
    # selector = storage_path + '/**'
    # timestamps = []
    # output_data = []
    # for data in workspace.get(selector):
    #     _, _, m, s, n = data.path.split('/')
    #     m = int(m)
    #     s = int(s)
    #     n = int(n)
    #     timestamps.append((m, s, n))
    #     timestamp = data.timestamp.time.strftime("%Y/%m/%d, %H:%M:%S")
    #     output_entry = {'m': m, 's': s, 'n': n,
    #                     'value': data.value.get_content(), 'timestamp': timestamp}
    #     output_data.append(output_entry)
    # sorted_output_data = sorted(output_data, key=lambda k: k['n'])
    # sorted_timestamps = sorted(timestamps, key=lambda k: k[2])
    
    # last_minute = sorted_timestamps[-1][0]
    # last_second = sorted_timestamps[-1][1]
    # if last_minute > 0:
    #     target_second = last_minute*60 + last_second - 60 + 1
    #     target_timestamp = (target_second // 60, target_second % 60)
    #     selected_samples = [i for ts in timestamps if (ts[i][0], ts[i][1] == target_timestamp)]
    #     index = timestamps.index(selected_samples[0])
    #     return sorted_output_data[index:]
    # else:
    #     return sorted_output_data

def ros_publisher(robot_data, rostopic, sample_rate):
    pub = rospy.Publisher(rostopic, JointState, queue_size=10)
    rospy.init_node('publisher', disable_signals=True, anonymous=True)
    rate = rospy.Rate(sample_rate)
    seq = 0
    while not rospy.is_shutdown():
        for data in robot_data:
            #print("\ndebug: ", data)
            joint_state = JointState()
            pos_val = data['value']
            # add timestamp
            # joint_state.position  = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0] # change this 
            joint_state.position = [float(pos_val['x1']), float(pos_val['x2']),
                                   float(pos_val['y1']), float(pos_val['y2']),
                                   float(pos_val['z1']), float(pos_val['z2'])]
            joint_state.header.stamp = rospy.Time.now()
            joint_state.header.seq = seq
            joint_state.name = ['joint_1', 'joint_2', 'joint_3', 'joint_4', 'joint_5', 'joint_6']
            joint_state.velocity  = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            joint_state.effort = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            pub.publish(joint_state)
            seq = seq + 1
            rate.sleep()

route_blueprint = Blueprint('route_blueprint', __name__)
@route_blueprint.route('/lastminute', methods=['POST', 'DELETE'])
def replay_last_minute():
    if request.method == 'POST':
        robot_data = get_data(workspace, duration)
        ros_publisher(robot_data, rostopic, sample_rate)
        return "200"
    elif request.method == 'DELETE':
        rospy.signal_shutdown("Stopping last minute replay...")
        print("Now re-run server")
        # @after_this_request
        # def run_server():
        os.execv(sys.executable, [sys.executable] + sys.argv)
        return "202"

if __name__=="__main__":
    if len(sys.argv) < 5:
        print("Usage <address of zenohd router> <rostopic> <rostopic hz> <replay secs>")
    address = sys.argv[1]
    rostopic = sys.argv[2]
    sample_rate = int(sys.argv[3])
    duration = int(sys.argv[4])

    conf = {
      'mode': 'client',
      'peer': '{}'.format(address),
    }

    print("Opening Zenoh session...")
    zenoh = Zenoh(conf)
    print("Server connected to Zenoh router {}, publishing on rostopic {}, at rate {}".format(address, rostopic, sample_rate))
    # Zenoh workspace creation
    print("New Zenoh workspace...")
    workspace = zenoh.workspace(storage_path)

    app = create_app(workspace, rostopic, sample_rate, duration)
    app.register_blueprint(route_blueprint)
    app.run(host='0.0.0.0', port=5000, debug=True)

    # Shutting down Zenoh
    zenoh.close()
