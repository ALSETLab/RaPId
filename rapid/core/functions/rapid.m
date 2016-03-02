function [sol,historic,rapidObject] = rapid(rapidObject)
%RAPID carries out the parameter identification in the RaPId Toolbox.
% the settings struct must contain the fields:
%   [SOL, HISTORIC,RAPIDOBJECT] = RAPID(RAPIDOBJECT) returns a vector SOL of the identified parameters,
%   and a struct HIS containg the history of the parameter identification, given the settings specified in RAPIDOBJECT which is
%   an instance of the RaPIdClass (or a struct in legacy-mode).
% See also: RUNRAPIDGUI, RAPIDCLASS
%
% Examples: see Examples-folder.

% Copyright 2015-2016 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
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
% along with RaPId. If not, see <a href="matlab:web('http://www.gnu.org/licenses/')">
% http://www.gnu.org/licenses/</a>.

%% Check and set the in-data to the model
finishup = onCleanup(@(x)cleanFunc);
if ~isempty(rapidObject.experimentData.pathToInData)  
    if exist(rapidObject.experimentData.pathToInData,'file') % Indata exist on absolute path
            load(rapidObject.experimentData.pathToInData);
    elseif exist(fullfile(evalin('base','pwd'),rapidObject.experimentData.pathToInData),'file') %File exist on relative path
            load(fullfile(evalin('base','pwd'),rapidObject.experimentData.pathToInData));
    else
            error('In-data file could not be found! Use an empty string if no in-data should be loaded!')
    end
    
    try
        timeInputT = eval(rapidObject.experimentData.expressionInDataTime);
        inputT = eval(rapidObject.experimentData.expressionInData);
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
        rapidObject.experimentData.IndataMatrix=inputSignalS;
        assignin('base','inputSignalS',inputSignalS)
    catch err
        disp(err.message);
    end
end

%% Check and set the reference data which will be used for fitness-calculation
if ~isempty(rapidObject.experimentData.pathToReferenceData)
    if exist(rapidObject.experimentData.pathToReferenceData,'file') % Reference data file exist on absolute path
        load(rapidObject.experimentData.pathToReferenceData);
    elseif exist(fullfile(evalin('base','pwd'),rapidObject.experimentData.pathToReferenceData),'file') %Reference data file exist on relative path
        load(fullfile(evalin('base','pwd'),rapidObject.experimentData.pathToReferenceData));
    else
        error('No reference file could be found!')
    end
    try
        load(rapidObject.experimentData.pathToReferenceData);
        timeOutputT=eval(rapidObject.experimentData.expressionReferenceTime);
        outputT=eval(rapidObject.experimentData.expressionReferenceData);
        if isrow(timeOutputT) % make it column data
            timeOutputT=transpose(timeOutputT);
        end
        if length(timeOutputT) == size(outputT,1) %if outputTsquare: OK - provided that data channel iscol
            % NOP
        elseif  length(timeOutputT) == size(outputT,2) % need to transpose
            outputT=transpose(outputT);
        else
            error('Check consistency of output data.'); %Something is bad with the data
        end
        [timeOutputT, i_t]=unique(timeOutputT); % remove double time-stamps
        outputT = outputT(i_t,:);
        dataMeasuredS = [timeOutputT,outputT];
        rapidObject.experimentData.referenceTime=dataMeasuredS(:,1);
        rapidObject.experimentData.referenceOutdata=dataMeasuredS(:,2:end);
        assignin('base','dataMeasuredS',dataMeasuredS)
    catch err
        disp(err.message);
    end
    
end

