% classdef SixDOFRobot < RobotBaseClass
%     %% UR3 Universal Robot 3kg payload robot model
%     properties(Access = public)   
%         plyFileNameStem = 'SizDOFRobot';
%     end
% 
%     methods
% %% Constructor
%         function self = SizaDOFRobot(baseTr,useTool,toolFilename)
%             if nargin < 3
%                 if nargin == 2
%                     error('If you set useTool you must pass in the toolFilename as well');
%                 elseif nargin == 0 % Nothing passed
%                     baseTr = transl(0,0,0);  
%                 end             
%             else % All passed in 
%                 self.useTool = useTool;
%                 toolTrData = load([toolFilename,'.mat']);
%                 self.toolTr = toolTrData.tool;
%                 self.toolFilename = [toolFilename,'.ply'];
%             end
% 
%             self.CreateModel();
% 			self.model.base = self.model.base.T * baseTr;
%             self.model.tool = self.toolTr;
%             self.PlotAndColourRobot();
% 
%             drawnow
%         end
% 
% %% CreateModel
%         function CreateModel(self)
%             link(1) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360 360]), 'offset',0);
%             link(2) = Link('d',0.1,'a',0,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
%             link(3) = Link('d',0.1,'a',0,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
%             link(4) = Link('d',0.1,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
%             link(5) = Link('d',0.1,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
%             link(6) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
%             link(7) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360 360]), 'offset',0);
% 
%             self.model = SerialLink(link,'name',self.name);
%         end      
%     end
% end

classdef SixDOFRobot < RobotBaseClass
    %% UR3 Universal Robot 3kg payload robot model
    %
    % WARNING: This model has been created by UTS students in the subject
    % 41013. No guarantee is made about the accuracy or correctness of the
    % DH parameters or the accompanying ply files. Do not assume
    % that this matches the real robot!

    properties(Access = public)   
        plyFileNameStem = 'SizDOFRobotLink';  % Base name for ply files
    end
    
    methods
        %% Constructor
        function self = SixDOFRobot(baseTr, useTool, toolFilename)
            if nargin < 3
                if nargin == 2
                    error('If you set useTool you must pass in the toolFilename as well');
                elseif nargin == 0 % Nothing passed
                    baseTr = transl(0,0,0);  
                end             
            else % All passed in 
                self.useTool = useTool;
                toolTrData = load([toolFilename,'.mat']);
                self.toolTr = toolTrData.tool;
                self.toolFilename = [toolFilename,'.ply'];
            end
          
            self.CreateModel();
            self.model.base = self.model.base.T * baseTr;
            self.model.tool = self.toolTr;
            self.PlotAndColourRobot();

            drawnow
        end

        %% CreateModel
        function CreateModel(self)
            link(1) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360 360]), 'offset',0);
            link(2) = Link('d',0.1,'a',0,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            link(3) = Link('d',0.1,'a',0,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            link(4) = Link('d',0.1,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            link(5) = Link('d',0.1,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            link(6) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            link(7) = Link('d',0.1,'a',0,'alpha',0,'qlim',deg2rad([-360 360]), 'offset',0);
             
            self.model = SerialLink(link,'name','SixDOFRobot');
        end
        
        %% PlotAndColourRobot
        function PlotAndColourRobot(self)
            for linkIndex = 0:self.model.n
                % Get the ply filename for each link
                plyFilePath = fullfile('path_to_ply_files', [self.plyFileNameStem, num2str(linkIndex), '.ply']);
                if exist(plyFilePath, 'file') == 2  % Check if the file exists
                    [faceData, vertexData, plyData] = plyread(plyFilePath, 'tri');
                    
                    % Scale the colours to be 0-to-1 (if ply files contain RGB info)
                    vertexColours = [plyData.vertex.red, plyData.vertex.green, plyData.vertex.blue] / 255;
                    
                    % Plot the link
                    self.model.faces{linkIndex+1} = faceData;
                    self.model.points{linkIndex+1} = vertexData;
                    
                    % Attach patch objects to the robot
                    patch('Faces', faceData, 'Vertices', vertexData, ...
                          'FaceVertexCData', vertexColours, ...
                          'EdgeColor', 'interp', 'FaceColor', 'interp');
                else
                    error(['PLY file not found: ', plyFilePath]);
                end
            end
        end
    end
end


