--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-----------------------------------------------------------------------------------------------
--
------------------------------------------------------------------
-- Niryo One Threaded ROS simulation controller.
------------------------------------------------------------------
-- This is a non-theraded script linked to the Niryo One robot on the simulation.  

------------------------------------------------------------------
-- Helper Functions
------------------------------------------------------------------

function closeGripper()
    if isGripperOpen then
        if DEBUG_LEVEL == 1 then 
            print("Opening gripper")
        end 
        sim.setIntegerSignal(gripperName..'_close',1)
        isGripperOpen = false
    end
end

function openGripper()
    if not isGripperOpen then 
        if DEBUG_LEVEL == 1 then 
            print("Closing gripper")
        end
        sim.clearIntegerSignal(gripperName..'_close')
        isGripperOpen = true
    end 
end

function setTargetJointPositions(remoteTargetVector)
    local targetVector = remoteTargetVector
    for i=1,#targetVector do
        if sim.setJointTargetPosition(JointHandles[i], targetVector[i]) == -1 then
            print("<font color='#F00'>Cannot set joint to target position:  ".. targetVector[i] .." </font>@html")
        end 
    end 
end

function getJointVelocityVector(targetVel) 
    step = sim.getSimulationTimeStep()
    if step == -1 then 
        print("<font color='#F00'>Could not get simulation time step. </font>@html")
        return
    end
    for i=1,6 do
        -- targetVel[i] = (previousJointPosition[i]-targetJointPosition[i])/step
        targetVel[i] = 0
    end
end

function getJointPositionVector(targetJointPosition) 
    previousJointPosition = targetJointPosition
    for i=1,6 do
        targetJointPosition[i] = sim.getJointPosition(JointHandles[i])
    end
end 

function getJointForceVector(targetJointForce)
    for i=1,6 do
        targetJointForce[i] = sim.getJointForce(JointHandles[i])
    end
end


