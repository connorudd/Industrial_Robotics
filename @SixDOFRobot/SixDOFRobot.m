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
            % Define the links using DH parameters
            L1 = Link('d',0.15185,'a',obj.linkLengths(1),'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            L2 = Link('d',0,'a',obj.linkLengths(2),'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            L3 = Link('d',0,'a',obj.linkLengths(3),'alpha',pi,'qlim', deg2rad([-360 360]), 'offset', 0);
            L4 = Link('d',0.13105,'a',obj.linkLengths(4),'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            L5 = Link('d',0.08535,'a',obj.linkLengths(5),'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            L6 = Link('d',0.0921,'a',obj.linkLengths(6),'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            
            % Create the serial link robot
            robotModel = SerialLink([L1, L2, L3, L4, L5, L6], 'name', '6DOF Robot');
            

        end
        
        function obj = updateJointAngles(obj, newAngles, baseTransform)
            % Update the joint angles
            obj.jointAngles = newAngles;
        
            % Set the robot's base transformation
            obj.robot.base = baseTransform;
            
            % Plot the robot
            obj.robot.plot(obj.jointAngles, 'noarrow');
        

        end
        
        function position = endEffectorPosition(obj)
            % Calculate the end-effector position
            position = obj.robot.fkine(obj.jointAngles);
        end
    end
end
