% %% Workspace Setup Function for initial dobot testing phase
% clf;
% clc;
% % Create and plot robot
% robot = DobotMagician();
% q0 = [0, pi/6, pi/4, pi/2, 0];
% workspace = [-0.4, 0.4, -0.4, 0.4, 0, 0.4];
% scale = 0.5;
% robot.model.plot(q0,'workspace',workspace,'scale',scale);
% axis(workspace);
% hold on;

classdef dobot_movement < handle
    methods (Static) 
        function move_dobot(robot, estop, hard_estop)
        %% Plot and detect color for green square at pick position
        [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        square_start_position = [-0.4, -0.2, 1];
        square_scale_factor = 0.002;
        square_v_scaled = v * square_scale_factor;
        square_v_transformation = square_v_scaled + square_start_position;
        square1 = trisurf(f, square_v_transformation(:, 1), square_v_transformation(:, 2), square_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');

        % Demo creation of square at end effector
        % [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
        % vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        % square_start_position2 = [0.25, 0, 0];
        % square_scale_factor2 = 0.002;
        % square_v_scaled2 = v * square_scale_factor2;
        % square_v_transformation2 = square_v_scaled2 + square_start_position;
        % square2 = trisurf(f, square_v_transformation2(:, 1), square_v_transformation2(:, 2), square_v_transformation2(:, 3), ...
        %     'FaceVertexCData', vertexColours, ...
        %     'FaceColor', 'interp', ...
        %     'EdgeColor', 'none');
        % hideObj(square2);

        % Square object at the place position, initally hid until moved to that position
        [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        square_start_position3 = [-0.18, 0, 1.05];
        square_scale_factor3 = 0.002;
        square_v_scaled3 = v * square_scale_factor3;
        square_v_transformation3 = square_v_scaled3 + square_start_position3;
        square3 = trisurf(f, square_v_transformation3(:, 1), square_v_transformation3(:, 2), square_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        dobot_movement.hideObj(square3);
        
        %% Plot and detect color for blue octagon at pick position
        [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        octagon_start_position = [-0.55, -0.2, 1];
        octagon_scale_factor = 0.002;
        octagon_v_scaled = v * octagon_scale_factor;
        octagon_v_transformation = octagon_v_scaled + octagon_start_position;
        octagon1 = trisurf(f, octagon_v_transformation(:, 1), octagon_v_transformation(:, 2), octagon_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');

        % Demo object for dobot testing at end effector
        % [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
        % vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        % octagon_start_position2 = [0.1, 0.25, 0];
        % octagon_scale_factor2 = 0.002;
        % octagon_v_scaled2 = v * octagon_scale_factor2;
        % octagon_v_transformation2 = octagon_v_scaled2 + octagon_start_position2;
        % octagon2 = trisurf(f, octagon_v_transformation2(:, 1), octagon_v_transformation2(:, 2), octagon_v_transformation2(:, 3), ...
        %     'FaceVertexCData', vertexColours, ...
        %     'FaceColor', 'interp', ...
        %     'EdgeColor', 'none');
        % hideObj(octagon2);

        % Octagon object at the place position, initally hid until moved to that position
        [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        octagon_start_position3 = [-0.18, 0.1, 1.05];
        octagon_scale_factor3 = 0.002;
        octagon_v_scaled3 = v * octagon_scale_factor3;
        octagon_v_transformation3 = octagon_v_scaled3 + octagon_start_position3;
        octagon3 = trisurf(f, octagon_v_transformation3(:, 1), octagon_v_transformation3(:, 2), octagon_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        dobot_movement.hideObj(octagon3);
        
        %% Plot and detect color for red hexagon at pick position
        [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        hexagon_start_position = [-0.25, -0.2, 1];
        hexagon_scale_factor = 0.002;
        hexagon_v_scaled = v * hexagon_scale_factor;
        hexagon_v_transformation = hexagon_v_scaled + hexagon_start_position;
        hexagon1 = trisurf(f, hexagon_v_transformation(:, 1), hexagon_v_transformation(:, 2), hexagon_v_transformation(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');

        % Demo obejct for dobot testing at end effector
        % [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
        % vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        % hexagon_start_position2 = [0.28, 0.2, 0];
        % hexagon_scale_factor2 = 0.002;
        % hexagon_v_scaled2 = v * hexagon_scale_factor2;
        % hexagon_v_transformation2 = hexagon_v_scaled2 + hexagon_start_position2;
        % hexagon2 = trisurf(f, hexagon_v_transformation2(:, 1), hexagon_v_transformation2(:, 2), hexagon_v_transformation2(:, 3), ...
        %     'FaceVertexCData', vertexColours, ...
        %     'FaceColor', 'interp', ...
        %     'EdgeColor', 'none');
        % hideObj(hexagon2);

        % Hexagon object at the place position, initally hid until moved to that position
        [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        hexagon_start_position3 = [-0.18, 0.05, 1.05];
        hexagon_scale_factor3 = 0.002;
        hexagon_v_scaled3 = v * hexagon_scale_factor3;
        hexagon_v_transformation3 = hexagon_v_scaled3 + hexagon_start_position3;
        hexagon3 = trisurf(f, hexagon_v_transformation3(:, 1), hexagon_v_transformation3(:, 2), hexagon_v_transformation3(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        dobot_movement.hideObj(hexagon3);

            % Sets inital posiitons of objects with small z-axis offset considering gripper ply file layout, for more realistic apperance of moving object
            square_position = [-0.4, -0.2, 1.05];
            octagon_position = [-0.55, -0.2, 1.05];
            hexagon_position = [-0.25, -0.2, 1.05];

            % Transitional position between pick and place
            traj_position = [-0.45, 0, 1.1];

            % Place positions of objects
            place_position1 = [-0.18, 0.05, 1.1];
            place_position2 = [-0.18, 0, 1.1];
            place_position3 = [-0.18, 0.1, 1.1];

            % Iteratively moves through each object picking it up, moving through the transition joint position and then placing them. With the inclusion of 
            % hiding the obejct after picking, placing and moving corresponding to when the robot has visited their position. 
            dobot_movement.moveRobotToPosition(robot, square_position, estop, hard_estop);
            dobot_movement.hideObj(square1);
            dobot_movement.moveRobotToPositionWithSquare(robot, traj_position, estop, hard_estop);
            dobot_movement.moveRobotToPositionWithSquare(robot, place_position1, estop, hard_estop);
            dobot_movement.showObj(square3);
            dobot_movement.moveRobotToPosition(robot, traj_position, estop, hard_estop);
            dobot_movement.moveRobotToPosition(robot, octagon_position, estop, hard_estop);
            dobot_movement.hideObj(octagon1);
            dobot_movement.moveRobotToPositionWithOctagon(robot, traj_position, estop, hard_estop);
            dobot_movement.moveRobotToPositionWithOctagon(robot, place_position2, estop, hard_estop);
            dobot_movement.showObj(octagon3);
            dobot_movement.moveRobotToPosition(robot, traj_position, estop, hard_estop);
            dobot_movement.moveRobotToPosition(robot, hexagon_position, estop, hard_estop);
            dobot_movement.hideObj(hexagon1);
            dobot_movement.moveRobotToPositionWithHexagon(robot, traj_position, estop, hard_estop);
            dobot_movement.moveRobotToPositionWithHexagon(robot, place_position3, estop, hard_estop);
            dobot_movement.showObj(hexagon3);
            dobot_movement.moveRobotToPosition(robot, traj_position, estop, hard_estop);
        end
        
        %% Function to move the robot from current position to a target position
        function moveRobotToPosition(robot, position, estop, hard_estop)
            steps = 25; % Number of steps for the movement trajectory
            currentQ = robot.model.getpos(); % Get the current joint configuration of the robot
            targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate the target joint configuration using inverse kinematics
            traj = jtraj(currentQ, targetQ, steps); % Generate a joint trajectory from current to target configuration

            for i = 1:steps
                % Pause movement if E-stop or hard E-stop is active
                while estop.IsStopped || hard_estop.IsStopped
                    pause(0.1); % Wait until the E-stop is deactivated
                end
                robot.model.animate(traj(i, :)); % Animate the robot's movement to the next position in the trajectory
                pause(0.05); % Short delay between each step for smooth animation
            end
            pause(0.5); % Final pause to allow for any remaining movement to complete
        end

        
%% Function to move the robot to a target position, with a square object moving along the path
% This function is based on the previous movement function but adds iterative plotting of a square object,
% updating its position with each new end-effector position and hiding/showing it as the robot moves.

function moveRobotToPositionWithSquare(robot, position, estop, hard_estop)
    steps = 25; % Number of steps for the movement trajectory
    currentQ = robot.model.getpos(); % Get the robot's current joint configuration
    targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate target joint configuration using inverse kinematics
    traj = jtraj(currentQ, targetQ, steps); % Generate joint trajectory for smooth movement
    endEffectorPose = robot.model.fkine(currentQ); % Calculate initial end-effector pose
    initial_object_position = endEffectorPose.t'; % Set initial position for the square object
    initial_object_position = initial_object_position + [0, 0, -0.05]; % Adjust object position slightly below the end-effector

    % Load square object model and set initial transformation parameters
    [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    square_start_position2 = initial_object_position; % Starting position of the square
    square_scale_factor2 = 0.002; % Scale factor for resizing the square
    square_v_scaled2 = v * square_scale_factor2; % Apply scaling to square vertices
    square_v_transformation2 = square_v_scaled2 + square_start_position2; % Transform vertices to initial position
    % Plot the initial square object with specified colors and properties
    square_updated = trisurf(f, square_v_transformation2(:, 1), square_v_transformation2(:, 2), square_v_transformation2(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');
    
    for i = 1:steps
        % Pause movement if E-stop or hard E-stop is active
        while estop.IsStopped || hard_estop.IsStopped
            pause(0.1); % Wait until E-stop is deactivated
        end
        robot.model.animate(traj(i, :)); % Animate robot to the next joint position in the trajectory

        current_q = robot.model.getpos(); % Get current joint configuration
        endEffectorPose = robot.model.fkine(current_q); % Calculate end-effector pose for the current joint position
        object_position = endEffectorPose.t'; % Determine new position for the square object
        object_position = object_position + [0, 0, -0.05]; % Adjust object position relative to end-effector

        % Hide the current square object before repositioning it
        dobot_movement.hideObj(square_updated);

        % Reload square model to update its position along with the robot
        [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        square_start_position2 = object_position; % Update square's position along the trajectory
        square_scale_factor2 = 0.002; % Keep scaling factor consistent
        square_v_scaled2 = v * square_scale_factor2; % Apply scaling to vertices again
        square_v_transformation2 = square_v_scaled2 + square_start_position2; % Transform to new position

        % Plot the updated square object at the new position
        square_updated = trisurf(f, square_v_transformation2(:, 1), square_v_transformation2(:, 2), square_v_transformation2(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        
        pause(0.05); % Short delay for smooth animation
        dobot_movement.showObj(square_updated); % Show the object at its new location
    end
    pause(0.5); % Final pause to allow movement to complete
    dobot_movement.hideObj(square_updated); % Hide the square object after movement ends
end

%% Function to move the robot to a target position, with an octagon object moving along the path
% This function is based on the previous movement function but adds iterative plotting of an octagon object,
% updating its position with each new end-effector position and hiding/showing it as the robot moves.

function moveRobotToPositionWithOctagon(robot, position, estop, hard_estop)
    steps = 25; % Number of steps for the movement trajectory
    currentQ = robot.model.getpos(); % Get the robot's current joint configuration
    targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate target joint configuration using inverse kinematics
    traj = jtraj(currentQ, targetQ, steps); % Generate joint trajectory for smooth movement
    endEffectorPose = robot.model.fkine(currentQ); % Calculate initial end-effector pose
    initial_object_position = endEffectorPose.t'; % Set initial position for the octagon object
    initial_object_position = initial_object_position + [0, 0, -0.05]; % Adjust object position slightly below the end-effector

    % Load octagon object model and set initial transformation parameters
    [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    octagon_start_position2 = initial_object_position; % Starting position of the octagon
    octagon_scale_factor2 = 0.002; % Scale factor for resizing the octagon
    octagon_v_scaled2 = v * octagon_scale_factor2; % Apply scaling to octagon vertices
    octagon_v_transformation2 = octagon_v_scaled2 + octagon_start_position2; % Transform vertices to initial position
    % Plot the initial octagon object with specified colors and properties
    octagon_updated = trisurf(f, octagon_v_transformation2(:, 1), octagon_v_transformation2(:, 2), octagon_v_transformation2(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');
    
    for i = 1:steps
        % Pause movement if E-stop or hard E-stop is active
        while estop.IsStopped || hard_estop.IsStopped
            pause(0.1); % Wait until E-stop is deactivated
        end
        robot.model.animate(traj(i, :)); % Animate robot to the next joint position in the trajectory

        current_q = robot.model.getpos(); % Get current joint configuration
        endEffectorPose = robot.model.fkine(current_q); % Calculate end-effector pose for the current joint position
        object_position = endEffectorPose.t'; % Determine new position for the octagon object
        object_position = object_position + [0, 0, -0.05]; % Adjust object position relative to end-effector

        % Hide the current octagon object before repositioning it
        dobot_movement.hideObj(octagon_updated);

        % Reload octagon model to update its position along with the robot
        [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        octagon_start_position2 = object_position; % Update octagon's position along the trajectory
        octagon_scale_factor2 = 0.002; % Keep scaling factor consistent
        octagon_v_scaled2 = v * octagon_scale_factor2; % Apply scaling to vertices again
        octagon_v_transformation2 = octagon_v_scaled2 + octagon_start_position2; % Transform to new position

        % Plot the updated octagon object at the new position
        octagon_updated = trisurf(f, octagon_v_transformation2(:, 1), octagon_v_transformation2(:, 2), octagon_v_transformation2(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        
        pause(0.05); % Short delay for smooth animation
        dobot_movement.showObj(octagon_updated); % Show the object at its new location
    end
    pause(0.5); % Final pause to allow movement to complete
    dobot_movement.hideObj(octagon_updated); % Hide the octagon object after movement ends
end

        
%% Function to move the robot to a target position with a hexagon object moving along the path
% This function is based on the previous movement function, adding iterative plotting of a hexagon object,
% updating its position with each new end-effector position and hiding/showing it as the robot moves.

function moveRobotToPositionWithHexagon(robot, position, estop, hard_estop)
    steps = 25; % Number of steps for the movement trajectory
    currentQ = robot.model.getpos(); % Get the robot's current joint configuration
    targetQ = robot.model.ikcon(transl(position), currentQ); % Calculate target joint configuration using inverse kinematics
    traj = jtraj(currentQ, targetQ, steps); % Generate joint trajectory for smooth movement
    endEffectorPose = robot.model.fkine(currentQ); % Calculate initial end-effector pose
    initial_object_position = endEffectorPose.t'; % Set initial position for the hexagon object
    initial_object_position = initial_object_position + [0, 0, -0.05]; % Adjust object position slightly below the end-effector

    % Load hexagon object model and set initial transformation parameters
    [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    hexagon_start_position2 = initial_object_position; % Starting position of the hexagon
    hexagon_scale_factor2 = 0.002; % Scale factor for resizing the hexagon
    hexagon_v_scaled2 = v * hexagon_scale_factor2; % Apply scaling to hexagon vertices
    hexagon_v_transformation2 = hexagon_v_scaled2 + hexagon_start_position2; % Transform vertices to initial position
    % Plot the initial hexagon object with specified colors and properties
    hexagon_updated = trisurf(f, hexagon_v_transformation2(:, 1), hexagon_v_transformation2(:, 2), hexagon_v_transformation2(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');
    
    for i = 1:steps
        % Pause movement if E-stop or hard E-stop is active
        while estop.IsStopped || hard_estop.IsStopped
            pause(0.1); % Wait until E-stop is deactivated
        end
        robot.model.animate(traj(i, :)); % Animate robot to the next joint position in the trajectory

        current_q = robot.model.getpos(); % Get current joint configuration
        endEffectorPose = robot.model.fkine(current_q); % Calculate end-effector pose for the current joint position
        object_position = endEffectorPose.t'; % Determine new position for the hexagon object
        object_position = object_position + [0, 0, -0.05]; % Adjust object position relative to end-effector

        % Hide the current hexagon object before repositioning it
        dobot_movement.hideObj(hexagon_updated);

        % Reload hexagon model to update its position along with the robot
        [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
        vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        hexagon_start_position2 = object_position; % Update hexagon's position along the trajectory
        hexagon_scale_factor2 = 0.002; % Keep scaling factor consistent
        hexagon_v_scaled2 = v * hexagon_scale_factor2; % Apply scaling to vertices again
        hexagon_v_transformation2 = hexagon_v_scaled2 + hexagon_start_position2; % Transform to new position

        % Plot the updated hexagon object at the new position
        hexagon_updated = trisurf(f, hexagon_v_transformation2(:, 1), hexagon_v_transformation2(:, 2), hexagon_v_transformation2(:, 3), ...
            'FaceVertexCData', vertexColours, ...
            'FaceColor', 'interp', ...
            'EdgeColor', 'none');
        
        pause(0.05); % Short delay for smooth animation
        dobot_movement.showObj(hexagon_updated); % Show the object at its new location
    end
    pause(0.5); % Final pause to allow movement to complete
    dobot_movement.hideObj(hexagon_updated); % Hide the hexagon object after movement ends
end

        
        %% Function to hid objects once moved
        function hideObj(obj)
            obj.Visible = 'off';
        end
        
        %% Function to show objects when being moved or in current position
        function showObj(obj)
            obj.Visible = 'on';
        end
    end
end