function get_array_string(arr) 
    str = "[ "..tonumber(string.format("%.4f", arr[1]))
    for i=2,#arr do
        if (i==#arr) then 
            str = str..", "..tonumber(string.format("%.4f", arr[i])).." ]"
        else
            str = str..", "..tonumber(string.format("%.4f", arr[i]))
        end 
    end
    return str
end 


function print_simulation_status(pos, vel, eff, openGripper)

    pos_str = get_array_string(pos)
    vel_str = get_array_string(vel)
    eff_str = get_array_string(eff)
    griper_str = function(b) if b then return "yes" else return "no" end end
    sim_time = tonumber(string.format("%.4f", sim.getSimulationTime())) -- Time in seconds 

    print("#######################################################")
    print("Simulation has been running for "..sim_time.." seconds.")
    print("Is gripper open? -> "..griper_str(openGripper))
    print("Joint arm kinematics: ")
    print("  Positions: "..pos_str)
    print("  Velocities: "..vel_str)
    print("  Efforts: "..eff_str)
end


--------------------------
-- SUBSCRIBER CALLBACKS --
--------------------------

function phyJointStateUpdateCallback(msg)
    -- Received a change on the state of the robot joints. 
    -- Update the model and propagate the state variables.
    table.insert(state_sequence_buffer, msg.position)
end 

function gripperJoystickControlCallback(msg)
    open_button     = msg.buttons[3]
    close_button    = msg.buttons[2]
end

function gripperCommandCallback(msg)
    open_gripper = msg.data 
    if (open_gripper) then
        open_gripper()
    else
        closeGripper() 
    end
end

--------------------------
-- SIMULATION LOOP      -- 
--------------------------

function sysCall_actuation() 
    if simROS then 
        -- Actuate last received robot position. 
        if #state_sequence_buffer>0 then
            if DEBUG_LEVEL == 1 then 
                print("Setting joint positions on digital twin.")
            end 
            new_joint_state = state_sequence_buffer[1]  -- Get the first element.
            table.remove(state_sequence_buffer, 1)      -- consume it.
            setTargetJointPositions(new_joint_state);   -- Actuate.
        end

        -- Actuate gripper state.
        if open_button==1 then 
            openGripper()
            open_button = 0
        end
        if close_button==1 then 
            closeGripper()
            close_button = 0
        end
    end
end

function sysCall_init()
    -- If 0 No debug messages
    -- If 1 print all trace events. 
    DEBUG_LEVEL = 0
    -- Generate the handles of the joints to actuate on the robot.
    JointHandles={-1,-1,-1,-1,-1,-1}
    for i=1,6,1 do
        JointHandles[i]=sim.getObjectHandle('NiryoOneJoint'..i)
        -- Set torque/force mode on the joint. 
        --  In this mode, the joint is simulated by the dynamics module, 
        --  if and only if it is dynamically enabled
        sim.setJointMode(JointHandles[i], sim.jointmode_force, 0)
    end

    -- Get a connection to the gripper of the robot, which is initially open.
    connection=sim.getObjectHandle('NiryoOne_connection')
    gripper=sim.getObjectChild(connection,0)
    gripperName="NiryoNoGripper"
    if gripper~=-1 then
        gripperName=sim.getObjectName(gripper)
    end

    if simROS then 
        print("<font color='#0F0'>ROS interface was found.</font>@html")

        SIM_TOPIC_ROOT          = "/coppeliaSIM/NiryoOne"
        -- Simulated Twin Topics
        SIM_TIME_TOPIC          = SIM_TOPIC_ROOT.."/simulation_time" 
        SIM_JOINT_STATE_TOPIC   = SIM_TOPIC_ROOT.."/joint_states"
        -- Gripper Control Topic Names 
        OPEN_SIM_GRIPPER  = SIM_TOPIC_ROOT.."/gripper_command"
        SIM_GRIPPER_STATE = SIM_TOPIC_ROOT.."/is_gripper_open" 
        -- Physical Twin Topics
        JOINT_STATE_TOPIC   = "/joint_states"
        JOY_TOPIC           = "/joy"

        -- The target angular position we want the joints in is a global variable to be updated
        -- on callback.
        targetJointPosition     = {0,0,0,0,0,0} 
        previousJointPosition   = targetJointPosition
        setTargetJointPositions({0.0, 0.640187, -1.397485, 0.0, 0.0, 0.0}) 
        -- This is a queue to temporarily store the states arriving to the digital twin
        state_sequence_buffer = {}

        -- Digital Twin Mirror --> Receive desired state from a simulation client and send back 
        --                         joint or tool state of the simulation model.
        JointStatePubDig        = simROS.advertise(SIM_JOINT_STATE_TOPIC,'sensor_msgs/JointState', 1, false)
        gripperStatePublisher   = simROS.advertise(SIM_GRIPPER_STATE,   'std_msgs/Bool', 1, false)
        simTimePub              = simROS.advertise(SIM_TIME_TOPIC, 'std_msgs/Float32', 1, false)

        -- The gripper is non-standard, we need to fetch its state directly from the control 
        -- code or the joystick command. 
        openGripperCommand      = simROS.subscribe(OPEN_SIM_GRIPPER,    'std_msgs/Bool',    'gripperCommandCallback', 1)
        joystickGripperCommand  = simROS.subscribe(JOY_TOPIC,           'sensor_msgs/Joy',  'gripperJoystickControlCallback', 1)
        -- Physical Twin Mirror --> Mirror state published by the physical twin.
        JointStateSubPhy        = simROS.subscribe(JOINT_STATE_TOPIC, 'sensor_msgs/JointState', 'phyJointStateUpdateCallback', 1)

        if  JointStatePubDig < 0 or 
            gripperStatePublisher < 0 or 
            simTimePub < 0 or
            openGripperCommand < 0 or 
            joystickGripperCommand < 0 or 
            JointStateSubPhy < 0 then 
                print("<font color='#F00'>Error setting up publishers and subscribers. Stopping simulation.</font>@html")
                sim.stopSimulation()
            end
        -- GripperController --> Receive desired state from a simulation client.
        -- We will assume gripper is open at startup. 
        isGripperOpen       = true 
        open_gripper        = true
        open_button         = 0
        close_button        = 0
        print_time          = 0
    else
        print("<font color='#F00'>ROS interface was not found. Cannot run.</font>@html")
        print("Is the ros master ready and reachable?")
        sim.stopSimulation()
    end
end

function sysCall_sensing()
    if simROS then
        -- Publish simulation state to the ROS network to consume. 
        simROS.publish(gripperStatePublisher,   {data=isGripperOpen})
        simROS.publish(simTimePub,              {data=sim.getSimulationTime()})
        
        local pos = {0, 0, 0, 0, 0, 0}
        local vel = {0, 0, 0, 0, 0, 0}
        local eff = {0, 0, 0, 0, 0, 0}
        -- Fetch simulation model joint state
        getJointPositionVector(pos)
        getJointVelocityVector(vel)
        getJointForceVector(eff)

        simROS.publish(JointStatePubDig, {
            position = pos, 
            velocity = vel, 
            effort   = eff 
        })

        if (print_time + 0.5  <= sim.getSimulationTime()) then 
            print_simulation_status(pos, vel, eff, isGripperOpen)
            print_time = sim.getSimulationTime()
        end
        
    end
end

function sysCall_cleanup()
    simROS.shutdownPublisher(simTimePub)
    simROS.shutdownPublisher(gripperStatePublisher)
    simROS.shutdownPublisher(JointStatePubDig)
    
    simROS.shutdownSubscriber(JointStateSubPhy)
    simROS.shutdownSubscriber(openGripperCommand)
    simROS.shutdownSubscriber(joystickGripperCommand)
end
