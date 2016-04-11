%Script to run SecondOrder example during initialization


%% ==========Moving to the example folder==========

str = '../../Examples/SecondOrder';
oldFolder = cd(str);

%% ==========Initializing a RaPId Object======
% Construct the Settings object
rapidSettings=RaPIdClass();
%% ==========Reference data settings==========
%Output data
rapidSettings.experimentData.pathToReferenceData = 'measuredDataO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 'time'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = '';

%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 50; %Simulation length
rapidSettings.experimentSettings.ts = 0.01; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 4; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 2; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode45'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'pso'; %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 1; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'variable_rafael.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'Rafael_0original_0estimated.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'variable_rafael'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'variable_rafael/Rafael_original_estimated'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'hide';

%Estimation parameter settings
rapidSettings.experimentSettings.p_0 = [0.3, 4.1, 1.7, 1.1]; %Initial parameter guess
rapidSettings.experimentSettings.p_min = [0.1, 3.9, 1.5, 1.1]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [1, 4.2, 1.7, 1.5]; %Maximum values of parameters

%Fitness function settings
rapidSettings.experimentSettings.cost_type = 1; %Fitness function selection
rapidSettings.experimentSettings.objective_weights = 1; %Weights of the output signals for fitness function

%% ==========Optimization Algorithm settings==========

switch lower(rapidSettings.experimentSettings.optimizationAlgorithm) %use lower case
    case 'pso'
        rapidSettings.psoSettings.w = 0.25; %Particle inertia weight
        rapidSettings.psoSettings.self_coeff = 0.25; %Self recognition coefficient
        rapidSettings.psoSettings.social_coeff = 0.25; %Social coefficient
        rapidSettings.psoSettings.limit = 0.25; %Iteration limit
        rapidSettings.psoSettings.nRandMin = 8; %Minimum number of random particles 
        rapidSettings.psoSettings.nb_particles = 8; %Number of particles
        rapidSettings.psoSettings.fitnessStopRatio = 1e-5; %Fitness stop ratio
        rapidSettings.psoSettings.kick_multiplier = 0.002; %Kick multiplier
        rapidSettings.psoSettings.method = 'PSO';
end

%% ==========FMU parameters, inputs and outputs==========

rapidSettings.parameterNames = {'transferFunction.b[1]','transferFunction.a[1]','transferFunction.a[2]','transferFunction.a[3]'};
rapidSettings.fmuInputNames = {};
rapidSettings.fmuOutputNames = {'y1'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
% open_system(rapidSettings.experimentSettings.pathToSimulinkModel); %Opening the simulink model
% open_system(strcat(rapidSettings.experimentSettings.modelName,'/Scope')); %Opening the scope in the model to observe estimation process
% pause(1); %Waiting one second for scope to initialize
%% 
% Construct the object which carries out the RaPId tasks
rapidObject=Rapid(rapidSettings);

%Starting the estimation process

[sol, hist] = rapidObject.runIdentification;
cd(oldFolder);
if isempty(sol) 
    warning('Test example failed!');
else
    disp(strcat('Vector of estimated parameters is: ', mat2str(sol,3)));
    disp('======= Test example succeeded! =======');
end
clear rapidSettings rapidObject sol hist str dataMeasuredS
