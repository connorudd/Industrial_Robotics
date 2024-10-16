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

% classdef SixDOFRobot
%     properties
%         % Joint parameters
%         jointAngles % Current joint angles (in radians)
%         linkLengths % Lengths of the robot links
%         robot       % Robot model
%         plyFileNameStem = 'SixDOFRobotLink'; % Base name for .ply files
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
%             L1 = Link('d', 0.15185, 'a', obj.linkLengths(1), 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
%             L2 = Link('d', 0, 'a', obj.linkLengths(2), 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
%             L3 = Link('d', 0, 'a', obj.linkLengths(3), 'alpha', pi, 'qlim', deg2rad([-360 360]), 'offset', 0);
%             L4 = Link('d', 0.13105, 'a', obj.linkLengths(4), 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
%             L5 = Link('d', 0.08535, 'a', obj.linkLengths(5), 'alpha', -pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
%             L6 = Link('d', 0.0921, 'a', obj.linkLengths(6), 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
% 
%             % Create the serial link robot
%             robotModel = SerialLink([L1, L2, L3, L4, L5, L6], 'name', '6DOF Robot');
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
%             % Attach .ply models to the links
%             % obj.attachPlyModels(newAngles);
%         end
% % 
% %         function attachPlyModels(obj, q)
% %     % Attach the .ply models to each link of the robot
% %     for i = 1:6
% %         T = obj.robot.A(1:i, q).T;
% %         R = T(1:3, 1:3);
% %         % Generate the filename for the corresponding .ply file
% %         plyFile = sprintf('%s%d.ply', obj.plyFileNameStem, i);
% % 
% %         % Read the .ply file
% %         [f, v, data] = plyread(plyFile, 'tri');
% % 
% %         % Extract color data (if available) and normalize the values
% %         if isfield(data, 'vertex') && isfield(data.vertex, 'red')
% %             vertexColors = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
% %         else
% %             vertexColors = repmat([0.8, 0.8, 0.8], size(v, 1), 1); % Default to gray if no color info
% %         end
% % 
% %             % Scale the vertices
% %             v_scaled = v * 0.003;  % Scale the vertices by the given factor
% % 
% %             % Rotate the vertices using the rotation matrix from the transformation
% %             v_rotated = (R * v_scaled')';  % Rotate the vertices
% % 
% %             % Translate the vertices using the translation part of the transformation
% %             v_translated = v_rotated + T(1:3, 4)';  % Add the translation vector
% % 
% %              % Translate the vertices using the translation part of the transformation
% %              v_translated = v_rotated + T(1:3, 4)';  % Add the translation vector
% % 
% %         % Plot the .ply model using patch
% %         patch('Vertices', v_translated, 'Faces', f, ...
% %               'FaceVertexCData', vertexColors, 'FaceColor', 'interp', 'EdgeColor', 'none');
% % 
% %         hold on;  % Keep hold for multiple patches
% %     end
% % 
% %     axis equal;  % Set equal scaling for axes
% % end
% 
% 
% 
% 
% 
% 
%         function position = endEffectorPosition(obj)
%             % Calculate the end-effector position
%             position = obj.robot.fkine(obj.jointAngles);
%         end
%     end
% end

classdef SixDOFRobot < RobotBaseClass
    properties(Access =public)   
        plyFileNameStem = 'SixDOFRobot';

        %> defaultRealQ 
        defaultRealQ  = [0,pi/4,pi/4,0,0,0];
    end

    methods (Access = public) 
%% Constructor 
        function self = SixDOFRobot(baseTr)
			self.CreateModel();
            if nargin == 1			
				self.model.base = self.model.base.T * baseTr;
            end            
            self.homeQ = self.RealQToModelQ(self.defaultRealQ);
            self.PlotAndColourRobot();
        end


%% CreateModel
        function CreateModel(self)       
            link(1) = Link('d',0.15185,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            link(2) = Link('d',0,'a',0.7,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(3) = Link('d',0,'a',-0.2,'alpha',pi/2,'qlim', deg2rad([-360 360]), 'offset', pi/4);
            % link(4) = Link('d',0.13105,'a',0.2,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            % link(5) = Link('d',0.08535,'a',0.2,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            % link(6) = Link('d',0.0921,'a',0.2,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);

            self.model = SerialLink(link,'name',self.name);

            self.model.base = transl(2, 0, 1);
        end   
    end
    
    methods(Hidden)
%% TestMoveJoints
        % Overriding the RobotBaseClass function, since it won't work properly
        % for this robot
        function TestMoveJoints(self)
            self.TestMoveSixDOF();
        end

%% Test Move Dobot
    function TestMoveSixDOF(self)
            qPath = jtraj(self.model.qlim(:,1)',self.model.qlim(:,2)',50);                       
            for i = 1:50              
                self.model.animate(self.RealQToModelQ(qPath(i,:)));
                pause(0.2);
            end
        end
    end
    methods(Static)
%% RealQToModelQ
        % Convert the real Q to the model Q
        function modelQ = RealQToModelQ(realQ)
            modelQ = realQ;
            modelQ(3) = Dobot.ComputeModelQ3GivenRealQ2and3( realQ(2), realQ(3) );
            modelQ(4) = pi - realQ(2) - modelQ(3);    
        end
        
%% ModelQ3GivenRealQ2and3
        % Convert the real Q2 & Q3 into the model Q3
        function modelQ3 = ComputeModelQ3GivenRealQ2and3(realQ2,realQ3)
            modelQ3 = pi/2 - realQ2 + realQ3;
        end
        
%% ModelQToRealQ
        % Convert the model Q to the real Q
        function realQ = ModelQToRealQ( modelQ )
            realQ = modelQ;
            realQ(3) = Dobot.ComputeRealQ3GivenModelQ2and3( modelQ(2), modelQ(3) );
        end
        
%% RealQ3GivenModelQ2and3
        % Convert the model Q2 & Q3 into the real Q3
        function realQ3 = ComputeRealQ3GivenModelQ2and3( modelQ2, modelQ3 )
            realQ3 = modelQ3 - pi/2 + modelQ2;
        end
    end
end
