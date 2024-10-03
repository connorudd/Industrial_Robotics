classdef environment
    methods
        function plotEnvironment(obj)
            % Set up the environment plot
            figure;
            hold on;
            title('Bakery Environment');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            view(3);
            grid on;

            % Create and plot the first robot (Dobot)
            robot1 = Dobot();  % Create an instance of the Dobot robot
          
            % Create and plot the second robot (6-DOF)
            T_robot2 = transl(2, 0, 0);  % Translate the second robot along the X-axis
            robot2 = obj.createRobot(T_robot2);

            hold off;
            drawnow;
            pause; 
        end
        
        function robot = createRobot(obj, baseTransform)
            % Define the lengths of the robot links (adjust as necessary)
            linkLengths = [0, 0.3, 0.3, 0.3, 0.3, 0.3]; % Adjust lengths for sizing

            % Create the 6-DOF robot
            robot = SixDOFRobot(linkLengths);

            % Update the robot position with the base transformation
            robot.updateJointAngles([0, pi/2, -pi/4, 0, 0, 0], baseTransform); % Initial joint angles
        end
    end
end
