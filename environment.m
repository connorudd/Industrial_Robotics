classdef environment
    methods
        function plotEnvironment(obj)
            close all;
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
            % robot1 = Dobot();  % Create an instance of the Dobot robot
            
          
            % Create and plot the second robot (6-DOF)
            %T_robot2 = transl(2, 0, 0);  % Translate the second robot along the X-axis
            robot2 = SixDOFRobot();
            
            % % Add the fence PLY model
            % obj.addFence(0.001);  % Add fence at position (1, 1, 1)
            % obj.addFence2(0.001);
            % obj.addTable(0.004);

            % Walls and floor
            %  % Add concrete floor
            % surf([-3,-3;3,3], [-3,3;-3,3], [0.0,0.0;0.0,0.0], ...
            %     'CData', imread('concrete.jpg'), 'FaceColor', 'texturemap');
            % 
            % % Wall 
            % % Shifted to make the bottom of the image align with z = 0
            % surf([-3, 3; -3, 3], [3, 3; 3, 3], [3.6, 3.6; 0, 0], ...
            %     'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');
            % 
            % surf([3, 3; 3, 3], [3, -3; 3, -3], [3.6, 3.6; 0, 0], ...
            %     'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');

            hold off;
            drawnow;
            pause; 
        end
        
        % function robot = createRobot(obj, baseTransform)
        %     % Define the lengths of the robot links (adjust as necessary)
        %     linkLengths = [0, 0.3, 0.3, 0.3, 0.3, 0.3]; % Adjust lengths for sizing
        % 
        %     % Create the 6-DOF robot
        %     robot = SixDOFRobot(linkLengths);
        % 
        %     % Update the robot position with the base transformation
        %     robot.updateJointAngles([0, pi/2, -pi/4, 0, 0, 0], baseTransform); % Initial joint angles
        % end

          function addFence(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/Safety Fence.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.5, 0.5, 0.5], size(v, 1), 1); 
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [0  0  1;  % Corrected to match standard rotation matrix for 90 degrees
                 -1   0  0;
                 0   1  0];
        
            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired final position of the fence
              desiredPositions = [
                0, 1.3, 1
                0, -1.3, 1  % Position for the second fence
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
        end

          function addFence2(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/Safety Fence.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.5, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [1  0  0;
                 0  0  1;
                 0 -1  0];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired final position of the fence
              desiredPositions = [
                1.3, 0, 1
                -1.3, 0 , 1
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
          end

          function addTable(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/Table.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                 0  0  1;
                 0 1  0];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                0, 0, 0.8
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
          end

       
    end
end
