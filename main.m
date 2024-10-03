classdef main
    methods(Static)
        function plotEnvironment()
            figure;
            hold on;
            title('Bakery');
            axis equal;
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            view(3);
            grid on;

            % Create and plot the first robot
            T_robot1 = transl(0,0,0);
            robot1 = main.createRobot(T_robot1);  % Robot 1 at default origin (identity matrix)

            % Create and plot the second robot with a different base position
            T_robot2 = transl(2, 0, 0);  % Translate the second robot 1 meter along the X-axis
            robot2 = main.createRobot(T_robot2);

            hold off;
        end

        function robot = createRobot(baseTransform)
            % Define the lengths of the robot links
            linkLengths = [0, 0.5, 0.5, 0.5, 0.5, 0.5]; % Adjust lengths as needed
            
            % Create the robot
            robot = SixDOFRobot(linkLengths);

            % Update the robot position with the base transformation
            robot.updateJointAngles([0, pi/2, -pi/4, 0, 0, 0], baseTransform); % Initial joint angles
        end
    end
end
