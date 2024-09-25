classdef main
    methods(Static)
        function run()
            % Create an instance of the Dobot robot
            robot = Dobot();

        end
        function createRobotOnRail()
            % Define the lengths of the robot links
            linkLengths = [0, 0.5, 0.5, 0.5, 0.5, 0.5]; % Adjust lengths as needed
            
            % Create the robot
            robot = SixDOFRobot(linkLengths);

            % % Create the figure
            figure;
            hold on;

            % Update the robot position on the rail
            robot.updateJointAngles([0, pi/2, -pi/4, 0, 0, 0]); % Initial joint angles
            
            % % Set the view
            % view(3);
            % grid on;
            % axis equal;
            % title('6DOF Robot on Linear Rail');
            % xlabel('X-axis');
            % ylabel('Y-axis');
            % zlabel('Z-axis');
        end

    end
end


