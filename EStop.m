classdef EStop < handle
    properties
        Button       % UI control for the E-stop button
        IsStopped = false % Flag to indicate if E-stop is active
    end
    
    methods
        function obj = EStop(parentFig)
            % Constructor: creates the E-stop button in the specified figure.
            obj.Button = uicontrol('Parent', parentFig, 'Style', 'togglebutton', ...
                'String', 'STOP', 'FontSize', 14, 'Position', [10, 10, 80, 40], ...
                'BackgroundColor', 'red', 'ForegroundColor', 'white', ...
                'Callback', @obj.toggleStop);
        end
        
        function toggleStop(obj, ~, ~)
            % Toggle function to switch between STOP and RESUME states
            if obj.IsStopped
                obj.Button.String = 'STOP';
                obj.Button.BackgroundColor = 'red';
                obj.IsStopped = false;
            else
                obj.Button.String = 'RESUME';
                obj.Button.BackgroundColor = 'green';
                obj.IsStopped = true;
            end
        end
    end
end