%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
% Copyright 2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
% Tetiana Bogodorova, Jan Lavenius, Tin Rabuzin, Giuseppe Laera, 
% Francisco Gomez-Lopez
% 
% The authors can be contacted by email: luigiv at kth dot se
% 
% This file is part of Rapid Parameter Identification ("RaPId") .
% 
% RaPId is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RaPId is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public License
% along with RaPId.  If not, see <http://www.gnu.org/licenses/>.

function [ sol, historic,RaPIdObject] = rapid(RaPIdObject)
%RAPID main function of the rapid toolbox RaPId
% the settings struct must contain the fields:
%       - realData: vector of measured output data used in the system identification
%       - realTime: vector of time instant corresponding to the measurements in
%       realData
%       - modelName: string, name of the simulink model used for
%         simulation, this model should include a FMU ME block loaded with
%         the appropriate *.fmu file and configured with the appropriate
%         outputs, and a toworkspace block saving the output data
%       - fmuOutData:  cell of strings containing the names of the measured
%           output configured in the FMU ME block
%       - parameterNames: cell of strings containing the names of the paramet
%           -ers to be identified
%       - scopeName: string containing the name of the struct saving the
%           output data (from toworkspace block)
%       - blockName: string containing the name of the FMU ME block
%       - Ts: sampling time of the system
%       - tf: final time of the simulation
%       - methodName : string containing the name of the identification
%           method used, use 'pso' (particle swarm), 'ga' (genetic algo.),
%           'naive', 'cg' (conjugate gradient), 'nm' (nelder-meade),
%           'combi' (pso+nm)
%       - p0: initial guess for the parameter vector, used by 'fmincon'
%       'nm' and and 'cg' methods,
%       - pso_options: struct to be used if methodName = 'pso' ga_options:
%       struct to be used if methodName = 'ga' naive_options: struct to be
%       used if methodName = 'naive' cg_options: struct to be used if
%       - methodName = 'cg' nm_options: struct to be used if methodName =
%       'nm' gaExtOptions: struct to be used if methodName = 'gaExt'
%       - psoExtOptions: struct to be used if methodName = 'psoExt'
%       - psoExtPath: string leading to the path of the psoopt toolbox to
%       be used if and only if methodName = 'psoExt' kn_options.
%       - kn_options.path2Knitro: string leading to the path of the psoopt
%       toolbox to be used if and only if methodName = 'psoExt'
%       fmincon_options
%       - kn_options.knOptions: struct to be used if methodName = 'knitro'
%       - kn_options.knOptionsFile: string to be used if methodName = 'knitro'
%       - path2data: string containing the path to the measured output data
%       - dataT: string to evaluate once the file pointed at by path2data
%       is loaded in memory to get a row vector containing the time
%       instants at which the outputs were measured
%       - dataY: string to evaluate once the file pointed at by path2data
%       is loaded in memory to get a matrix whose row vectors are the
%       different output signals measured
%       - t0_fitness: time at which the computation of the objective
%       fonction should begin, allows the user to negates the wrong
%       initialisation of the system (for example). Should be smaller than
%       tf...
%       lastSimu: output signals from the last simulation run
%       combi_options.firstMethod: first of two methods to be used one
%       after the other
%       combi_options.firstMethod: second of two methods to be used one
%       after the other
%       p_min: min value for the parameters
%       p_max: max values for the parameters
%       intMethod: string containing the name of an integration method, can
%       be fixed or variable step method
%       path2simulinkModel: path to the simulink model in use
%       cost: int giving the type of cost, for now, 2 is quadratic
%       objective: struct describing the objective function giving the
%           fitness, this object is detailed in rapid_objectiveFunction
%       verbose: integer, for now only two levels, on off
%       %%
%       /!\ fields of settings not to fill in yourself: realData, realTime,
%       lastSimu
%   See the respective algos for few words on the parameters to provide
%   them



%% Check and set the in-data to the model
if ~isempty(RaPIdObject.experimentData.pathToInData)  
    if exist(RaPIdObject.experimentData.pathToInData,'file') % Indata exist on absolute path
            load(RaPIdObject.experimentData.pathToInData);
    elseif exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentData.pathToInData),'file') %File exist on relative path
            load(fullfile(evalin('base','pwd'),RaPIdObject.experimentData.pathToInData));
    else
            error('In-data file could not be found! Use an empty string if no in-data should be loaded!')
    end
    
    try
        timeInputT = eval(RaPIdObject.experimentData.expressionInDataTime);
        inputT = eval(RaPIdObject.experimentData.expressionInData);
        if isrow(timeInputT)
            timeInputT=transpose(timeInputT);
        end
        if length(timeInputT) == size(inputT,1)
            inputSignalS = [timeInputT,inputT];
        elseif  length(timeInputT) == size(inputT,2)
            inputSignalS = [timeInputT,inputT']; 
        else
            error('Check consistency of measured input data.');
        end
        RaPIdObject.experimentData.IndataMatrix=inputSignalS;
        assignin('base','inputSignalS',inputSignalS)
    catch err
        disp(err.message);
    end
end

%% Check and set the reference data which will be used for fitness-calculation
if ~isempty(RaPIdObject.experimentData.pathToReferenceData)
    if exist(RaPIdObject.experimentData.pathToReferenceData,'file') % Reference data file exist on absolute path
        load(RaPIdObject.experimentData.pathToReferenceData);
    elseif exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentData.pathToReferenceData),'file') %Reference data file exist on relative path
        load(fullfile(evalin('base','pwd'),RaPIdObject.experimentData.pathToReferenceData));
    else
        error('No reference file could be found!')
    end
    try
        load(RaPIdObject.experimentData.pathToReferenceData);
        timeOutputT=eval(RaPIdObject.experimentData.expressionReferenceTime);
        outputT=eval(RaPIdObject.experimentData.expressionReferenceData);
        if isrow(timeOutputT)
            timeOutputT=transpose(timeOutputT);
        end
        [timeOutputT, i_t]=unique(timeOutputT); % remove double time-stamps
        outputT = outputT(i_t,:); 
        if length(timeOutputT) == size(outputT,1)
            dataMeasuredS = [timeOutputT,outputT];
        elseif  length(timeOutputT) == size(outputT,2)
            dataMeasuredS = [timeOutputT,transpose(outputT(:,i_t))];
        else
            error('Check consistency of output data.');
        end
        RaPIdObject.experimentData.referenceTime=dataMeasuredS(:,1);
        RaPIdObject.experimentData.referenceOutdata=dataMeasuredS(:,2:end);
        assignin('base','dataMeasuredS',dataMeasuredS)
    catch err
        disp(err.message);
    end
    
