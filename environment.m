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
            robot1 = Dobot();  % Create an instance of the Dobot robot
            
          
            % Create and plot the second robot (6-DOF)
            %T_robot2 = transl(2, 0, 0);  % Translate the second robot along the X-axis
            robot2 = SixDOFRobot();
            
            % Add the fence PLY model
            obj.addFence(0.004);  % Add fence at position (1, 1, 1)
            obj.addFence2(0.004);
            obj.addTable(0.01);
            obj.addExtinguisher(5);
            obj.addEstop(1.2);
            obj.addSupervisor(3);
            obj.addPlates(0.2);
            obj.addBowl(8);
            obj.addOven(2);

            % Walls and floor
             % Add concrete floor
            surf([-9,-9;9,9], [-9,9;-9,9], [0.0,0.0;0.0,0.0], ...
                'CData', imread('concrete.jpg'), 'FaceColor', 'texturemap');

            % Wall 
            surf([-9, 9; -9, 9], [9, 9; 9, 9], [10.8, 10.8; 0, 0], ...
                'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');

            surf([9, 9; 9, 9], [9, -9; 9, -9], [10.8, 10.8; 0, 0], ...
                'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');

            hold off;
            drawnow;
            pause; 
        end

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
                0, 5.2, 4
                0, -5.2, 4  % Position for the second fence
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
                5.2, 0, 4
                -5.2, 0 , 4
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
            [f, v, data] = plyread('environment_files/table.ply', 'tri');
        
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
                0, 0, 1.6
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

          function addExtinguisher(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/fireExtinguisher.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                 0  1  0;
                 0 0  1];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                8.3, 8.65, 2.5
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

          function addEstop(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/emergencyStopButton.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [0  0  -1;
                 -1  0  0;
                 0 1  0];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                8.7, 2, 2
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

         function addSupervisor(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/personFemaleBusiness.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                 0  -1  0;
                 0 0  1];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                8, 4, 3
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


         function addPlates(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/Plates.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                 0  -1  0;
                 0 0  1];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                1, -1.5, 2
                0.5, -1.5, 2
                0, -1.5, 2
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

        function addBowl(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/bowl.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                 0  -1  0;
                 0 0  1];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                0, 0, 2.3
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

        function addOven(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/cake.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [0  1  0;
                 -1  0  0;
                 0 0  1];

            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';  % Rotate the vertices
        
            % Desired position of the table
              desiredPositions = [
                0, 1.5, 3
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
