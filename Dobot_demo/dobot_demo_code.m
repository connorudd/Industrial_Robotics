%% Workspace Setup Function
    clf;
    clc;
    % Create and plot robot
    robot = DobotMagician();
    q0 = [0, pi/6, pi/4, pi/2, 0];
    workspace = [-1, 1, -1, 1, 0, 1];
    scale = 0.5;
    robot.model.plot(q0,'workspace',workspace,'scale',scale);
    axis(workspace);
    hold on;

    % Plot for green square
    [f, v, data] = plyread('green_square.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    square_start_position = [0.25, 0, 0.05];
    square_scale_factor = 0.002;
    square_v_scaled = v * square_scale_factor;
    square_v_transformation = square_v_scaled + square_start_position;
    square1 = trisurf(f, square_v_transformation(:, 1), square_v_transformation(:, 2), square_v_transformation(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');
    
    % Plot for blue triangle
    [f, v, data] = plyread('blue_triangle.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    triangle_start_position = [0.25, 0.05, 0.05];
    % triangle_theta = pi / 2;
    % R = [cos(triangle_theta), -sin(triangle_theta), 0;
          % sin(triangle_theta),  cos(triangle_theta), 0;
          % 0, 0, 1];
    triangle_scale_factor = 0.002;
    triangle_v_scaled = v * triangle_scale_factor;
    triangle_v_transformation = triangle_v_scaled + triangle_start_position;
    % triangle_v_rotated = (triangle_v_transformation * R)';
    triangle1 = trisurf(f,  triangle_v_transformation(:, 1),  triangle_v_transformation(:, 2),  triangle_v_transformation(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');

    % Plot for red hexagon
    [f, v, data] = plyread('red_hexagon.ply', 'tri');
    vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
    start_position = [0.25, -0.05, 0.03];
    scale_factor = 0.001;
    v_scaled = v * scale_factor;
    v_transformation = v_scaled + start_position;
    hexagon1 = trisurf(f, v_transformation(:, 1), v_transformation(:, 2), v_transformation(:, 3), ...
        'FaceVertexCData', vertexColours, ...
        'FaceColor', 'interp', ...
        'EdgeColor', 'none');

%% Create camera and plot to robot end effector

pStar = [250 500 750; 600 600 600 ];

P = [0.25, 0.25, 0.25; 
     0, 0.05, -0.05;
     0.05, 0.05, 0.03];

lambda = 0.1;
focal_length = 0.08;
pixel_size = 10e-5;
resolution = [1024 1024];
centre = resolution / 2;
fps = 25;
cam = CentralCamera('focal', focal_length, 'pixel', pixel_size, ...
                        'resolution', resolution, 'centre',centre, 'fps', fps, 'name', 'Dobot Camera');
Tc0 = robot.model.fkine(q0);
R = roty(pi);
Tc_reversed = (Tc0 * R);
cam.T = Tc0;
cam.plot_camera('pose', Tc0, 'scale', 0.035); 

cam.T = Tc0;
p = cam.plot(P);
cam.clf()
cam.plot(pStar, '*'); 
cam.hold(true);
cam.plot(P, 'pose', Tc0, 'o'); 
    
pause(2)
cam.hold(true);
cam.plot(P);   













