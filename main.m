classdef main
    methods(Static)
        function plotEnvironment()
            % Create an instance of the Environment class
            env = environment(); % Create the environment instance
            % 
            % % Plot the environment with the robots
            env.plotEnvironment(); % Call the method to plot the environment
            bowlPositions = [0, 0, 1.05];
            bowlHandle = env.addBowl(2, bowlPositions);

            % Create and plot the first robot (Dobot)
            robot1 = Dobot();  % Create an instance of the Dobot robot

            % Create and plot the second robot (6-DOF)
            %T_robot2 = transl(2, 0, 0);  % Translate the second robot along the X-axis
            robot2 = SixDOFRobot();

            %% robot view 
             axis([-2 2 -2 2 0 3]); 
             % axis equal;
            view(3);
            %% moving 6DOF
            % robot2.model.teach(); 
            main.move6DOF(robot2, env, bowlHandle);
            pause;

        end
        function move6DOF(robot2, env, bowlHandle)

            % plate #1 location 
            robot2.moveToTarget([0.3, -0.5, 1.01]);
            % bowl
            robot2.moveToTarget([0, 0, 1.05]);
            % plate 2
            robot2.moveToTarget([0.55, -0.5, 1.01]);
            % bowl
            robot2.moveToTarget([0, 0, 1.05]);
            % plate 3
            robot2.moveToTarget([0.7, -0.5, 1.01]);
            % bowl
            robot2.moveToTarget([0, 0, 1.05]);
            % mix ingredients
            robot2.rotateLink(6, pi, 50, env);
            % delete previous bowl 
            if ~isempty(bowlHandle) && isvalid(bowlHandle)
                delete(bowlHandle);
            end
            % oven location and bowl plotting
            robot2.rotateLink(5, -2/3*pi, 50, env);
            pause(1);
            % back to cake and cake plotting
            robot2.rotateLink(5, 2/3*pi, 50, env);
            % cake on table 
            cakePositions = [0, 0, 1];
            cakeHandle = env.addCake(0.1, cakePositions);

            robot2.moveToTarget([0.3, -0.5, 1.01]);
        end 
    end
end

% 
% classdef main
%     properties (Constant)
%         isPaused = false; % Global variable to keep track of paused state
%         eStopButton;      % Handle for the E-Stop button
%     end
% 
%     methods(Static)
%         function plotEnvironment()
%             % Create an instance of the Environment class
%             env = environment(); % Create the environment instance
% 
%             % Plot the environment with the robots
%             env.plotEnvironment(); % Call the method to plot the environment
%             bowlPositions = [0, 0, 1.05];
%             bowlHandle = env.addBowl(2, bowlPositions);
% 
%             % Create and plot the first robot (Dobot)
%             robot1 = Dobot();  % Create an instance of the Dobot robot
% 
%             % Create and plot the second robot (6-DOF)
%             robot2 = SixDOFRobot();
% 
%             %% robot view 
%             axis([-2 2 -2 2 0 3]); 
%             view(3);
% 
%             %% Create E-Stop button
%             main.createEStopButton();
% 
%             %% moving 6DOF
%             main.move6DOF(robot2, env, bowlHandle);
%             pause;
%         end
% 
%         function createEStopButton()
%             % Create a figure for the E-Stop button
%             main.eStopButton = uicontrol('Style', 'togglebutton', ...
%                 'String', 'Pause', ...
%                 'Position', [20 20 100 40], ...
%                 'Callback', @main.toggleEStop);
%         end
% 
%         function toggleEStop(~, ~)
%             % Toggle the paused state
%             main.isPaused = ~main.isPaused;
%             if main.isPaused
%                 set(main.eStopButton, 'String', 'Resume'); % Change button text
%             else
%                 set(main.eStopButton, 'String', 'Pause');  % Change button text
%             end
%         end
% 
%         function move6DOF(robot2, env, bowlHandle)
%             % Plate #1 location 
%             robot2.moveToTarget([0.3, -0.5, 1.01]);
%             main.checkPause();  % Check if paused
% 
%             % Bowl
%             robot2.moveToTarget([0, 0, 1.05]);
%             main.checkPause();  % Check if paused
% 
%             % Plate 2
%             robot2.moveToTarget([0.55, -0.5, 1.01]);
%             main.checkPause();  % Check if paused
% 
%             % Bowl
%             robot2.moveToTarget([0, 0, 1.05]);
%             main.checkPause();  % Check if paused
% 
%             % Plate 3
%             robot2.moveToTarget([0.7, -0.5, 1.01]);
%             main.checkPause();  % Check if paused
% 
%             % Bowl
%             robot2.moveToTarget([0, 0, 1.05]);
%             main.checkPause();  % Check if paused
% 
%             % Mix ingredients
%             robot2.rotateLink(6, pi, 50, env);
%             main.checkPause();  % Check if paused
% 
%             % Delete previous bowl 
%             if ~isempty(bowlHandle) && isvalid(bowlHandle)
%                 delete(bowlHandle);
%             end
% 
%             % Oven location and bowl plotting
%             robot2.rotateLink(5, -2/3*pi, 50, env);
%             main.checkPause();  % Check if paused
% 
%             pause(1); % Optional pause for effect
% 
%             % Back to cake and cake plotting
%             robot2.rotateLink(5, 2/3*pi, 50, env);
%             main.checkPause();  % Check if paused
% 
%             % Cake on table 
%             cakePositions = [0, 0, 1];
%             cakeHandle = env.addCake(0.1, cakePositions);
% 
%             robot2.moveToTarget([0.3, -0.5, 1.01]);
%             main.checkPause();  % Check if paused
%         end 
% 
%         function checkPause()
%             while main.isPaused
%                 pause(0.1);  % Wait until resumed
%             end
%         end
%     end
% end
% 
% 


