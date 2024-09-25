classdef main
    methods(Static)
        function run()
            % Create an instance of the Dobot robot
            robot = Dobot();

        end
        function createRobotOnRail()
            % Define the lengths of the robot links
            linkLengths = [2, 1, 1, 0.5, 0.5, 0.5]; % Adjust lengths as needed
            
            % Create the robot
            robot = SixDOFRobot(linkLengths);
            
            % Define the rail limits
            railLength = 2; % Length of the linear rail
            railPosition = [0, 0, 0]; % Starting position of the rail
            
            % Create the figure
            figure;
            hold on;
            
            % Draw the linear rail
            plot3([railPosition(1), railPosition(1) + railLength], ...
                  [railPosition(2), railPosition(2)], ...
                  [railPosition(3), railPosition(3)], 'k-', 'LineWidth', 3);
            
            % Update the robot position on the rail
            robot.updateJointAngles([1, 0, 0, 0, 0, 0]); % Initial joint angles
            
            % Set the view
            view(3);
            grid on;
            axis equal;
            title('6DOF Robot on Linear Rail');
            xlabel('X-axis');
            ylabel('Y-axis');
            zlabel('Z-axis');
        end

    end
end


