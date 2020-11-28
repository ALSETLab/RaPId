%% Generate signal
f=1700
Amp=0.240
ts=1/8000;
T=0.05
t=0:ts:T;
y=sin(2*pi*f*t);
save('inputData.mat','t','y')
save('measuredDataO.mat','t','y')
%% 
% This script takes numerous starting point guesses and computes the
% optimal parameter solution in parallel to each other using the MultiStart
% optimization function. It essentially runs fmincon using multiple points
% in parallel to speed up the optimization. This is further explained in
% https://www.mathworks.com/help/gads/example-parallel-multistart.html

%% ==========Moving to the example folder==========


[str,~,~] = fileparts(mfilename('fullpath'));
oldFolder=cd(str);

%% ==========Reference data settings==========

% Create a rapidSettings (optional but recommended - will work with just a structure)
rapidSettings=RaPIdClass();

%Output data
rapidSettings.experimentData.pathToReferenceData = 'measuredDataO.mat'; %Data file name
rapidSettings.experimentData.expressionReferenceTime = 't'; %Time variable name
rapidSettings.experimentData.expressionReferenceData = 'y'; %Data variable name

%Input data
rapidSettings.experimentData.pathToInData = 'inputData.mat';
rapidSettings.experimentData.expressionInDataTime = 't'; %Time variable name
rapidSettings.experimentData.expressionInData = 'y'; %Data variable name

%% ==========Experiment settings==========

%General settings 
rapidSettings.experimentSettings.tf = 0.05; %Simulation length
rapidSettings.experimentSettings.ts = 1/1500; %Sampling time
rapidSettings.experimentSettings.t_fitness_start = 0; %Start calculating fintess function after t_fintess_start
rapidSettings.experimentSettings.timeOut = 100; %Seconds before simulation timeout
rapidSettings.experimentSettings.integrationMethod = 'ode45'; %Solver selection
rapidSettings.experimentSettings.solverMode = 'Simulink';
rapidSettings.experimentSettings.optimizationAlgorithm = 'parallel'; %Selection of optimization algorithm
rapidSettings.experimentSettings.maxIterations = 5; %Maximum number of estimation iterations
rapidSettings.experimentSettings.verbose = 1; %Can trigger more data for debugging
rapidSettings.experimentSettings.saveHist = 0; %Don't save history
rapidSettings.experimentSettings.UseParallel = 1;
%Model related settings
rapidSettings.experimentSettings.pathToSimulinkModel = 'sim_model.mdl'; %Simulink model file name
rapidSettings.experimentSettings.pathToFMUModel = 'Duffing.fmu'; %FMU file name
rapidSettings.experimentSettings.modelName = 'sim_model'; %Simulink model name
rapidSettings.experimentSettings.blockName = 'sim_model/FMUme'; %FMU name
rapidSettings.experimentSettings.scopeName = 'simout'; %Result sink name
rapidSettings.experimentSettings.displayMode = 'Show';

%Estimation parameter settings

% rapidSettings.experimentSettings.p_0 = [19,10000, 10000,10000;
%                                         15, 8000, 80000,8000;
%                                         30, 5000, 5000,5000;
%                                         25, 50000, 10000,10000;
%                                         15, 15000, 10000,10000]; %Initial parameter guesses
% rapidSettings.experimentSettings.p_min = [0.1, 1000, 1000, 1000]; %Minimum values of parameters
% rapidSettings.experimentSettings.p_max = [10000, 20000, 20000, 20000]; %Maximum values of parameters
rapidSettings.experimentSettings.p_0 = [0.3, 0.001, 1.7, 1.1;
                                        0.2, 0.001, 1.5, 1.1;
                                        1, 2, 1.3, 0.5;
                                        1.3, 3, 0.87, 0.45;
                                        1.5, 3.1, 0.9, 0.6]; %Initial parameter guesses
rapidSettings.experimentSettings.p_min = [0.0001, 0.000019, 1.5,0]; %Minimum values of parameters
rapidSettings.experimentSettings.p_max = [20, 4.2, 1.7, 1.5]; %Maximum values of parameters
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
        rapidSettings.psoSettings.f
        itnessStopRatio = 1e-2; %Fitness stop ratio
        rapidSettings.psoSettings.kick_multiplier = 0.002; %Kick multiplier
        rapidSettings.psoSettings.method = 'PSO';
    case 'parallel'
        rapidSettings.parallelSettings.parallel = 'optimset(''UseParallel'',false)';
end

%% ==========FMU parameters, inputs and outputs==========

rapidSettings.parameterNames = {'resistor.R','resistor1.R','resistor2.R','resistor3.R'};
rapidSettings.fmuInputNames = {'signalVoltage.v'};
rapidSettings.fmuOutputNames = {'capacitor.v'}; %Output variable names

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

