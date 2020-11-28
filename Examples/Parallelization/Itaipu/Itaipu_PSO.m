%% ==========Reference data settings==========

% Create a rapidSettings (optional but recommended - will work with just a structure)
rapidSettings=RaPIdClass();

%Output data
rapidSettings.experimentData.pathToReferenceData = 'dataMeasuredO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 'time'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'signal'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = 'dataIn.mat';
rapidSettings.experimentData.expressionInDataTime = 'time_in'; %Time variable name
rapidSettings.experimentData.expressionInData = 'signal_in'; %Data variable name
%% ==========Experiment settings==========
%General settings 
rapidSettings.experimentSettings.tf = 280/60; %Simulation length
rapidSettings.experimentSettings.ts = 1/60; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 1; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 500; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode23'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'pso'; % %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 1000; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history

%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'Itaipu_all.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'all.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'Itaipu_all'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'Itaipu_all/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';


%Estimation parameter settings

p_0 = [1.1303    0.0172    2.2498    0.8250    0.7679    1.6109    0.2682    1.0306    2.7823    3.2669    3.5759   27.8264     0.0369      183.214    3.6135   66.2106    83.4535  20.0313];
p_min = [0.6,0.00001,0.1,0.1,0.01,0.1,0.1,0.1,1,0.1,0.1,0.1,1e-3,10,0.1,0.1,0.1,0.1];
p_max =[2,0.5,5,2,1,2,1,2,15,15,15,50,0.1,1000,10,100,100,100];
% p_0 = [1.5730    0.0649    2.7797    1.7183    0.8672    1.7050    0.2663    1.8066    4.6417    2.7965    2.5882        ...
%        0.9406    6.2148    5.5846    1.2391   -0.4653   -0.5058    1.5750    1.1611    0.5320    0.5145    0.4544       ...
%        1.0464    1.1343    2.5237    8.0406    0.0532  430.4151    0.5193    1.9168    1.6311...
%        1.1301   13.1542   10.1130    8.1972    8.0612    0.0747    3.2342   17.1505 ...
%       0.0056   1          1        -0.15        1       -0.17       0.85    0.05    1   0.04 ...
%       0.4       3         1.16      1.7       0.6];
% p_min = [0.6,0.00001,1,0.1,0.01,0.1,0.1,0.1,1,0.1,0.1,...
%          0,2,1,0.01,-1,-1,0.1,0.01,0.01,0,0,...
%          0.1,0.1,0.1,0.1,0,1,0,1,1,...
%          0.1,0.1,1,1,1,0.001,0.1,15,...
%          0,0.1,0.1,-0.5,0.1,-0.5,0.1,0,0.1,0,...
%          0.1,0.1,0.1,0.1,0.1];%Minimum values of parameters
% p_max =[2,0.5,5,2,1,2,1,2,5,5,5,...
%         10,10,10,1.5,0,0,3,2,1,1,1,...
%         2,2,5,15,0.1,500,1,3,3,...
%         2,20,20,20,25,0.1,5,20,...
%         0.1,2,2,0,2,0,2,0.1,2,0.1,...
%         1,5,2,2,2];%Maximum values of parameters
x=18;
rapidSettings.experimentSettings.p_0 = p_0(:,1:x);
rapidSettings.experimentSettings.p_min = p_min(1:x);
rapidSettings.experimentSettings.p_max = p_max(1:x);

%Fitness function settings
rapidSettings.experimentSettings.cost_type = 1; %Fitness function selection
rapidSettings.experimentSettings.objective_weights = [1,1,1]; %Weights of the output signals for fitness function

%% ==========Optimization Algorithm settings==========
switch lower(rapidSettings.experimentSettings.optimizationAlgorithm) % use lower to add robustness
    case 'pso'
        rapidSettings.psoSettings.w = 0.25; %Particle inertia weight
        rapidSettings.psoSettings.self_coeff = 0.25; %Self recognition coefficient
        rapidSettings.psoSettings.social_coeff = 0.25; %Social coefficient
        rapidSettings.psoSettings.limit = 0.25; %Iteration limit
        rapidSettings.psoSettings.nRandMin = 25; %Minimum number of random particles 
        rapidSettings.psoSettings.nb_particles = 50; %Number of particles
        rapidSettings.psoSettings.fitnessStopRatio = 1e-2; %Fitness stop ratio
        rapidSettings.psoSettings.kick_multiplier = 0.002; %Kick multiplier
        rapidSettings.psoSettings.method = 'PSO';
    case 'parallel'
        rapidSettings.parallelSettings.parallel = 'optimset(''UseParallel'',false)';
    case 'fmincon'
       rapidSettings.fminconSettings = 'optimset(''FinDiffRelStep'',0.1)';
