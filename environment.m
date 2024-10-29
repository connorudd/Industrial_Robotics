classdef environment
    methods
        function plotEnvironment(obj)
            close all;
            % Set up the environment plot
            fig = figure;
            hold on;
            title('Bakery Environment');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            view(3);
            grid on;

            % Add the E-stop button
            estop = EStop(fig); % Create the E-stop button on the environment figure
            
            % Add the fence PLY model
            obj.addFence(0.002);  % Add fence at position (1, 1, 1)
            obj.addFence2(0.002);
            obj.addTable(0.005);
            obj.addExtinguisher(4);
            obj.addEstop(1.2);
            obj.addSupervisor(2);
            obj.addPlates(0.1);
            % obj.addBowl(2);
            obj.addOven(1);
            % obj.addShape1(0.0025);
            % obj.addShape2(0.0025);
            % obj.addShape3(0.0025);

            % Walls and floor
             % Add concrete floor
            surf([-5,-5;5,5], [-5,5;-5,5], [0.0,0.0;0.0,0.0], ...
                'CData', imread('concrete.jpg'), 'FaceColor', 'texturemap');

            % Wall 
            surf([-5, 5; -5, 5], [5, 5; 5, 5], [6.8, 6.8; 0, 0], ...
                'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');

            surf([5, 5; 5, 5], [5, -5; 5, -5], [6.8, 6.8; 0, 0], ...
                'CData', imread('bakery.jpg'), 'FaceColor', 'texturemap');

            
           
            drawnow;
            % pause;
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
                0, 2.6, 2
                0, -2.6, 2  % Position for the second fence
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
                2.6, 0, 2
                -2.6, 0 , 2
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
                4.3, 4.65, 2.5
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
                4.7, 2, 2
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
                4, 2.7, 2
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
                0.3, -0.5, 0.98
                0.5, -0.6, 0.98
                0.7, -0.5, 0.98
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

         function bowlHandle = addBowl(obj, scale, desiredPosition)
            % Read the PLY file containing the bowl's mesh
            [f, v, data] = plyread('environment_files/bowl.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.8, 0.5, 0.5], size(v, 1), 1);  % Default red color
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                  0 -1  0;
                  0  0  1];
        
            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';
        
            % Calculate the translation to move the bowl to the desired position
            translation = desiredPosition - mean(v_rotated, 1);
        
            % Translate the vertices based on the calculated translation
            v_translated = v_rotated + translation;
        
            % Plot the bowl using trisurf
            bowlHandle = trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                    'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
        
            % Set lighting to see colors of the bowl
            lighting gouraud;
        end

        function addOven(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/oven.ply', 'tri');
        
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
                -0.17, 0.7, 1.35
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


        function shapeHandle1 = addShape1(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/blue_octagon.ply', 'tri');
        
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
                -0.55, -0.2, 1
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                shapeHandle1 = trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
        end


        function shapeHandle2 = addShape2(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/green_square.ply', 'tri');
        
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
                -0.4, -0.2, 1
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                shapeHandle2 = trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
        end


        function shapeHandle3 = addShape3(obj, scale)
            % Read the PLY file containing the brick's mesh
            [f, v, data] = plyread('environment_files/red_hexagon.ply', 'tri');
        
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
                -0.25, -0.2, 1
                ];
              
            for i = 1:size(desiredPositions, 1)
                % Calculate the translation to move the fence to the desired position
                translation = desiredPositions(i, :) - mean(v_rotated, 1);  % Translate to center around the desired position
        
                % Translate the vertices based on the calculated translation
                v_translated = v_rotated + translation;  % Translate the vertices
        
                % Plot the fence using trisurf
                shapeHandle3 = trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                        'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
            end
        
            % Set lighting to see colors of the bricks
            lighting gouraud;
        end

          function cakeHandle = addCake(obj, scale, desiredPosition)
            % Read the PLY file containing the bowl's mesh
            [f, v, data] = plyread('environment_files/cake.ply', 'tri');
        
            % Get the vertex colors if available
            if isfield(data.vertex, 'red') && isfield(data.vertex, 'green') && isfield(data.vertex, 'blue')
                vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
            else
                % Default color if vertex colors are not available
                vertexColours = repmat([0.6, 0.3, 0], size(v, 1), 1); 
            end
        
            % Rotation matrix (90 degrees around z-axis)
            R = [-1  0  0;
                  0 -1  0;
                  0  0  1];
        
            % Scale the vertices
            v_scaled = v * scale;  % Scale the vertices by the given factor
        
            % Rotate the vertices
            v_rotated = (R * v_scaled')';
        
            % Calculate the translation to move the bowl to the desired position
            translation = desiredPosition - mean(v_rotated, 1);
        
            % Translate the vertices based on the calculated translation
            v_translated = v_rotated + translation;
        
            % Plot the bowl using trisurf
            cakeHandle = trisurf(f, v_translated(:, 1), v_translated(:, 2), v_translated(:, 3), ...
                    'FaceVertexCData', vertexColours, 'EdgeColor', 'interp', 'EdgeLighting', 'flat');
        
            % Set lighting to see colors of the bowl
            lighting gouraud;
        end

    end
end