%% Load FMU in either Simulink or in Matlab depending on preferred method
switch rapidObject.experimentSettings.solverMode
    case 'Simulink'
        tmp=[];
        if exist(rapidObject.experimentSettings.pathToSimulinkModel,'file')
            tmp=rapidObject.experimentSettings.pathToSimulinkModel;
        elseif ~exist(rapidObject.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel),'file')
            tmp=fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToSimulinkModel);
        end
        if strcmpi(rapidObject.experimentSettings.displayMode, 'hide') 
            if strcmp(gcs,rapidObject.experimentSettings.blockName) % check if model already loaded
                tmp_name=tempfile;
                close_system(gcs, fullfile(pwd,tmp_name)) % save it as back-up
                disp(strcat('Saved opened Simulink model to', fullfile(pwd,tmp_name)))
            end
            load_system(tmp);
        elseif strcmp(rapidObject.experimentSettings.displayMode, 'show') && strcmp(gcs,rapidObject.experimentSettings.blockName) % check if model already loaded
            %NOP, do nothing
        else
            open_system(tmp); 
        end
          
    case 'ODE'
        try
            if exist(rapidObject.experimentSettings.pathToFmuModel,'file') % FMU exist on absolute path
                fmu = FMUModelME1(rapidObject.experimentSettings.pathToFmuModel,'Loglevel','warning'); % or change to loadFMU?
            elseif ~exist(rapidObject.experimentSettings.pathToFmuModel,'file') && exist(fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToFmuModel),'file') %FMU exist on relative path
                fmu = FMUModelME1(fullfile(evalin('base','pwd'),rapidObject.experimentSettings.pathToFmuModel),'Loglevel','warning'); % or change to loadFMU?
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
if ~isfield(rapidObject.experimentSettings,'outputPostProcessing')
    rapidObject.experimentSettings.outputPostProcessing=@(x)x; % create default function which does nothing
end
    
if isrow(rapidObject.experimentSettings.objective_weights) % should not be row
    rapidObject.experimentSettings.objective_weights=transpose(rapidObject.experimentSettings.objective_weights);
end

%% Selecting the chosen opimtization method
switch lower(rapidObject.experimentSettings.optimizationAlgorithm) % use lower case
    case 'pso'
        [sol, historic] = pso_algo(rapidObject);
    case 'ga'
        [ sol, historic] = ga_algo(rapidObject);
    case 'naive'
        sol = naive_algo(rapidObject);
        historic = [];
    case 'cg'
        [ sol, historic] = cg_algo(rapidObject);
    case 'nm'
        [ sol, historic ] = nm_algo(rapidObject);
    case 'combi'
        rapidObject.experimentSettings.methodName = rapidObject.combiSettings.firstMethod;
        [sol1,historic1] = rapid( rapidObject);
        rapidObject.experimentSettings.methodName = rapidObject.combiSettings.secondMetod;
        rapidObject.experimentSettings.p_0 = sol1;
        [sol,historic2] = rapid(rapidObject);
        historic.sol1 = sol1;
        historic.historic1 = historic1;
        historic.historic2 = historic2;
    case 'psoext'
        [ sol, historic] = psoExt_algo(rapidObject);
    case 'gaext'
        [ sol, historic] = gaExt_algo(rapidObject);
    case 'knitro'
        [ sol, historic] = knitro_algo(rapidObject);
    case 'fmincon'
        [ sol, historic] = fmincon_algo(rapidObject);
    case 'pfnew'
        [ sol, historic] = pf_algo(rapidObject);
    otherwise
        errorWrongMethodName
end

%% Cleaning up after the optimization
switch rapidObject.experimentSettings.solverMode
    case 'Simulink'
        switch lower(rapidObject.experimentSettings.displayMode)
            case {'show'}
                % NOP
            otherwise
                close_system(rapidObject.experimentSettings.modelName,0)   
        end
    case 'ODE'
        if exist('fmu','var') 
            if fmu.isInstantiated
                fmu.fmiFreeModelInstance;
            end
            delete(fmu)
            clearvars fmu
        end
        clear rapid_ODEsolve
end
disp(sol)

end
function cleanFunc(varargin)
clear rapid_ODEsolve rapid_simuSystem  % clean up the persistent variable in this function.
tm=timerfind('Tag', 'ODEtimeout');
if ~isempty(tm)
    stop(tm)
    delete(tm);
end
end