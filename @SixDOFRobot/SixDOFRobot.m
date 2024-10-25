classdef SixDOFRobot < RobotBaseClass
    properties(Access =public)   
        plyFileNameStem = 'SixDOFRobot';

        %> defaultRealQ 
        defaultRealQ  = [0,0,0,0,0,0];
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

 %% Move to Target Position
    function moveToTarget(self, targetPosition)
        % Create a transformation matrix for the target position
        T_target = transl(targetPosition(1), targetPosition(2), targetPosition(3));

        % Calculate the inverse kinematics to find joint angles
        q_sol = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]); % Mask to consider only position

        if isempty(q_sol)
            error('No solution found for the target position');
        else
            % Get the current joint angles
            q_current = self.model.getpos();

            % Define the number of steps for smooth animation
            numSteps = 50;

            % Interpolate between the current and target joint angles
            qMatrix = jtraj(q_current, q_sol, numSteps);

            % Animate the robot movement step by step
            for i = 1:numSteps
                self.model.animate(qMatrix(i, :));
                pause(0.05); % Pause to control the speed of the animation
            end
        end
    end

% %% Move to Target Position with Collision Avoidance
% function moveToTarget(self, targetPosition)
%     % Create a transformation matrix for the target position
%     T_target = transl(targetPosition(1), targetPosition(2), targetPosition(3));
% 
%     % Calculate the inverse kinematics to find joint angles
%     q_sol = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]); % Mask to consider only position
% 
%     if isempty(q_sol)
%         error('No solution found for the target position');
%     else
%         % Get the current joint angles
%         q_current = self.model.getpos();
% 
%         % Define the number of steps for smooth animation
%         numSteps = 50;
% 
%         % Interpolate between the current and target joint angles
%         qMatrix = jtraj(q_current, q_sol, numSteps);
% 
%         % Define obstacle boundaries
%         x_min = 0.2; x_max = 0.3;
%         y_min = 0.25; y_max = 0.75;
%         z_min = 1.0; z_max = 1.5;
% 
%         % Check for collision and animate the robot movement
%         for i = 1:numSteps
%             % Get the transformation matrix for the current joint configuration
%             T_current = self.model.fkine(qMatrix(i, :));
% 
%             % Extract position from transformation matrix
%             current_position = T_current.t;  % Use the 't' property to get translation
% 
%             % Check if the current position is within the obstacle bounds
%             if current_position(1) >= x_min && current_position(1) <= x_max && ...
%                current_position(2) >= y_min && current_position(2) <= y_max && ...
%                current_position(3) >= z_min && current_position(3) <= z_max
%                 warning('Collision detected! Adjusting trajectory.');
%                 % Exit or handle collision avoidance (e.g., by recalculating path)
%                 return;
%             end
% 
%             % If no collision, animate the movement
%             self.model.animate(qMatrix(i, :));
%             pause(0.05); % Pause to control the speed of the animation
%         end
%     end
% end
% %% Move to Target Position with Ellipsoid-Based Collision Avoidance
% function moveToTarget(self, targetPosition)
%     % Create a transformation matrix for the target position
%     T_target = transl(targetPosition(1), targetPosition(2), targetPosition(3));
% 
%     % Calculate the inverse kinematics to find joint angles
%     q_sol = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]);
% 
%     if isempty(q_sol)
%         error('No solution found for the target position');
%     else
%         % Get the current joint angles
%         q_current = self.model.getpos();
% 
%         % Define the number of steps for smooth animation
%         numSteps = 50;
% 
%         % Interpolate between the current and target joint angles
%         qMatrix = jtraj(q_current, q_sol, numSteps);
% 
%         % Define the obstacle ellipsoid
%         obstacle_center = [0.25, 0.5, 1.25];
%         obstacle_radii = [0.05, 0.25, 0.25];
% 
%        % Define ellipsoids for each link based on DH parameters
%     linkEllipsoids = {
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.15]),  % Link 1
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.25]),  % Link 2
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.15]),  % Link 3
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.1]),   % Link 4
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.1]),   % Link 5
%         struct('center', [0, 0, 0], 'radii', [0.05, 0.05, 0.1])    % Link 6
%     };
% 
%         for i = 1:numSteps
%             % Flag for collision detection
%             % collisionDetected = false;
% 
%             % Get transformations for all links at the current step
%             T_links = self.model.fkine(qMatrix(i, :));
% 
%             for j = 1:length(linkEllipsoids)
%                 % Get the position of link j using its transformation
%                 T_link = T_links(j); % Transformation matrix for link j
%                 linkEllipsoids{j}.center = T_link.t; % Update center position
% 
%                       % Debugging lines
%         disp('Obstacle Center:');
%         disp(obstacle_center);
%         disp('Obstacle Radii:');
%         disp(obstacle_radii);
%                 disp('Length of linkEllipsoids:');
%         disp(length(linkEllipsoids));
%         disp('Link Ellipsoid Center:');
%     disp(linkEllipsoids{j}.center);
%                 % Check for collision with the obstacle ellipsoid
%                 if ellipsoidCollision(linkEllipsoids{j}, obstacle_center, obstacle_radii)
%                     warning('Collision detected at link %d! Adjusting trajectory.', j);
%                     return; % Exit if collision is detected
%                 end
%             end
% 
%             % If no collision, animate the movement
%             self.model.animate(qMatrix(i, :));
%             pause(0.05);
%         end
%     end
% end
% 
% %% Ellipsoid Collision Detection
% function isColliding = ellipsoidCollision(linkEllipsoid, obstacleCenter, obstacleRadii)
%     % Check for proper input types and sizes
%     if ~isfield(linkEllipsoid, 'center') || ~isfield(linkEllipsoid, 'radii')
%         error('linkEllipsoid must have fields: center and radii');
%     end
% 
%     if ~isequal(size(linkEllipsoid.center), [1, 3]) || ~isequal(size(obstacleCenter), [1, 3]) || ~isequal(size(obstacleRadii), [1, 3])
%         error('Inputs must be 1x3 vectors');
%     end
% 
%     % Debugging: Print input values
%     disp('Link Ellipsoid Center:');
%     disp(linkEllipsoid.center);
%     disp('Obstacle Center:');
%     disp(obstacleCenter);
%     disp('Obstacle Radii:');
%     disp(obstacleRadii);
% 
%     % Calculate the Mahalanobis distance for ellipsoid intersection
%     d = (linkEllipsoid.center - obstacleCenter) ./ obstacleRadii;
% 
%     % Debugging: Print the Mahalanobis distance components
%     disp('Distance components (Mahalanobis):');
%     disp(d);
% 
%     distance = sum(d .^ 2); % Mahalanobis distance
% 
%     % Debugging: Print the total distance
%     disp('Total Mahalanobis Distance:');
%     disp(distance);
% 
%     % Determine if there is a collision
%     isColliding = distance < 1; % Collision if within ellipsoid
% 
%     % Debugging: Print the collision result
%     if isColliding
%         disp('Collision Detected!');
%     else
%         disp('No Collision.');
%     end
% end



%% CreateModel
        function CreateModel(self)       
            link(1) = Link('d', 0.3, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(2) = Link('d', -0.5, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0); 
            link(3) = Link('d', 0, 'a', 0, 'alpha', -pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d', -0.2, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(5) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(6) = Link('d', -0.25, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);


            self.model = SerialLink(link,'name',self.name);

            self.model.base = transl(0.5, 0, 1);
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
