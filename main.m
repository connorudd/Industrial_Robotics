classdef main
    methods(Static)
        function plotEnvironment()
            % Create an instance of the Environment class
            env = environment(); % Create the environment instance
            
            % Plot the environment with the robots
            env.plotEnvironment(); % Call the method to plot the environment
        end
    end
end




