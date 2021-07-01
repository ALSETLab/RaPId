
%% ==========Reference data settings==========

% Create a rapidSettings (optional but recommended - will work with just a structure)
rapidSettings=RaPIdClass();

%Output data
rapidSettings.experimentData.pathToReferenceData = 'noiseMeasuredO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 'time'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = '';

%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 18; %Simulation length
rapidSettings.experimentSettings.ts = 0.005; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 0; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 10000; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode23'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'pso'; %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 20; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'mostar_noise.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'fmu_noise.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'mostar_noise'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'mostar_noise/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';

%Estimation parameter settings
rapidSettings.experimentSettings.p_0 = [500 0.00225 4 0.055 0.595 0.055];
%rapidSettings.experimentSettings.p_0 = [500,0.004,10,0.1,1,0.1]; %Initial parameter guess
rapidSettings.experimentSettings.p_min = [1,1e-4,1,1e-4,0.1,1e-4]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [1000,0.004,10,0.1,1,0.1]; %Maximum values of parameters

%Fitness function settings
rapidSettings.experimentSettings.cost_typPe = 1; %Fitness function selection
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
        rapidSettings.parallelSettings.parallel = 'optimset(''UseParallel'',false)';
   case 'fmincon'
       rapidSettings.fminconSettings = 'optimset(''FinDiffRelStep'',0.1,''UseParallel'',false)';

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
startTime = tic;
rapidObject=Rapid(rapidSettings);
%Starting the estimation process
[sol, hist] = rapidObject.runIdentification();
sprintf('Vector of estimated parameters is: %s',mat2str(sol,3)) 
fmincon_time = toc(startTime);


%%
results = simout.signals.values;
plot(time, results(:,1), dataMeasuredS(:,1), dataMeasuredS(:,2),'LineWidth',5);xlabel('Time(s)');ylabel('Active Power (p.u.)');legend('Simulation','Measurements');
figure;
plot(time, results(:,2), dataMeasuredS(:,1), dataMeasuredS(:,3),'LineWidth',5);xlabel('Time(s)');ylabel('Reactive Power (p.u.)');legend('Simulation','Measurements');
figure;
plot(time, results(:,3), dataMeasuredS(:,1), dataMeasuredS(:,4),'LineWidth',5);xlabel('Time(s)');ylabel('Field voltage, Efd (p.u.)');legend('Simulation','Measurements');
figure;
plot(time, results(:,4), dataMeasuredS(:,1), dataMeasuredS(:,5),'LineWidth',5);xlabel('Time(s)');ylabel('Terminal Voltage, Vt (p.u.)');legend('Simulation','Measurements');

figure;plot(time, results(:,2))
