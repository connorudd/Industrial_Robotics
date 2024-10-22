% Define the robot links with all lengths set to 0
link(1) = Link('d', 0.4, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
link(2) = Link('d', 0.4, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0); % Make alpha = pi/2 for upright orientation
link(3) = Link('d', 0.4, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
link(4) = Link('d', 0.4, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
link(5) = Link('d', 0.4, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
link(6) = Link('d', 0.4, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);


% Create the robot model
robot = SerialLink(link, 'name', 'MyRobot');

% Set joint angles to zero
q = zeros(1, 6);  % 6 joint angles for the robot

% Plot the robot with all joint angles set to 0
figure;
robot.plot(q);
title('Robot with All Joint Angles Set to Zero');
