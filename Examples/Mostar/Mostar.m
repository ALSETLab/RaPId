
%% ==========Reference data settings==========

% Create a rapidSettings (optional but recommended - will work with just a structure)
rapidSettings=RaPIdClass();

%Output data
rapidSettings.experimentData.pathToReferenceData = 'dataMeasuredO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 'time'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = '';

%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 18.005; %Simulation length
rapidSettings.experimentSettings.ts = 0.0048; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 0; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 100; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode23'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'parallel'; %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 5; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'mostar1.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'mostar1.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'mostar1'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'mostar1/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';

%Estimation parameter settings
rapidSettings.experimentSettings.p_0 = [500 0.00225 4 0.055 0.595 0.055;
                                        50 0.0025 6.5 0.01 0.595 0.056;
                                        50 0.0025 9.01 0.055 0.595 0.055;
                                        100 0.00186 9.01 0.05 0.595 0.055;
                                        100,0.004,10,0.1,1,0.1;
                                        250,0.0005,5,0.001,0.5,0.02;
                                        300,0.00015,5.24,0.008,0.75,0.08];
%rapidSettings.experimentSettings.p_0 = [500,0.004,10,0.1,1,0.1]; %Initial parameter guess
rapidSettings.experimentSettings.p_min = [1,1e-4,1,1e-4,0.1,1e-4]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [1000,0.004,10,0.1,1,0.1]; %Maximum values of parameters

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
    case 'parallel'
        rapidSettings.parallelSettings = 'optimset(''UseParallel'',false)';
end

%% ==========FMU parameters, inputs and outputs==========

rapidSettings.parameterNames = {'sT5B.K_R','sT5B.T_1','sT5B.T_B1','sT5B.T_B2','sT5B.T_C1','sT5B.T_C2'};
rapidSettings.fmuInputNames = {};
rapidSettings.fmuOutputNames = {'gENSAL.P','gENSAL.Q','gENSAL.EFD','gENSAL.ETERM'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
open_system(rapidSettings.experimentSettings.pathToSimulinkModel); %Opening the simulink model
open_system(strcat(rapidSettings.experimentSettings.modelName,'/P')); %Opening the scope in the model to observe estimation process
open_system(strcat(rapidSettings.experimentSettings.modelName,'/Q'));
pause(1); %Waiting one second for scope to initialize
%%
% Create the object which carries out the work
rapidObject=Rapid(rapidSettings);
%Starting the estimation process
[sol, hist] = rapidObject.runIdentification();
sprintf('Vector of estimated parameters is: %s',mat2str(sol,3)) 


