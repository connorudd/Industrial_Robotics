classdef Hardware_Estop < handle
    % Hardware_Estop: Class for managing an emergency stop (E-stop) system with a single button.
    
    properties
        arduinoObj    % Object for the Arduino connection
        buttonPin     % Digital pin connected to the E-stop button
        IsStopped     % Boolean status of the E-stop (true if activated)
        canRecover    % Flag indicating if recovery is allowed after E-stop
    end
    
    methods
        % Constructor: Initializes the Arduino connection and configures the button pin
        function obj = Hardware_Estop(comPort, buttonPin)
            % Set up Arduino object and specify the port and board type
            obj.arduinoObj = arduino(comPort, 'Uno', 'Libraries', 'I2C');
            obj.buttonPin = buttonPin;  % Set the pin connected to the E-stop button

            % Configure the button pin as a digital input
            configurePin(obj.arduinoObj, buttonPin, 'DigitalInput');

            % Initialize the initial states for E-stop and recovery
            obj.IsStopped = false;       % System initially not in E-stop mode
            obj.canRecover = false;      % Recovery is initially not permitted

            disp('E-Stop system initialized. Press button to activate.');
        end

        % Main method to monitor the button and control the E-stop state
        function run(obj)
            while true
                buttonState = obj.readButton();  % Read the button state
                
                % Check for button press to activate E-stop if not already active
                if buttonState == 1 && ~obj.IsStopped
                    obj.activateEStop();  % Activate E-stop if button is pressed
                    
                % If E-stop is active and recovery is not permitted, allow recovery
                elseif buttonState == 1 && obj.IsStopped && ~obj.canRecover
                    obj.recoverSystem();  % Trigger recovery process
                end
                
                pause(0.1);  % Short pause to prevent busy-waiting and allow other processes
            end
        end

        % Read the button state (returns 1 if pressed, 0 otherwise)
        function state = readButton(obj)
            state = readDigitalPin(obj.arduinoObj, obj.buttonPin);
        end

        % Activate E-stop, halting operations and preventing recovery until conditions are met
        function activateEStop(obj)
            disp('E-STOP ACTIVATED! Halting all operations...');
            obj.stopRobot();          % Call to stop robot operations
            obj.IsStopped = true;     % Set E-stop status to active
            obj.canRecover = false;   % Disallow recovery initially
            obj.waitForButtonRelease();  % Wait for button to be released to proceed
            disp('E-stop disengaged. Press button again to resume.');
        end

        % Recover from E-stop if conditions are met
        function recoverSystem(obj)
            obj.waitForButtonRelease();  % Wait until button is released
            disp('Resuming operations...');
            obj.resumeRobot();        % Resume robot operations
            obj.IsStopped = false;    % Reset E-stop status to inactive
            obj.canRecover = true;    % Allow recovery mode
        end

        % Wait until the button is released to prevent accidental reactivation
        function waitForButtonRelease(obj)
            while obj.readButton() == 1  % Loop until button is released
                pause(0.05);  % Small delay to prevent busy-waiting
            end
        end

        % Placeholder method to stop the robot (e.g., shutting down motors)
        function stopRobot(obj)
            disp('Robot stopped successfully.');
        end

        % Placeholder method to resume robot operations
        function resumeRobot(obj)
            disp('Robot resumed successfully.');
        end
    end
end
