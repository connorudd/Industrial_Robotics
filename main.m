classdef main
    methods(Static)
        function plotEnvironment()
            % Initialize environment and robots
            env = environment(); % Create the environment instance
            dobot_move = dobot_movement();
            env.plotEnvironment(); % Plot the environment
            bowlPositions = [0, 0, 1.05];
            bowlHandle = env.addBowl(2, bowlPositions);
            shapeHandle1 = env.addShape1(0.0025);
            shapeHandle2 = env.addShape2(0.0025);
            shapeHandle3 = env.addShape3(0.0025);

            robot1 = Dobot();  % Initialize Dobot robot
            robot2 = SixDOFRobot(); % Initialize 6-DOF robot

            % Set up the view
            axis([-2 2 -2 2 0 3]);
            view(3);
            
            % Create the E-stop button within the existing figure
            estop = EStop(gcf); % Add the E-stop button to the environment figure

            comPort = 'COM5';
            buttonPin = 'D2';
            hard_estop = Hardware_Estop(comPort, buttonPin);
            % hard_estop.run();
            
            
            % % Begin moving the 6DOF robot with E-stop control
            main.move6DOF(robot2, env, bowlHandle, estop, hard_estop);
            % 
            main.deleteShapes(shapeHandle3, shapeHandle2, shapeHandle1);
            % delete shape handles
            dobot_move.move_dobot(robot1, estop, hard_estop);


            % gui
            % main.createRobotJoggingGUI(robot2, estop, hard_estop);
            pause;
        end
        
        function move6DOF(robot2, env, bowlHandle, estop, hard_estop)
            % Series of movements with E-stop checks
            targets = [
                0.3, -0.5, 1.01;    %plate #1
                0, 0, 1.05;         %bowl
                0.55, -0.5, 1.01;   %plate #2
                0, 0, 1.05;         %bowl
                0.7, -0.5, 1.01;    %plate #3
                0, 0, 1.05          %bowl
            ];
            
            % first steps of the simulation 
            for i = 1:size(targets, 1)
                robot2.moveToTarget(targets(i, :), estop, hard_estop);
            end

            % Mixing 
            robot2.rotateLink(6, pi, 50, env, estop, hard_estop);

            % Delete previous bowl 
            if ~isempty(bowlHandle) && isvalid(bowlHandle)
                delete(bowlHandle);
            end
            % Move into oven (add bowls)
            robot2.rotateLink(5, -2/3 * pi, 50, env, estop, hard_estop);
            pause(1);
            % Move out of oven (add cakes)
            robot2.rotateLink(5, 2/3 * pi, 50, env, estop, hard_estop);

            % Add final cake to the environment
            cakePositions = [-0.15, 0, 1];
            env.addCake(0.1, cakePositions);
            % move away from cake
            robot2.moveToTarget([0.3, -0.5, 1.01], estop, hard_estop);
        end
        
        % delete shapes as they are replotted during dobot sim
        function deleteShapes (shapeHandle3, shapeHandle2, shapeHandle1)
             if ~isempty(shapeHandle3) && isvalid(shapeHandle3)
                delete(shapeHandle3);
             end
             if ~isempty(shapeHandle2) && isvalid(shapeHandle2)
                delete(shapeHandle2);
             end 
            if ~isempty(shapeHandle1) && isvalid(shapeHandle1)
                delete(shapeHandle1);
            end
        end


        function createRobotJoggingGUI(robot, estop, hard_estop)
            % Create a figure for jogging the robot
            jogFig = figure('Name', 'Robot Jogging Controls', 'NumberTitle', 'off', ...
                            'Position', [100, 100, 300, 200]);

            % Define buttons for jogging in x, y, z directions
            uicontrol('Style', 'pushbutton', 'String', 'Move +X', ...
                      'Position', [50, 150, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0.03, 0, 0], estop, hard_estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -X', ...
                      'Position', [150, 150, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [-0.03, 0, 0], estop, hard_estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move +Y', ...
                      'Position', [50, 100, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0.03, 0], estop, hard_estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -Y', ...
                      'Position', [150, 100, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, -0.03, 0], estop, hard_estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move +Z', ...
                      'Position', [50, 50, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0, 0.03], estop, hard_estop));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Move -Z', ...
                      'Position', [150, 50, 100, 30], ...
                      'Callback', @(src, event) main.moveRobot(robot, [0, 0, -0.03], estop, hard_estop));

            % joint control
            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 1', ...
                      'Position', [250, 50, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 1, 0.1));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 2', ...
                      'Position', [250, 100, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 2, 0.1));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 3', ...
                      'Position', [250, 150, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 3, 0.1));

            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 4', ...
                      'Position', [350, 50, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 4, 0.1));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 5', ...
                      'Position', [350, 100, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 5, 0.1));
                  
            uicontrol('Style', 'pushbutton', 'String', 'Rotate Link 6', ...
                      'Position', [350, 150, 100, 30], ...
                      'Callback', @(src, event) main.rotateRobot(robot, 6, 0.1));
        end
        
        function moveRobot(robot, offset, estop, hard_estop)
            % Move the robot by the specified offset
            % Calculate the current position of the robot
            currentPos = robot.model.fkine(robot.model.getpos()).t';
            newPos = currentPos + offset;

            % Move the robot to the new position
            robot.moveToTargetGUI(newPos, estop, hard_estop);
        end

        function rotateRobot (robot, linkIndex, angle)

            robot.rotateLinkGUI(linkIndex, angle);
        end 
    end
end