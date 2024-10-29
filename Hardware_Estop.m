classdef Hardware_Estop < handle
    % Hardware_Estop: Class for managing an E-stop system with a single button.

    properties
        arduinoObj    % Arduino connection object
        buttonPin     % Digital pin for button input
        IsStopped     % E-stop status
        canRecover    % Recovery flag
    end

    methods
        % Constructor: Initialize Arduino connection and configure pin
        function obj = Hardware_Estop(comPort, buttonPin)
            obj.arduinoObj = arduino(comPort, 'Uno', 'Libraries', 'I2C');
            obj.buttonPin = buttonPin;

            % Configure the button pin as digital input
            configurePin(obj.arduinoObj, buttonPin, 'DigitalInput');

            % Initialize states
            obj.IsStopped = false;
            obj.canRecover = false;

            disp('E-Stop system initialized. Press button to activate.');
        end

        % Main method to monitor the button and control E-stop
        function run(obj)
            while true
                buttonState = obj.readButton();

                if buttonState == 1 && ~obj.IsStopped
                    obj.activateEStop();
                elseif buttonState == 1 && obj.IsStopped && ~obj.canRecover
                    obj.recoverSystem();
                end

                pause(0.1);  % Avoid busy-waiting
            end
        end

        % (Other methods remain unchanged)
        function state = readButton(obj)
            state = readDigitalPin(obj.arduinoObj, obj.buttonPin);
        end

        function activateEStop(obj)
            disp('E-STOP ACTIVATED! Halting all operations...');
            obj.stopRobot();
            obj.IsStopped = true;
            obj.canRecover = false;
            obj.waitForButtonRelease();
            disp('E-stop disengaged. Press button again to resume.');
        end

        function recoverSystem(obj)
            obj.waitForButtonRelease();
            disp('Resuming operations...');
            obj.resumeRobot();
            obj.IsStopped = false;
            obj.canRecover = true;
        end

        function waitForButtonRelease(obj)
            while obj.readButton() == 1
                pause(0.05);
            end
        end

        function stopRobot(obj)
            disp('Robot stopped successfully.');
        end

        function resumeRobot(obj)
            disp('Robot resumed successfully.');
        end
    end
end





