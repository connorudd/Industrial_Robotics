% classdef SixDOFRobot
%     properties
%         % Joint parameters
%         jointAngles % Current joint angles (in radians)
%         linkLengths % Lengths of the robot links
%         robot % Robot model
%         plyFileNameStem = 'SixDOFRobot';
%     end
% 
%     methods
%         function obj = SixDOFRobot(linkLengths)
%             % Constructor to initialize link lengths and joint angles
%             obj.linkLengths = linkLengths;
%             obj.jointAngles = zeros(1, 6); % Initialize joint angles to zero
%             obj.robot = obj.createRobotModel();
%         end
% 
%         function robotModel = createRobotModel(obj)
%             % Define the links using DH parameters
%             L1 = Link('d',0.15185,'a',obj.linkLengths(1),'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
%             L2 = Link('d',0,'a',obj.linkLengths(2),'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
%             L3 = Link('d',0,'a',obj.linkLengths(3),'alpha',pi,'qlim', deg2rad([-360 360]), 'offset', 0);
%             L4 = Link('d',0.13105,'a',obj.linkLengths(4),'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
%             L5 = Link('d',0.08535,'a',obj.linkLengths(5),'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
%             L6 = Link('d',0.0921,'a',obj.linkLengths(6),'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
% 
%             % Create the serial link robot
%             robotModel = SerialLink([L1, L2, L3, L4, L5, L6], 'name', '6DOF Robot');
% 
%         end
% 
%         function obj = updateJointAngles(obj, newAngles, baseTransform)
%             % Update the joint angles
%             obj.jointAngles = newAngles;
% 
%             % Set the robot's base transformation
%             obj.robot.base = baseTransform;
% 
%             % Plot the robot
%             obj.robot.plot(obj.jointAngles, 'noarrow');
% 
% 
%         end
% 
%         function position = endEffectorPosition(obj)
%             % Calculate the end-effector position
%             position = obj.robot.fkine(obj.jointAngles);
%         end
%     end
% end

classdef SixDOFRobot
    properties
        % Joint parameters
        jointAngles % Current joint angles (in radians)
        linkLengths % Lengths of the robot links
        robot       % Robot model
        plyFileNameStem = 'SixDOFRobotLink'; % Base name for .ply files
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
            L1 = Link('d', 0.15185, 'a', obj.linkLengths(1), 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            L2 = Link('d', 0, 'a', obj.linkLengths(2), 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            L3 = Link('d', 0, 'a', obj.linkLengths(3), 'alpha', pi, 'qlim', deg2rad([-360 360]), 'offset', 0);
            L4 = Link('d', 0.13105, 'a', obj.linkLengths(4), 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            L5 = Link('d', 0.08535, 'a', obj.linkLengths(5), 'alpha', -pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            L6 = Link('d', 0.0921, 'a', obj.linkLengths(6), 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);

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

            % Attach .ply models to the links
            obj.attachPlyModels();
        end

function attachPlyModels(obj)
    % Attach the .ply models to each link of the robot
    for i = 1:length(obj.robot.links)
        % Generate the filename for the corresponding .ply file
        plyFile = sprintf('%s%d.ply', obj.plyFileNameStem, i);

        % Read the .ply file
        [f, v, data] = plyread(plyFile, 'tri');

        % Compute the transformation matrix for the current link using fkine
        tr = obj.robot.fkine(obj.jointAngles); % Get the transformation matrix for the end effector
        % Print out the transformation matrix
        disp(['Transformation matrix for link ', num2str(i), ':']);
        disp(tr);
        disp(size(tr));

        % Assuming the transformation for each link can be computed as:
        % Get the transformation matrix for link i
        tr_link = obj.robot.A(i, obj.jointAngles); % Use fkine instead of A if necessary

        % Check if the transformation is in 4x4 homogeneous form
        if size(tr_link, 1) == 4
            % Apply the transformation directly to vertices in homogeneous coordinates
            v_hom = [v, ones(size(v, 1), 1)]';  % Convert to homogeneous coordinates
            transformedVertices_hom = tr_link * v_hom; % Apply transformation
            transformedVertices = transformedVertices_hom(1:3, :)';  % Convert back to Cartesian
        else
            % Assuming the transformation is in the form of [R; t]
            R = tr_link(1:3, 1:3);  % Rotation matrix
            t = tr_link(1:3, 4);    % Translation vector
            transformedVertices = (R * v')' + t';  % Apply rotation and translation
        end

        % Extract color data (if available) and normalize the values
        if isfield(data, 'vertex') && isfield(data.vertex, 'red')
            vertexColors = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        else
            vertexColors = repmat([0.8, 0.8, 0.8], size(v, 1), 1); % Default to gray if no color info
        end

        % Plot the .ply model using patch
        patch('Vertices', transformedVertices, 'Faces', f, ...
              'FaceVertexCData', vertexColors, 'FaceColor', 'interp', 'EdgeColor', 'none');

        hold on;
    end

    axis equal;
    hold off;
end





        function position = endEffectorPosition(obj)
            % Calculate the end-effector position
            position = obj.robot.fkine(obj.jointAngles);
        end
    end
end
