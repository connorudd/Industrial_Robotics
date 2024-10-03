classdef main
    methods(Static)
        function run()
            figure;
            hold on;
            axis equal;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            view(3);
            % Create an instance of the Dobot robot
            robot = Dobot();
            robot_2 = main.createRobot();
        end
        function robot = createRobot()
            % Define the lengths of the robot links
            linkLengths = [0, 0.5, 0.5, 0.5, 0.5, 0.5]; % Adjust lengths as needed
            
            % Create the robot
            robot = SixDOFRobot(linkLengths);

            % % Create the figure
            figure;
            hold on;

            % Update the robot position on the rail
            robot.updateJointAngles([0, pi/2, -pi/4, 0, 0, 0]); % Initial joint angles
            
        end

    end
end


