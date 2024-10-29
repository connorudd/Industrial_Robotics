classdef main
    methods(Static)
        function plotEnvironment()
            % Initialize environment and robots
            env = environment(); % Create the environment instance
            dobot_move = dobot_movement();
            env.plotEnvironment(); % Plot the environment
            bowlPositions = [0, 0, 1.05];
            bowlHandle = env.addBowl(2, bowlPositions);
            robot1 = Dobot();  % Initialize Dobot robot
            robot2 = SixDOFRobot(); % Initialize 6-DOF robot

            % Set up the view
            axis([-2 2 -2 2 0 3]);
            view(3);
            
            % Create the E-stop button within the existing figure
            estop = EStop(gcf); % Add the E-stop button to the environment figure
            
            % Begin moving the 6DOF robot with E-stop control
            % main.move6DOF(robot2, env, bowlHandle, estop);
            % gui
            main.createRobotJoggingGUI(robot2, estop);
            % del
            % dobot_move.move_dobot(robot1, estop);
            pause;
        end
        
        function move6DOF(robot2, env, bowlHandle, estop)
            % Series of movements with E-stop checks
            targets = [
                0.3, -0.5, 1.01; %plate #1
                0, 0, 1.05;     % bowl
                0.55, -0.5, 1.01;   %plate #2
                0, 0, 1.05;         %bowl
                0.7, -0.5, 1.01;    %plate #3
                0, 0, 1.05          %bowl
            ];

            for i = 1:size(targets, 1)
                robot2.moveToTarget(targets(i, :), estop);
            end

            % Mixing 
            robot2.rotateLink(6, pi, 50, env, estop);

            % Delete previous bowl and continue tasks
            if ~isempty(bowlHandle) && isvalid(bowlHandle)
                delete(bowlHandle);
            end
            % Move inot oven (add bowls)
            robot2.rotateLink(5, -2/3 * pi, 50, env, estop);
            pause(1);
            % Move out of oven (add cakes)
            robot2.rotateLink(5, 2/3 * pi, 50, env, estop);

            % Add final cake to the environment
            cakePositions = [0, 0, 1];
            env.addCake(0.1, cakePositions);
            robot2.moveToTarget([0.3, -0.5, 1.01], estop);
        end

        function createRobotJoggingGUI(robot, estop)
            % Create a figure for jogging the robot
            jogFig = figure('Name', 'Robot Jogging Controls', 'NumberTitle', 'off', ...
                            'Position', [100, 100, 300, 200]);

            % Define buttons for jogging in x, y, z directions
            uicontrol('Style', 'pushbutton', 'String', 'Move +X', ...
                      'Position', [50, 150, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0.03, 0, 0], estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -X', ...
                      'Position', [150, 150, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [-0.03, 0, 0], estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move +Y', ...
                      'Position', [50, 100, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0.03, 0], estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -Y', ...
                      'Position', [150, 100, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, -0.03, 0], estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move +Z', ...
                      'Position', [50, 50, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0, 0.03], estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -Z', ...
                      'Position', [150, 50, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0, -0.03], estop));
        end
        
        function moveRobot(robot, offset, estop)
            % Move the robot by the specified offset
            % Calculate the current position of the robot
            currentPos = robot.model.fkine(robot.model.getpos()).t';
            newPos = currentPos + offset;

            % Move the robot to the new position
            robot.moveToTargetGUI(newPos, estop);
        end
    end
end
    %  function createRobotControlGUI(robot)
    %     % Create figure for the GUI
    %     guiFig = figure('Name', 'Robot Position Control', 'NumberTitle', 'off', 'Position', [100, 100, 300, 400]);
    % 
    %     % Create X slider
    %     uicontrol('Style', 'text', 'Position', [20, 350, 60, 20], 'String', 'X Position');
    %     xSlider = uicontrol('Style', 'slider', 'Position', [100, 350, 150, 20], 'Min', 0, 'Max', 1.4, 'Value', 0);
    % 
    %     % Create Y slider
    %     uicontrol('Style', 'text', 'Position', [20, 300, 60, 20], 'String', 'Y Position');
    %     ySlider = uicontrol('Style', 'slider', 'Position', [100, 300, 150, 20], 'Min', -0.7, 'Max', 0.7, 'Value', 0);
    % 
    %     % Create Z slider
    %     uicontrol('Style', 'text', 'Position', [20, 250, 60, 20], 'String', 'Z Position');
    %     zSlider = uicontrol('Style', 'slider', 'Position', [100, 250, 150, 20], 'Min', 1, 'Max', 1.5, 'Value', 1);
    % 
    %     % Set listeners after creating all sliders
    %     addlistener(xSlider, 'Value', 'PostSet', @(src, evt) main.updatePosition(robot, xSlider, ySlider, zSlider));
    %     addlistener(ySlider, 'Value', 'PostSet', @(src, evt) main.updatePosition(robot, xSlider, ySlider, zSlider));
    %     addlistener(zSlider, 'Value', 'PostSet', @(src, evt) main.updatePosition(robot, xSlider, ySlider, zSlider));
    % end
    % 
    % 
    %     % Update position callback function
    %     function updatePosition(robot, xSlider, ySlider, zSlider)
    %         % Retrieve slider values
    %         xVal = get(xSlider, 'Value');
    %         yVal = get(ySlider, 'Value');
    %         zVal = get(zSlider, 'Value');
    % 
    %         % Call moveToTarget with the new position
    %         targetPosition = [xVal, yVal, zVal];
    % 
    %         robot.moveRobotGUI(targetPosition, 2);
    %     end

    