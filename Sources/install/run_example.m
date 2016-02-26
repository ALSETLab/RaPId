%Script to run SecondOrder example during initialization


%% ==========Moving to the example folder==========

str = '../../Examples/SecondOrder';
cd(str);

%% ==========Reference data settings==========

%Output data
RaPIdObject.experimentData.pathToReferenceData = 'measuredDataO.mat'; %Data file name
RaPIdObject.experimentData.expressionReferenceTime = 'time'; %Time variable name
RaPIdObject.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
RaPIdObject.experimentData.pathToInData = '';

%% ==========Experiment settings==========

%General settings 
RaPIdObject.experimentSettings.tf = 50; %Simulation length
RaPIdObject.experimentSettings.ts = 0.01; %Sampling time
RaPIdObject.experimentSettings.t_fitness_start = 4; %Start calculating fintess function after t_fintess_start
RaPIdObject.experimentSettings.timeOut = 2; %Seconds before simulation timeout
RaPIdObject.experimentSettings.integrationMethod = 'ode45'; %Solver selection
RaPIdObject.experimentSettings.solverMode = 'Simulink';
RaPIdObject.experimentSettings.optimizationAlgorithm = 'pso'; %Selection of optimization algorithm
RaPIdObject.experimentSettings.maxIterations = 1; %Maximum number of estimation iterations
RaPIdObject.experimentSettings.verbose = 1; %Can trigger more data for debugging
RaPIdObject.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
RaPIdObject.experimentSettings.pathToSimulinkModel = 'variable_rafael.mdl'; %Simulink model file name
RaPIdObject.experimentSettings.pathToFMUModel = 'Rafael_0original_0estimated.fmu'; %FMU file name
RaPIdObject.experimentSettings.modelName = 'variable_rafael'; %Simulink model name
RaPIdObject.experimentSettings.blockName = 'variable_rafael/Rafael_original_estimated'; %FMU name
RaPIdObject.experimentSettings.scopeName = 'simout'; %Result sink name
RaPIdObject.experimentSettings.displayMode = 'Show';

%Estimation parameter settings
RaPIdObject.experimentSettings.p_0 = [0.3, 4.1, 1.7, 1.1]; %Initial parameter guess
RaPIdObject.experimentSettings.p_min = [0.1, 3.9, 1.5, 1.1]; %Minimum values of parameters
RaPIdObject.experimentSettings.p_max = [1, 4.2, 1.7, 1.5]; %Maximum values of parameters

%Fitness function settings
RaPIdObject.experimentSettings.cost_type = 1; %Fitness function selection
RaPIdObject.experimentSettings.objective_weights = 1; %Weights of the output signals for fitness function

%% ==========Optimization Algorithm settings==========

switch RaPIdObject.experimentSettings.optimizationAlgorithm
    case 'pso'
        RaPIdObject.psoSettings.w = 0.25; %Particle inertia weight
        RaPIdObject.psoSettings.self_coeff = 0.25; %Self recognition coefficient
        RaPIdObject.psoSettings.social_coeff = 0.25; %Social coefficient
        RaPIdObject.psoSettings.limit = 0.25; %Iteration limit
        RaPIdObject.psoSettings.nRandMin = 8; %Minimum number of random particles 
        RaPIdObject.psoSettings.nb_particles = 8; %Number of particles
        RaPIdObject.psoSettings.fitnessStopRatio = 1e-5; %Fitness stop ratio
        RaPIdObject.psoSettings.kick_multiplier = 0.002; %Kick multiplier
        RaPIdObject.psoSettings.method = 'PSO';
end

%% ==========FMU parameters, inputs and outputs==========

RaPIdObject.parameterNames = {'transferFunction.b[1]','transferFunction.a[1]','transferFunction.a[2]','transferFunction.a[3]'};
RaPIdObject.fmuInputNames = {};
RaPIdObject.fmuOutputNames = {'y1'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
open_system(RaPIdObject.experimentSettings.pathToSimulinkModel); %Opening the simulink model
open_system(strcat(RaPIdObject.experimentSettings.modelName,'/Scope')); %Opening the scope in the model to observe estimation process
pause(1); %Waiting one second for scope to initialize
%%

%Starting the estimation process
[sol, hist] = rapid(RaPIdObject);
cd('../../Sources');
if isempty(sol) 
    warning('Test example failed!');
else
    disp(strcat('Vector of estimated parameters is: ', mat2str(sol,3)));
    disp('======= Test example succeeded! =======');
end
clear RaPIdObject sol hist str dataMeasuredS
