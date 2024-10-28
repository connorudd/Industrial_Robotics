classdef EStop < handle
    properties
        Button             % UI control for the E-stop button
        IsStopped = false  % Flag to indicate if E-stop is active
        IsReadyToResume = false % Flag for readiness to resume after E-stop
    end
    
    methods
        function obj = EStop(parentFig)
            % Constructor: creates the E-stop button in the specified figure.
            obj.Button = uicontrol('Parent', parentFig, 'Style', 'togglebutton', ...
                'String', 'STOP', 'FontSize', 14, 'Position', [10, 10, 120, 40], ...
                'BackgroundColor', 'red', 'ForegroundColor', 'white', ...
                'Callback', @obj.toggleStop);
        end
        
        function toggleStop(obj, ~, ~)
            % Toggle function to handle STOP, RESUME, and READY TO RESUME states
            if obj.IsStopped && obj.IsReadyToResume
                % Second press after RESUME: truly resumes the action
                obj.Button.String = 'STOP';
                obj.Button.BackgroundColor = 'red';
                obj.IsStopped = false;
                obj.IsReadyToResume = false;
            elseif obj.IsStopped && ~obj.IsReadyToResume
                % First press after STOP: sets to READY TO RESUME
                obj.Button.String = 'RESUME';
                obj.Button.BackgroundColor = 'blue';
                obj.IsReadyToResume = true;
            else
                % Initial STOP activation
                obj.Button.String = 'REACTIVATE';
                obj.Button.BackgroundColor = 'green';
                obj.IsStopped = true;
            end
        end
    end
end
