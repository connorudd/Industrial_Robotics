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
            %L1 = Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            %L1 = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [0, obj.linkLengths(1)]); % Prismatic joint
            % L1 = Link('d', 0, 'a', obj.linkLengths(2), 'alpha', 0, 'qlim', [-pi, pi]);
            % L2 = Link('d', 0, 'a', obj.linkLengths(2), 'alpha', 0, 'qlim', [-pi, pi]);
            % L3 = Link('d', 0, 'a', obj.linkLengths(3), 'alpha', 0, 'qlim', [-pi, pi]);
            % L4 = Link('d', 0, 'a', obj.linkLengths(4), 'alpha', 0, 'qlim', [-pi/2, pi/2]);
            % L5 = Link('d', 0, 'a', obj.linkLengths(5), 'alpha', 0, 'qlim', [-pi/2, pi/2]);
            % L6 = Link('d', 0, 'a', obj.linkLengths(6), 'alpha', 0, 'qlim', [-pi, pi]);
            
            L1 = Link('d',0.15185,'a',obj.linkLengths(1),'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            L2 = Link('d',0,'a',obj.linkLengths(2),'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            L3 = Link('d',0,'a',obj.linkLengths(3),'alpha',pi,'qlim', deg2rad([-360 360]), 'offset', 0);
            L4 = Link('d',0.13105,'a',obj.linkLengths(4),'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            L5 = Link('d',0.08535,'a',obj.linkLengths(5),'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            L6 = Link('d',	0.0921,'a',obj.linkLengths(6),'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            
            % Create the serial link robot
            robotModel = SerialLink([L1, L2, L3, L4, L5, L6], 'name', '6DOF Robot');
        end
        
        function obj = updateJointAngles(obj, newAngles)
    % Update the joint angles
    obj.jointAngles = newAngles;
    
    % Set the link and joint thickness
    linkColor = 'b'; % Color of the links
    jointColor = 'r'; % Color of the joints
    linkWidth = 0.02; % Width of the links
    jointWidth = 0.02; % Width of the joints

    % Clear the previous plot
    clf; 
    
    % Plot the robot with customized properties
    obj.robot.plot(obj.jointAngles, 'noarrow');
    set(findobj(gca, 'Type', 'line', 'Color', linkColor), 'LineWidth', linkWidth); % Set link thickness
    set(findobj(gca, 'Type', 'line', 'Color', jointColor), 'MarkerSize', jointWidth); % Set joint thickness

    % Set axes properties
    grid on;
    view(3);
    axis equal;
    title('6DOF Robot on Linear Rail');
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
end

        
        function position = endEffectorPosition(obj)
            % Calculate the end-effector position
            position = obj.robot.fkine(obj.jointAngles);
        end
    end
end
