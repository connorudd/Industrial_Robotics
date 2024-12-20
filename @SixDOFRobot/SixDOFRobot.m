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

        %% Move robot and chekc collision
        function moveToTarget(self, targetPosition, estop, hard_estop)
            % Create a transformation matrix for the target position
            T_target = transl(targetPosition(1), targetPosition(2), targetPosition(3));
        
            % Calculate the inverse kinematics to find joint angles
            q_sol = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]); % Mask to consider only position
        
            if isempty(q_sol)
                error('No solution found for the target position');
            else
                % Get the current joint angles
                q_current = self.model.getpos();
        
                % Define the number of steps
                numSteps = 150;
                
                % Ensure shortest travel distance for joint 1 (300 = -60) 
                delta2 = q_sol(1) - q_current(1);
                if abs(delta2) > pi
                    if delta2 > 0
                        q_sol(1) = q_sol(1) - 2 * pi;
                    else
                        q_sol(1) = q_sol(1) + 2 * pi;
                    end
                end
        
                % Interpolate between the current and target joint angles
                % uses quintic for minimal jerk 
                qMatrix = jtraj(q_current, q_sol, numSteps);
        
                % Define oven boundaries
                x_min_obstacle = 0.15; x_max_obstacle = 0.35;
                y_min_obstacle = 0.2; y_max_obstacle = 0.8;
                z_min_obstacle = 0.95; z_max_obstacle = 2;
        
                % Define table boundaries
                x_min_table = -1; x_max_table = 1;
                y_min_table = -1; y_max_table = 1;
                z_min_table = 0; z_max_table = 0.9;
        
                % Check for collision and animate the robot movement
                for i = 1:numSteps
                    % Get the transformation matrix for the current joint configuration
                    T_current = self.model.fkine(qMatrix(i, :));
        
                    % Extract end-effector position from transformation matrix
                    current_position = T_current.t;
        
                    % Check if the current end-effector position is within the oven
                    if current_position(1) >= x_min_obstacle && current_position(1) <= x_max_obstacle && ...
                       current_position(2) >= y_min_obstacle && current_position(2) <= y_max_obstacle && ...
                       current_position(3) >= z_min_obstacle && current_position(3) <= z_max_obstacle
                        warning('Collision detected with an obstacle! Recalculating path to avoid obstacle.');
                        % to send to recalculate
                        q_now = self.model.getpos();
                        % Recalculate path segments to avoid oven
                        recalculatePath(self, q_now, T_target, numSteps, estop, hard_estop);
                        return; 
                    end
        
                    % Check for collision with the table
                    if current_position(1) >= x_min_table && current_position(1) <= x_max_table && ...
                       current_position(2) >= y_min_table && current_position(2) <= y_max_table && ...
                       current_position(3) >= z_min_table && current_position(3) <= z_max_table
                        warning('Collision detected with the table! Adjusting trajectory.');
                        q_now = self.model.getpos();
                        recalculatePath(self, q_now, T_target, numSteps, estop, hard_estop);
                        return; 
                    end
        
                    % Pause movement if E-stop is active
                    while estop.IsStopped || hard_estop.IsStopped
                        pause(0.1); % Wait until E-stop is deactivated
                    end
        
                    % If no collision, animate the movement
                    self.model.animate(qMatrix(i, :));
                    pause(0.05);
                end
            end
        end
        % Recalculate path using predetermined way points
        function recalculatePath(self, q_start, T_target, numSteps, estop, hard_estop)
            % Define the intermediate waypoint
            waypoint1 = transl(1.138, -0.394, 1.1);
            waypoint2 = transl(0.729, -0.714, 1.1);
        
            % Calculate inverse kinematics to get joint values for the waypoint
            % start to 1 
            q_waypoint1 = self.model.ikine(waypoint1, 'mask', [1, 1, 1, 0, 0, 0]);
            qMatrix_segment1 = jtraj(q_start, q_waypoint1, numSteps/2);
            % 1 to 2 
            q_waypoint2 = self.model.ikine(waypoint2, 'mask', [1, 1, 1, 0, 0, 0]);
            qMatrix_segment2 = jtraj(q_waypoint1, q_waypoint2, numSteps/2);
            % 2 to goal/ target
            q_goal = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]);

            % ensure shortest movement of q1
            delta2 = q_goal(1) - q_waypoint2(1);
            if abs(delta2) > pi
                if delta2 > 0
                    q_goal(1) = q_goal(1) - 2*pi;
                else
                    q_goal(1) = q_goal(1) + 2*pi;
                end
            end
            qMatrix_segment3 = jtraj(q_waypoint2, q_goal, numSteps/2);
        
            % Animate each segment
            % start to 1 
            for j = 1:size(qMatrix_segment1, 1)
                 % Pause movement if E-stop is active
                    while estop.IsStopped || hard_estop.IsStopped
                        pause(0.1); % Wait until E-stop is deactivated
                    end
                self.model.animate(qMatrix_segment1(j, :));
                pause(0.05);
            end
            % 1 to 2 
            for j = 1:size(qMatrix_segment2, 1)
                 % Pause movement if E-stop is active
                    while estop.IsStopped || hard_estop.IsStopped
                        pause(0.1); % Wait until E-stop is deactivated
                    end
                self.model.animate(qMatrix_segment2(j, :));
                pause(0.05);
            end
            % 2 to goal
            for j = 1:size(qMatrix_segment3, 1)
                 % Pause movement if E-stop is active
                    while estop.IsStopped || hard_estop.IsStopped
                        pause(0.1); % Wait until E-stop is deactivated
                    end
                self.model.animate(qMatrix_segment3(j, :));
                pause(0.05);
            end
        end

        %% Rotate the link by a given angle (in radians)
        function rotateLink(self, linkIndex, angle, numSteps, environment, estop, hard_estop)
            % handles for object animations 
            persistent bowlHandle;
            persistent cakeHandle;
            % Validate link index
            if linkIndex < 1 || linkIndex > 6
                error('Link index must be between 1 and 6.');
            end
        
            % Get the current joint angles
            q_current = self.model.getpos();
        
            % Calculate the target angle for the specified link
            target_angle = q_current(linkIndex) + angle;
        
            % Ensure the target angle remains within joint limits
            target_angle = mod(target_angle, 2 * pi); 
            if target_angle > pi
                target_angle = target_angle - 2 * pi; % Keep it in the range [-pi, pi]
            end
        
            % Interpolate between the current angle and the target angle
            % creates a vector of linearly spaced values
            angles = linspace(q_current(linkIndex), target_angle, numSteps);
        
            % Animate the movement of the robot in steps
            for i = 1:numSteps
                % Update the specified joint angle
                q_current(linkIndex) = angles(i);
                % Pause movement if E-stop is active
                while estop.IsStopped || hard_estop.IsStopped
                    pause(0.1); % Wait until E-stop is deactivated
                end
                % Animate the current configuration
                self.model.animate(q_current);
        
                % Check if link 5 is rotating to reposition the bowl
                if linkIndex == 5 && angle < 0
                    % Get the current end-effector position
                    T_current = self.model.fkine(q_current);
                    bowlPosition = T_current.t';
        
                    % Delete previous bowl if it exists
                    if ~isempty(bowlHandle) && isvalid(bowlHandle)
                        delete(bowlHandle);
                    end
        
                    % Add updated bowl position and store its handle
                    bowlHandle = environment.addBowl(2, bowlPosition);
                    if i == numSteps
                            if ~isempty(bowlHandle) && isvalid(bowlHandle)
                        delete(bowlHandle);
                            end
                    end
        
                end
                % if link 5 is rotating in the other direction anmiate the bowl
                if linkIndex == 5 && angle > 0
                    % Get the current end-effector position
                    T_current = self.model.fkine(q_current);
                    cakePosition = T_current.t';
        
                    % Delete previous cake if it exists
                    if ~isempty(cakeHandle) && isvalid(cakeHandle)
                        delete(cakeHandle);
                    end
        
                    % Add updated cake position and store its handle
                    cakeHandle = environment.addCake(0.1, cakePosition);
                    % delete cake 
                    if i == numSteps
                            if ~isempty(cakeHandle) && isvalid(cakeHandle)
                                delete(cakeHandle);
                            end
                    end
                end
                pause(0.05); 
            end
        end

 %% Movw to target using the GUI function 
 function moveToTargetGUI(self, targetPosition, estop, hard_estop)
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
        % low number for quicker sim
        numSteps = 5;
        
        % Ensure shortest travel distance 
        delta2 = q_sol(1) - q_current(1);
        if abs(delta2) > pi
            if delta2 > 0
                q_sol(1) = q_sol(1) - 2 * pi;
            else
                q_sol(1) = q_sol(1) + 2 * pi;
            end
        end

        % Interpolate between the current and target joint angles
        qMatrix = jtraj(q_current, q_sol, numSteps);

        % animate the robot movement
        for i = 1:numSteps
            % animate the movement
            self.model.animate(qMatrix(i, :));
            pause(0.05);
        end
    end
 end

 %% Rotate the link by a given angle (in radians)