end


%% ==========FMU parameters, inputs and outputs==========
 parameters = {'machineData.Gen1.Xd','machineData.Gen1.R_a','machineData.Gen1.H','machineData.Gen1.Xpd','machineData.Gen1.D','machineData.Gen1.Xq','machineData.Gen1.Xppd','machineData.Gen1.Xppq','machineData.Gen1.Tpd0','machineData.Gen1.Tppd0','machineData.Gen1.Tppq0'...
               'machineData.Gen1.T_AT_B','machineData.Gen1.T_B','machineData.Gen1.K','machineData.Gen1.T_E',...
               'machineData.Gen1.T_t','machineData.Gen1.T_X1','machineData.Gen1.T_X2'};
% parameters = {'machineData.Gen1.Xd','machineData.Gen1.R_a','machineData.Gen1.H','machineData.Gen1.Xpd','machineData.Gen1.D','machineData.Gen1.Xq','machineData.Gen1.Xppd','machineData.Gen1.Xppq','machineData.Gen1.Tpd0','machineData.Gen1.Tppd0','machineData.Gen1.Tppq0',...
%               'machineData.Gen1.K_v','machineData.Gen1.K_ei','machineData.Gen1.Kmin','machineData.Gen1.K_point','machineData.Gen1.K1_AVR','machineData.Gen1.Ti','machineData.Gen1.T_a','machineData.Gen1.T_b','machineData.Gen1.Tai','machineData.Gen1.T1_AVR','machineData.Gen1.T2_AVR',...
%               'machineData.Gen1.Kf','machineData.Gen1.Kf1','machineData.Gen1.Kp','machineData.Gen1.K1_PSS','machineData.Gen1.T1_PSS','machineData.Gen1.K2','machineData.Gen1.T2_PSS','machineData.Gen1.Tf','machineData.Gen1.Tp',...
%               'machineData.Gen1.Tn','machineData.Gen1.NTv','machineData.Gen1.Td','machineData.Gen1.Tf1','machineData.Gen1.Tf2','machineData.Gen1.Tv','machineData.Gen1.Tw','machineData.Gen1.Tya',...
%               'machineData.Gen1.str2_m','machineData.Gen1.str2_b','machineData.Gen1.str3_m','machineData.Gen1.str3_b','machineData.Gen1.str4_m','machineData.Gen1.str4_b','machineData.Gen1.str5_m','machineData.Gen1.str5_b','machineData.Gen1.str6_m','machineData.Gen1.str6_b',...
%               'machineData.Gen1.g4','machineData.Gen1.g8','machineData.Gen1.g14','machineData.Gen1.g15','machineData.Gen1.g16'};
rapidSettings.parameterNames = parameters(1:x);
rapidSettings.fmuInputNames = {'vim','vr'};
rapidSettings.fmuOutputNames = {'Pout','Qout'}; %Output variable names

%% ==========Running the computation==========

%Opening simulink model
open_system(rapidSettings.experimentSettings.pathToSimulinkModel); %Opening the simulink model
%open_system(strcat(rapidSettings.experimentSettings.modelName,'/ETERM')); %Opening the scope in the model to observe estimation process
%open_system(strcat(rapidSettings.experimentSettings.modelName,'/P')); %Opening the scope in the model to observe estimation process
%open_system(strcat(rapidSettings.experimentSettings.modelName,'/Q')); %Opening the scope in the model to observe estimation process

pause(1); %Waiting one second for scope to initialize
%%
% Create the object which carries out the work
startTime = tic;
rapidObject=Rapid(rapidSettings);
%Starting the estimation process
[sol, hist] = rapidObject.runIdentification();
PSO_time = toc(startTime);
sprintf('Vector of estimated parameters is: %s',mat2str(sol,3)) 

      
             