end

%% Load FMU in either Simulink or in Matlab depending on preferred method
switch RaPIdObject.experimentSettings.solverMode
    case 'Simulink'
        tmp=[];
        if exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file')
            tmp=RaPIdObject.experimentSettings.pathToSimulinkModel;
        elseif ~exist(RaPIdObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel),'file')
            tmp=fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToSimulinkModel);
        end
        if strcmpi(RaPIdObject.experimentSettings.displayMode, 'hide') 
            if strcmp(gcs,RaPIdObject.experimentSettings.blockName) % check if model already loaded
                tmp_name=tempfile;
                close_system(gcs, fullfile(pwd,tmp_name)) % save it as back-up
                disp(strcat('Saved opened Simulink model to', fullfile(pwd,tmp_name)))
            end
            load_system(tmp);
        elseif strcmp(RaPIdObject.experimentSettings.displayMode, 'show') && strcmp(gcs,RaPIdObject.experimentSettings.blockName) % check if model already loaded
            %NOP, do nothing
        else
            open_system(tmp); 
        end
          
    case 'ODE'
        try
            if exist(RaPIdObject.experimentSettings.pathToFmuModel,'file') % FMU exist on absolute path
                fmu = FMUModelME1(RaPIdObject.experimentSettings.pathToFmuModel,'Loglevel','warning'); % or change to loadFMU?
            elseif ~exist(RaPIdObject.experimentSettings.pathToFmuModel,'file') && exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToFmuModel),'file') %FMU exist on relative path
                fmu = FMUModelME1(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToFmuModel),'Loglevel','warning'); % or change to loadFMU?
            else
                error('FMU file could not be found!')
            end              
        catch err
            if strcmp(err.message,'Failed load the FMU model. See the log for more details')
                error('Failed to load FMU. Check that the FMU is a valid FMI 1.0 Model-Exchange FMU-file')
            else
            disp(err);
            rethrow(err);
            end
        end  
end

%% Check that fitness objective && post-processing function are OK
if ~isfield(RaPIdObject.experimentSettings,'outputPostProcessing')
    RaPIdObject.experimentSettings.outputPostProcessing=@(x)x; % create default function which does nothing
end
    
if isrow(RaPIdObject.experimentSettings.objective_weights) % should not be row
    RaPIdObject.experimentSettings.objective_weights=transpose(RaPIdObject.experimentSettings.objective_weights);
end

%% Selecting the chosen opimtization method
switch RaPIdObject.experimentSettings.optimizationAlgorithm
    case 'pso'
        [sol, historic] = pso_algo(RaPIdObject);
    case 'ga'
        [ sol, historic] = ga_algo(RaPIdObject);
    case 'naive'
        sol = naive_algo(RaPIdObject);
        historic = [];
    case 'cg'
        [ sol, historic] = cg_algo(RaPIdObject);
    case 'nm'
        [ sol, historic ] = nm_algo(RaPIdObject);
    case 'combi'
        RaPIdObject.experimentSettings.methodName = RaPIdObject.combiSettings.firstMethod;
        [sol1,historic1] = rapid( RaPIdObject);
        RaPIdObject.experimentSettings.methodName = RaPIdObject.combiSettings.secondMetod;
        RaPIdObject.experimentSettings.p_0 = sol1;
        [sol,historic2] = rapid(RaPIdObject);
        historic.sol1 = sol1;
        historic.historic1 = historic1;
        historic.historic2 = historic2;
    case 'psoExt'
        [ sol, historic] = psoExt_algo(RaPIdObject);
    case 'gaExt'
        [ sol, historic] = gaExt_algo(RaPIdObject);
    case 'knitro'
        [ sol, historic] = knitro_algo(RaPIdObject);
    case 'fmincon'
        [ sol, historic] = fmincon_algo(RaPIdObject);
    case 'pfNew'
        [ sol, historic] = pf_algo(RaPIdObject);
    otherwise
        errorWrongMethodName
end

%% Cleaning up after the optimization
switch RaPIdObject.experimentSettings.solverMode
    case 'Simulink'
        switch RaPIdObject.experimentSettings.displayMode
            case 'show'
                % NOP
            otherwise
                close_system(RaPIdObject.experimentSettings.modelName,0)   
        end
    case 'ODE'
        if exist('fmu','var') 
            if fmu.isInstantiated
                fmu.fmiFreeModelInstance;
            end
            delete(fmu)
            clearvars fmu
            %RaPIdObject.fmuHandle=[]; -Ravi 
        end
        clear rapid_ODEsolve
end
disp(sol)
finishup = onCleanup(@(x)cleanFunc);

end
function cleanFunc(varargin)
    clear(rapid_ODEsolve)
    delete(timerfind('Tag', 'ODEtimeout'));
end