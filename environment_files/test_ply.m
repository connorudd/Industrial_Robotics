% Read the PLY file using a built-in function
[f, v, data] = plyread('estop.ply', 'tri');
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

% Display the mesh
figure;
patch('Vertices', v, 'Faces', f, 'FaceColor', 'cyan', 'EdgeColor', 'none');
axis equal;
title('Mesh from PLY File');
xlabel('X');
ylabel('Y');
zlabel('Z');
view(3);
camlight;
lighting gouraud;
