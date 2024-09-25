classdef SixDOFRobot
    properties
        % Joint parameters
        jointAngles % Current joint angles (in radians)
        linkLengths % Lengths of the robot links
        robot % Robot model
    end
    
    methods
        function obj = SixDOFRobot(linkLengths)
            % Constructor to initialize link lengths and joint angles
            obj.linkLengths = linkLengths;
            obj.jointAngles = zeros(1, 6); % Initialize joint angles to zero
            obj.robot = obj.createRobotModel();
        end
        
        function robotModel = createRobotModel(obj)
            % Create the robot model using Robotics Toolbox
            
            % Link 1 as a prismatic joint (linear rail)
            L1 = Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            %L1 = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [0, obj.linkLengths(1)]); % Prismatic joint
            L2 = Link('d', 0, 'a', obj.linkLengths(2), 'alpha', 0, 'qlim', [-pi, pi]);
            L3 = Link('d', 0, 'a', obj.linkLengths(3), 'alpha', 0, 'qlim', [-pi, pi]);
            L4 = Link('d', obj.linkLengths(4), 'a', 0, 'alpha', pi/2, 'qlim', [-pi/2, pi/2]);
            L5 = Link('d', 0, 'a', obj.linkLengths(5), 'alpha', -pi/2, 'qlim', [-pi/2, pi/2]);
            L6 = Link('d', 0, 'a', obj.linkLengths(6), 'alpha', 0, 'qlim', [-pi, pi]);
            
            L1.qlim = [0 1];
            % Create the serial link robot
            robotModel = SerialLink([L1, L2, L3, L4, L5, L6], 'name', '6DOF Robot');
        end
        
        function obj = updateJointAngles(obj, newAngles)
            % Update the joint angles
            obj.jointAngles = newAngles;
            obj.robot.plot(obj.jointAngles);
        end
        
        function position = endEffectorPosition(obj)
            % Calculate the end-effector position
            position = obj.robot.fkine(obj.jointAngles);
        end
    end
end
