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
rapidSettings.experimentData.pathToInData = 'inputDataO.mat';
rapidSettings.experimentData.expressionInDataTime = 'time1'; %Time variable name
rapidSettings.experimentData.expressionInData = 'signal1'; %Data variable name
%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 20; %Simulation length
rapidSettings.experimentSettings.ts = 0.04; %Sampling time
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
rapidSettings.experimentSettings.pathToFMUModel = 'aggregated_system.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'sim_model'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'sim_model/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';

%Estimation parameter settings
rapidSettings.experimentSettings.p_0 = [1.84, 4.28, 0.0001, 1.75, 0.41]; %Initial parameter guess
rapidSettings.experimentSettings.p_min = [0.0001, 0.1, 0.000005, 0.1, 0.1]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [2, 5, 0.5, 2,2]; %Maximum values of parameters

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

rapidSettings.parameterNames = {'gENROE.Xd','gENROE.H','gENROE.R_a','gENROE.Xq','gENROE.Xpd'};
rapidSettings.fmuInputNames = {'pref_disturb'};
rapidSettings.fmuOutputNames = {'gENROE.P','gENROE.Q','gENROE.ETERM'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
open_system(rapidSettings.experimentSettings.pathToSimulinkModel); %Opening the simulink model
open_system(strcat(rapidSettings.experimentSettings.modelName,'/P')); %Opening the scope in the model to observe estimation process
open_system(strcat(rapidSettings.experimentSettings.modelName,'/Q')); %Opening the scope in the model to observe estimation process
open_system(strcat(rapidSettings.experimentSettings.modelName,'/ETERM')); %Opening the scope in the model to observe estimation process
pause(1); %Waiting one second for scope to initialize
%%
% Create the object which carries out the work
rapidObject=Rapid(rapidSettings);
%Starting the estimation process
[sol, hist] = rapidObject.runIdentification();
sprintf('Vector of estimated parameters is: %s',mat2str(sol,3)) 
%Restoring workspace
cd(oldFolder);

