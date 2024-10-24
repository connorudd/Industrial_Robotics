classdef main
    methods(Static)
        function plotEnvironment()
            % Create an instance of the Environment class
            env = environment(); % Create the environment instance
            % 
            % % Plot the environment with the robots
            env.plotEnvironment(); % Call the method to plot the environment

            % Create and plot the first robot (Dobot)
            robot1 = Dobot();  % Create an instance of the Dobot robot
          
            % Create and plot the second robot (6-DOF)
            %T_robot2 = transl(2, 0, 0);  % Translate the second robot along the X-axis
            robot2 = SixDOFRobot();

            %% robot view 
            % axis([-2 2 -2 2 0 3]); 
             axis equal;
            view(3);
            %% moving 6DOF
            % robot2.model.teach(); 
            % % plate #1 location 
            % robot2.moveToTarget([0.3, -0.5, 1.0]);
            % % bowl
            % robot2.moveToTarget([0, 0, 1.05]);
            % % plate 2
            % robot2.moveToTarget([0.55, -0.5, 1.0]);
            % % bowl
            % robot2.moveToTarget([0, 0, 1.05]);
            % % plate 3
            % robot2.moveToTarget([0.7, -0.5, 1.0]);
            % % bowl
            % robot2.moveToTarget([0, 0, 1.05]);
            % % oven location 
            % robot2.moveToTarget([-0.13, 0.45, 1.3]);

            
            pause;

        end
    end
end




