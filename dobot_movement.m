classdef dobot_movement
    methods(Static)

        % A method to pick up 3 objects and place them in a line.
        function applyToppings(robot1, pickUpPositions, placePositions, obj)

            % Horizontal offset for each placed object along the X-axis
            offset = 0.1;

            % Loop to pick and place 3 objects
            for i = 1:3
                % Get the current object's pick-up position
                targetPickUpPosition = pickUpPositions(i, :);

                 % Move above the pick-up position to approach safely
                dobot_movement.moveToPosition(robot1, targetPickUpPosition + [0, 0, 0.1]);
                pause(0.5);
                
                % Move to the exact pick-up position to grab the object
                dobot_movement.moveToPosition(robot1, targetPickUpPosition);
                pause(0.5);
                
                % Hides first object and reveals object at end effector
                dobot_movement.attachObject(obj(1));
                dobot_movement.detachObject(obj(2));

                % Move back up after picking up the object
                dobot_movement.moveToPosition(robot1, targetPickUpPosition + [0, 0, 0.1]);
                
                % Calculate the object's place position with X-axis offset
                targetPlacePosition = placePositions + [(i-1) * offset, 0, 0];

                % Move above the place position to approach safely
                pause(0.5);
                dobot_movement.moveToPosition(dobot, targetPlacePosition + [0, 0, 0.1]);

                % Move to the exact place position to release the object
                pause(0.5);
                dobot_movement.moveToPosition(dobot, targetPlacePosition);

                % Hides end effector obejct and shows final position object
                dobot_movement.attachObject(obj(2));
                dobot_movement.detachObject(obj(3));

                % Move back up after placing the object
                pause(0.5);
                dobot_movement.moveToPosition(dobot, targetPlacePosition + [0, 0, 0.1]);
            end
        end
        
        % A method to smoothly move the robot to a target position.
        function moveToPosition(robot1, targetPosition)

            % Number of interpolation steps for smooth movement
            steps = 50;

            % Calculate the target joint angles using inverse kinematics
            qTarget = robot1.model.ikine(transl(targetPosition), 'mask', [1 1 1 0 0 0]);

            % Get the current joint configuration of the robot
            qCurrent = robot1.model.getpos();

            % Generate a smooth trajectory from the current to target joint configuration
            qTraj = jtraj(qCurrent, qTarget, steps);

            % Execute the trajectory step-by-step
            for j = 1:steps

                % Plot the robot's current position in the trajectory
                robot1.model.plot(qTraj(j, :));
                pause(0.1);
            end
        end

        % Simulate attaching the object to the robot by making it invisible
        function attachObject(obj)
            set(obj, 'Visible', 'off'); 
        end

        % Simulate detaching the object from the robot by making it visible
        function detachObject(obj)
            set(obj, 'Visible', 'on'); 
        end
    end
end