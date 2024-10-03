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
            
            % Add the fence PLY model
            obj.addFence();  % Add fence at position (1, 1, 1)

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

      function addFence(obj)
        % Read the PLY file containing the brick's mesh
        [f, v, data] = plyread('environment_files/Safety Fence.ply', 'tri');
    
        % Get the vertex colors if available
        if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
            vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
        else
            % Default color if vertex colors are not available
            vertexColours = repmat([1, 0, 0], size(v, 1), 1);  % Red color
        end
    
        % Define brick positions of wall -y,x,z (this form due to transformations)
        fencePositions = [
            [-4, -4, 0.0];
            [-4, 4, 0.0];
            [4, 4, 0.0];
            [4, -4, 0.0];
        ];
    
        % Rotation matrix (90 degrees around z-axis)
        theta = pi / 2;
        R = [cos(theta) -sin(theta) 0;
             sin(theta)  cos(theta) 0;
             0           0        1];
    
        % Translate the vertices based on the desired fence position
        % Choose the appropriate position (in this case, using the last position in fencePositions)
        translation = fencePositions(4, :);
        v_translated = v + translation;  % Translate the vertices
    
        % Rotate the vertices
        v_rotated = (R * v_translated')';  % Rotate the vertices
    
        % Plot the fence using trisurf
      
        trisurf(f, v_rotated(:, 1), v_rotated(:, 2), v_rotated(:, 3), ...
                'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
    
        % Set lighting to see colors of the bricks
        lighting gouraud;
        axis equal;  % Set axis to equal for proper scaling
    end

    end
end
