classdef EStop < handle
    properties
        Button             % UI control for the E-stop button
        IsStopped = false  % Flag to indicate if E-stop is active
        IsReadyToResume = false % Flag for readiness to resume after E-stop
    end
    
    methods
        function obj = EStop(parentFig)
            % Constructor: creates the E-stop button 
            obj.Button = uicontrol('Parent', parentFig, 'Style', 'togglebutton', ...
                'String', 'STOP', 'FontSize', 14, 'Position', [10, 10, 120, 40], ...
                'BackgroundColor', 'red', 'ForegroundColor', 'white', ...
                'Callback', @obj.toggleStop);
        end
        
        function toggleStop(obj, ~, ~)
            % Toggle function to handle STOP, RESUME, and REACTIVATE states
            if obj.IsStopped && obj.IsReadyToResume
                % Stop
                obj.Button.String = 'STOP';
                obj.Button.BackgroundColor = 'red';
                obj.IsStopped = false;
                obj.IsReadyToResume = false;
            elseif obj.IsStopped && ~obj.IsReadyToResume
                % Resume
                obj.Button.String = 'RESUME';
                obj.Button.BackgroundColor = 'blue';
                obj.IsReadyToResume = true;
            else
                % Reactivate before resume 
                obj.Button.String = 'REACTIVATE';
                obj.Button.BackgroundColor = 'green';
                obj.IsStopped = true;
            end
        end
    end
end
