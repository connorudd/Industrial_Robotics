classdef Hardware_Estop < handle
    % EStopSystem: Class for managing an E-stop system with a single button.

    properties (Access = private)
        arduinoObj    % Arduino connection object
        buttonPin     % Digital pin for button input
        isStopped     % E-stop status
        canRecover    % Recovery flag
    end

    methods
        % Constructor: Initialize Arduino connection and configure pin
        function obj = Hardware_Estop(comPort, buttonPin)
            % Establish Arduino connection
            obj.arduinoObj = arduino(comPort, 'Uno', 'Libraries', 'I2C');
            obj.buttonPin = buttonPin;

            % Configure the button pin as digital input
            configurePin(obj.arduinoObj, buttonPin, 'DigitalInput');

            % Initialize states
            obj.isStopped = false;
            obj.canRecover = false;

            disp('E-Stop system initialized. Press button to activate.');
        end

        % Main method to monitor the button and control E-stop
        function run(obj)
            while true
                buttonState = obj.readButton();

                if buttonState == 1 && ~obj.isStopped
                    % E-stop activated
                    obj.activateEStop();
                elseif buttonState == 1 && obj.isStopped && ~obj.canRecover
                    % Recovery process initiated
                    obj.recoverSystem();
                end

                pause(0.1);  % Avoid busy-waiting
            end
        end

        % Private method to read the button state
        function state = readButton(obj)
            state = readDigitalPin(obj.arduinoObj, obj.buttonPin);  % 0 = Pressed
        end

        % Private method to handle E-stop activation
        function activateEStop(obj)
            disp('E-STOP ACTIVATED! Halting all operations...');
            obj.stopRobot();
            obj.isStopped = true;
            obj.canRecover = false;

            obj.waitForButtonRelease();  % Ensure button is released
            disp('E-stop disengaged. Press button again to resume.');
        end

        % Private method to handle system recovery
        function recoverSystem(obj)
            obj.waitForButtonRelease();  % Ensure button is released
            disp('Resuming operations...');
            obj.resumeRobot();

            obj.isStopped = false;
            obj.canRecover = true;
        end

        % Private helper method to ensure the button is released
        function waitForButtonRelease(obj)
            while obj.readButton() == 1
                pause(0.05);  % Small delay to avoid busy-waiting
            end
        end

        % Placeholder method to stop the robot (override if needed)
        function stopRobot(obj)
            disp('Robot stopped successfully.');
        end

        % Placeholder method to resume the robot (override if needed)
        function resumeRobot(obj)
            disp('Robot resumed successfully.');
        end
    end
end


