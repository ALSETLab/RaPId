%% ==========Moving to the example folder==========


[str,~,~] = fileparts(mfilename('fullpath'));
oldFolder=cd(str);

%% ==========Reference data settings==========

% Create a rapidSettings (optional but recommended - will work with just a structure)
rapidSettings=RaPIdClass();

%Output data
rapidSettings.experimentData.pathToReferenceData = 'measuredDataO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 'time'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = '';

%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 60; %Simulation length
rapidSettings.experimentSettings.ts = 0.12; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 0; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 2; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode45'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'pso'; %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 5; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'sim_model.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'CauerLowPassAnalog.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'sim_model'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'sim_model/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';

%Estimation parameter settings
rapidSettings.experimentSettings.p_0 = [0.3, 0.001, 1.7, 1.1, 1]; %Initial parameter guess
rapidSettings.experimentSettings.p_min = [0.0001, 0.000019, 1.5, 0, 0]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [2, 4.2, 1.7, 1.5,2]; %Maximum values of parameters

%Fitness function settings
rapidSettings.experimentSettings.cost_type = 1; %Fitness function selection
rapidSettings.experimentSettings.objective_weights = 1; %Weights of the output signals for fitness function

%% ==========Optimization Algorithm settings==========

switch lower(rapidSettings.experimentSettings.optimizationAlgorithm) % use lower to add robustness
    case 'pso'
        rapidSettings.psoSettings.w = 0.25; %Particle inertia weight
        rapidSettings.psoSettings.self_coeff = 0.25; %Self recognition coefficient
        rapidSettings.psoSettings.social_coeff = 0.25; %Social coefficient
        rapidSettings.psoSettings.limit = 0.25; %Iteration limit
        rapidSettings.psoSettings.nRandMin = 8; %Minimum number of random particles 
        rapidSettings.psoSettings.nb_particles = 8; %Number of particles
        rapidSettings.psoSettings.fitnessStopRatio = 1e-2; %Fitness stop ratio
        rapidSettings.psoSettings.kick_multiplier = 0.002; %Kick multiplier
        rapidSettings.psoSettings.method = 'PSO';
end

%% ==========FMU parameters, inputs and outputs==========

rapidSettings.parameterNames = {'c1','c3','c5','l1','l2'};
rapidSettings.fmuInputNames = {};
rapidSettings.fmuOutputNames = {'R1.v'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
open_system(rapidSettings.experimentSettings.pathToSimulinkModel); %Opening the simulink model
open_system(strcat(rapidSettings.experimentSettings.modelName,'/Scope')); %Opening the scope in the model to observe estimation process
pause(1); %Waiting one second for scope to initialize
%%
% Create the object which carries out the work
rapidObject=Rapid(rapidSettings);
%Starting the estimation process
[sol, hist] = rapidObject.runIdentification();
sprintf('Vector of estimated parameters is: %s',mat2str(sol,3)) 
%Restoring workspace
cd(oldFolder);