function rotateLinkGUI(self, linkIndex, angle)
    numSteps = 5;
    % Validate link index
    if linkIndex < 1 || linkIndex > 6
        error('Link index must be between 1 and 6.');
    end

    % Get the current joint angles
    q_current = self.model.getpos();

    % Calculate the target angle for the specified link
    target_angle = q_current(linkIndex) + angle;

    % Ensure the target angle remains within joint limits
    target_angle = mod(target_angle, 2 * pi); % Wrap the angle to [0, 2*pi]
    if target_angle > pi
        target_angle = target_angle - 2 * pi; % Keep it in the range [-pi, pi]
    end

    % Interpolate between the current angle and the target angle
    angles = linspace(q_current(linkIndex), target_angle, numSteps);

    % Animate the movement of the robot in steps
    for i = 1:numSteps
        % Update the specified joint angle
        q_current(linkIndex) = angles(i);
        % Animate the current configuration
        self.model.animate(q_current);
    end 
        pause(0.05);
end

%% CreateModel
        function CreateModel(self)  
            % 6 DOFS (all are revolute) 
            link(1) = Link('d', 0.3, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(2) = Link('d', -0.5, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0); 
            link(3) = Link('d', 0, 'a', 0, 'alpha', -pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d', -0.2, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(5) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(6) = Link('d', -0.25, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);

            self.model = SerialLink(link,'name',self.name);
            % translate base based on sim requirements 
            self.model.base = transl(0.5, 0, 1);
        end   
    end
    
    % robot functions taken from base class
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
