classdef SixDOFRobot < RobotBaseClass
    properties(Access =public)   
        plyFileNameStem = 'SixDOFRobot';

        %> defaultRealQ 
        defaultRealQ  = [0,0,0,0,0,0];
    end

    methods (Access = public) 
%% Constructor 
        function self = SixDOFRobot(baseTr)
			self.CreateModel();
            if nargin == 1			
				self.model.base = self.model.base.T * baseTr;
            end            
            self.homeQ = self.RealQToModelQ(self.defaultRealQ);
            self.PlotAndColourRobot();
        end

 %% Move to Target Position
    function moveToTarget(self, targetPosition)
        % Create a transformation matrix for the target position
        T_target = transl(targetPosition(1), targetPosition(2), targetPosition(3));

        % Calculate the inverse kinematics to find joint angles
        q_sol = self.model.ikine(T_target, 'mask', [1, 1, 1, 0, 0, 0]); % Mask to consider only position

        if isempty(q_sol)
            error('No solution found for the target position');
        else
            % Get the current joint angles
            q_current = self.model.getpos();

            % Define the number of steps for smooth animation
            numSteps = 50;

            % Interpolate between the current and target joint angles
            qMatrix = jtraj(q_current, q_sol, numSteps);

            % Animate the robot movement step by step
            for i = 1:numSteps
                self.model.animate(qMatrix(i, :));
                pause(0.05); % Pause to control the speed of the animation
            end
        end
    end
%% CreateModel
        function CreateModel(self)       
            link(1) = Link('d', 0.3, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(2) = Link('d', -0.5, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0); 
            link(3) = Link('d', 0, 'a', 0, 'alpha', -pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d', -0.2, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(5) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', deg2rad([-360 360]), 'offset', 0);
            link(6) = Link('d', -0.25, 'a', 0, 'alpha', 0, 'qlim', deg2rad([-360 360]), 'offset', 0);


            self.model = SerialLink(link,'name',self.name);

            self.model.base = transl(0.5, 0, 1);
        end   
    end
    
    methods(Hidden)
%% TestMoveJoints
        % Overriding the RobotBaseClass function, since it won't work properly
        % for this robot
        function TestMoveJoints(self)
            self.TestMoveSixDOF();
        end

%% Test Move Dobot
    function TestMoveSixDOF(self)
            qPath = jtraj(self.model.qlim(:,1)',self.model.qlim(:,2)',50);                       
            for i = 1:50              
                self.model.animate(self.RealQToModelQ(qPath(i,:)));
                pause(0.2);
            end
        end
    end
    methods(Static)
%% RealQToModelQ
        % Convert the real Q to the model Q
        function modelQ = RealQToModelQ(realQ)
            modelQ = realQ;
            modelQ(3) = Dobot.ComputeModelQ3GivenRealQ2and3( realQ(2), realQ(3) );
            modelQ(4) = pi - realQ(2) - modelQ(3);    
        end
        
%% ModelQ3GivenRealQ2and3
        % Convert the real Q2 & Q3 into the model Q3
        function modelQ3 = ComputeModelQ3GivenRealQ2and3(realQ2,realQ3)
            modelQ3 = pi/2 - realQ2 + realQ3;
        end
        
%% ModelQToRealQ
        % Convert the model Q to the real Q
        function realQ = ModelQToRealQ( modelQ )
            realQ = modelQ;
            realQ(3) = Dobot.ComputeRealQ3GivenModelQ2and3( modelQ(2), modelQ(3) );
        end
        
%% RealQ3GivenModelQ2and3
        % Convert the model Q2 & Q3 into the real Q3
        function realQ3 = ComputeRealQ3GivenModelQ2and3( modelQ2, modelQ3 )
            realQ3 = modelQ3 - pi/2 + modelQ2;
        end
    end
end
