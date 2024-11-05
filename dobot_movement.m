% %% Workspace Setup Function
% clf; % Clear the current figure
% clc; % Clear the command window
% % Create and plot the Dobot Magician robot
% robot = DobotMagician(); % Instantiate the robot model
% q0 = [0, pi/6, pi/4, pi/2, 0]; % Set initial joint configuration
% workspace = [-0.4, 0.4, -0.4, 0.4, 0, 0.4]; % Define workspace boundaries
% scale = 0.5; % Set scale for visualization
% robot.model.plot(q0, 'workspace', workspace, 'scale', scale); % Plot the robot in the specified workspace and scale
% axis(workspace); % Set axis limits to workspace bounds
% hold on; % Hold the plot for additional elements

classdef dobot_movement < handle
    methods (Static)
        function move_dobot(robot, estop, hard_estop)
        %% Plot and detect color for green square
        [f, v, data] = plyread('environment_files/green_square.ply', 'tri'); % Load 3D model of green square
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255; % Normalize vertex colors
        square_start_position = [-0.4, -0.2, 1]; % Set initial position for the square
        square_scale_factor = 0.002; % Scale factor for the square
        square_v_scaled = v * square_scale_factor; % Apply scaling to vertices
        square_v_transformation = square_v_scaled + square_start_position; % Apply position transformation to vertices
        square1 = trisurf(f, square_v_transformation(:, 1), square_v_transformation(:, 2), square_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot green square in 3D space

        % (Repeated block for second and third green squares is commented out)
        
        [f, v, data] = plyread('environment_files/green_square.ply', 'tri'); % Reload model
        square_start_position3 = [-0.18, 0, 1.05]; % Define new position for third square
        square_scale_factor3 = 0.002; % Define scaling for the third square
        square_v_scaled3 = v * square_scale_factor3; % Scale vertices
        square_v_transformation3 = square_v_scaled3 + square_start_position3; % Transform vertices to new position
        square3 = trisurf(f, square_v_transformation3(:, 1), square_v_transformation3(:, 2), square_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot third green square
        dobot_movement.hideObj(square3); % Hide the third square

        %% Plot and detect color for blue octagon
        [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri'); % Load 3D model of blue octagon
        octagon_start_position = [-0.55, -0.2, 1]; % Define initial position
        octagon_scale_factor = 0.002; % Define scaling factor
        octagon_v_scaled = v * octagon_scale_factor; % Scale vertices
        octagon_v_transformation = octagon_v_scaled + octagon_start_position; % Transform vertices
        octagon1 = trisurf(f, octagon_v_transformation(:, 1), octagon_v_transformation(:, 2), octagon_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot the blue octagon

        % (Repeated block for additional blue octagons is commented out)
        
        [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri'); % Reload model for third octagon
        octagon_start_position3 = [-0.18, 0.1, 1.05]; % Position for third octagon
        octagon_v_scaled3 = v * octagon_scale_factor3; % Scale vertices
        octagon_v_transformation3 = octagon_v_scaled3 + octagon_start_position3; % Transform vertices
        octagon3 = trisurf(f, octagon_v_transformation3(:, 1), octagon_v_transformation3(:, 2), octagon_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot third octagon
        dobot_movement.hideObj(octagon3); % Hide third octagon

        %% Plot and detect color for red hexagon
        [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri'); % Load 3D model of red hexagon
        hexagon_start_position = [-0.25, -0.2, 1]; % Define position
        hexagon_scale_factor = 0.002; % Define scaling factor
        hexagon_v_scaled = v * hexagon_scale_factor; % Scale vertices
        hexagon_v_transformation = hexagon_v_scaled + hexagon_start_position; % Transform vertices
        hexagon1 = trisurf(f, hexagon_v_transformation(:, 1), hexagon_v_transformation(:, 2), hexagon_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot red hexagon

        % (Repeated block for additional hexagons is commented out)
        
        [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri'); % Reload model for third hexagon
        hexagon_start_position3 = [-0.18, 0.05, 1.05]; % Position for third hexagon
        hexagon_v_scaled3 = v * hexagon_scale_factor3; % Scale vertices
        hexagon_v_transformation3 = hexagon_v_scaled3 + hexagon_start_position3; % Transform vertices
        hexagon3 = trisurf(f, hexagon_v_transformation3(:, 1), hexagon_v_transformation3(:, 2), hexagon_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none'); % Plot third hexagon
        dobot_movement.hideObj(hexagon3); % Hide third hexagon

        % Define target positions for robot movement
        square_position = [-0.4, -0.2, 1.05]; % Position of green square
        octagon_position = [-0.55, -0.2, 1.05]; % Position of blue octagon
        hexagon_position = [-0.25, -0.2, 1.05]; % Position of red hexagon
        
        traj_position = [-0.45, 0, 1.1]; % Transition position
        place_position1 = [-0.18, 0.05, 1.1]; % Position to place green square
        place_position2 = [-0.18, 0, 1.1]; % Position to place blue octagon
        place_position3 = [-0.18, 0.1, 1.1]; % Position to place red hexagon

        % Move robot through a sequence of positions
        dobot_movement.moveRobotToPosition(robot, square_position, estop, hard_estop); % Move to pick up green square
        dobot_movement.hideObj(square1); % Hide picked-up green square
        dobot_movement.moveRobotToPositionWithSquare(robot, traj_position, estop, hard_estop); % Move square to trajectory position
        dobot_movement.moveRobotToPositionWithSquare(robot, place_position1, estop, hard_estop); % Place green square
        dobot_movement.showObj(square3); % Show placed square at final position
        
        % (Repeat for octagon and hexagon)
        end
        
        %% Function to move the robot to a specified position
        function moveRobotToPosition(robot, position, estop, hard_estop)
            steps = 25; % Number of trajectory steps
            currentQ = robot.model.getpos(); % Get current joint positions
            targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate target joint positions
            traj = jtraj(currentQ, targetQ, steps); % Generate joint trajectory
            for i = 1:steps
                % Pause if E-stop is active
                while estop.IsStopped || hard_estop.IsStopped
                    pause(0.1); % Wait until E-stop is deactivated
                end
                robot.model.animate(traj(i, :)); % Animate robot along trajectory
                pause(0.05); % Small delay for smooth animation
            end
            pause(0.5); % Pause briefly after reaching target
        end

        %% Function to move the robot to a position with a square
        function moveRobotToPositionWithSquare(robot, position, estop, hard_estop)
            steps = 25; % Number of trajectory steps
            currentQ = robot.model.getpos(); % Get current joint positions
            targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate target joint positions
            traj = jtraj(currentQ, targetQ, steps); % Generate joint trajectory
            for i = 1:steps
                % Pause if E-stop is active
                while estop.IsStopped || hard_estop.IsStopped
                    pause(0.1); % Wait until E-stop is deactivated
                end
                robot.model.animate(traj(i, :)); % Animate robot along trajectory
                drawnow();
                pause(0.05); % Small delay for smooth animation
            end
        end

        %% Hide an object
        function hideObj(object)
            object.Visible = 'off'; % Set visibility off
        end

        %% Show an object
        function showObj(object)
            object.Visible = 'on'; % Set visibility on
        end
    end
end

