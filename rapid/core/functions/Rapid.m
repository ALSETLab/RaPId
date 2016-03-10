classdef Rapid <handle
    %RAPID is a class which carries out the tasks (including the parameter identification) in the RaPId Toolbox.
    %   RAPIDOBJECT = RAPID(RAPIDSETTINGS) creates a new object, see
    %   METHODS for specifications.
    %   Ex. [SOL,HISTORY,RAPIDSETTINGS] = RAPIDOBJECT.runIdentification()
    %   returns a vector SOL of the identified parameters,
    %   and a struct HISTORY containg the history of the parameter identification, given the settings specified in RAPIDSETTINGS which is
    %   an instance of the RaPIdClass (or a struct in legacy-mode). See
    %   METHODS of the RAPID-CLASS by typing methods(Rapid).
    % See also: RUNRAPIDGUI, RAPIDCLASS
    %
    % Examples: see Examples-folder.
    
    % Copyright 2016-2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette,
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
    
    properties (SetAccess = private)
        dataSet=false;
        simulinkLoaded=false;
        fmuLoaded=false;
        hasResults=false;
        rapidSettings=RaPIdClass;
    end
        properties(Access=private)
            hasDataToPlot=false;
            res=[];
    end
    methods
        function obj = Rapid(varargin) %Constructor
            if nargin==1
                if isa(varargin{1},'RaPIdClass') 
                    obj.rapidSettings=RaPIdClass(varargin{1});
                elseif isstruct(varargin{1})
                    obj.rapidSettings=RaPIdClass(varargin{1});
                end
            elseif nargin==0
                obj.rapidSettings=RaPIdClass();
            end
        end
        function obj=loadSettings(obj, rapidSettings)
            obj=Rapid(rapidSettings); % loading new stuff so we cannot be sure everything is ready for runIdentification
        end
        function obj=prepareData(obj)% Check and set the in-data to the model
            if ~isempty(obj.rapidSettings.experimentData.pathToInData)
                if exist(obj.rapidSettings.experimentData.pathToInData,'file') % Indata exist on absolute path
                    load(obj.rapidSettings.experimentData.pathToInData);
                elseif exist(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentData.pathToInData),'file') %File exist on relative path
                    load(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentData.pathToInData));
                else
                    error('In-data file could not be found! Use an empty string if no in-data should be loaded!')
                end
                
                try
                    timeInputT = eval(obj.rapidSettings.experimentData.expressionInDataTime);
                    inputT = eval(obj.rapidSettings.experimentData.expressionInData);
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
                    obj.rapidSettings.experimentData.IndataMatrix=inputSignalS;
                    assignin('base','inputSignalS',inputSignalS)
                    obj.hasData=true;
                catch err
                    disp(err.message);
                end
            end
            
            %% Check and set the reference data which will be used for fitness-calculation
            if ~isempty(obj.rapidSettings.experimentData.pathToReferenceData)
                if exist(obj.rapidSettings.experimentData.pathToReferenceData,'file') % Reference data file exist on absolute path
                    load(obj.rapidSettings.experimentData.pathToReferenceData);
                elseif exist(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentData.pathToReferenceData),'file') %Reference data file exist on relative path
                    load(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentData.pathToReferenceData));
                else
                    error('No reference file could be found!')
                end
                try
                    load(obj.rapidSettings.experimentData.pathToReferenceData);
                    timeOutputT=eval(obj.rapidSettings.experimentData.expressionReferenceTime);
                    outputT=eval(obj.rapidSettings.experimentData.expressionReferenceData);
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
                    obj.rapidSettings.experimentData.referenceTime=dataMeasuredS(:,1);
                    obj.rapidSettings.experimentData.referenceOutdata=dataMeasuredS(:,2:end);
                    assignin('base','dataMeasuredS',dataMeasuredS)
                catch err
                    disp(err.message);
                end
            end
        end
        function prepareSimulation(obj)% Load FMU in either Simulink or in Matlab depending on preferred method
            switch obj.rapidSettings.experimentSettings.solverMode
                case 'Simulink'
                    tmp=[];
                    if exist(obj.rapidSettings.experimentSettings.pathToSimulinkModel,'file')
                        tmp=obj.rapidSettings.experimentSettings.pathToSimulinkModel;
                    elseif ~exist(obj.rapidSettings.experimentSettings.pathToSimulinkModel,'file') && exist(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentSettings.pathToSimulinkModel),'file')
                        tmp=fullfile(evalin('base','pwd'),obj.rapidSettings.experimentSettings.pathToSimulinkModel);
                    end
                    if strcmpi(obj.rapidSettings.experimentSettings.displayMode, 'hide')
                        if strcmp(gcs,obj.rapidSettings.experimentSettings.blockName) % check if model already loaded
                            tmp_name=tempfile;
                            close_system(gcs, fullfile(pwd,tmp_name)) % save it as back-up
                            disp(strcat('Saved opened Simulink model to', fullfile(pwd,tmp_name)))
                        end
                        load_system(tmp);
                    elseif strcmp(obj.rapidSettings.experimentSettings.displayMode, 'show') && strcmp(gcs,obj.rapidSettings.experimentSettings.blockName) % check if model already loaded
                        %NOP, do nothing
                    else
                        open_system(tmp);
                    end
                    obj.simulinkLoaded=true;
                    obj.fmuLoaded=false;
                case 'ODE'
                    try
                        if exist(obj.rapidSettings.experimentSettings.pathToFmuModel,'file') % FMU exist on absolute path
                            fmu = FMUModelME1(obj.rapidSettings.experimentSettings.pathToFmuModel,'Loglevel','warning'); % or change to loadFMU?
                        elseif ~exist(obj.rapidSettings.experimentSettings.pathToFmuModel,'file') && exist(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentSettings.pathToFmuModel),'file') %FMU exist on relative path
                            fmu = FMUModelME1(fullfile(evalin('base','pwd'),obj.rapidSettings.experimentSettings.pathToFmuModel),'Loglevel','warning'); % or change to loadFMU?
                        else
                            error('FMU file could not be found!')
                        end
                        obj.fmuLoaded=true;
                        obj.simulinkLoaded=false;
                    catch err
                        if strcmp(err.message,'Failed load the FMU model. See the log for more details')
                            error('Failed to load FMU. Check that the FMU is a valid FMI 1.0 Model-Exchange FMU-file')
                        else
                            disp(err);
                        end
                    end
            end
            %% Check that fitness objective && post-processing function are OK
            if ~isfield(obj.rapidSettings.experimentSettings,'outputPostProcessing')
                obj.rapidSettings.experimentSettings.outputPostProcessing=@(x)x; % create default function which does nothing
            end
            
            if isrow(obj.rapidSettings.experimentSettings.objective_weights) % should not be row
                obj.rapidSettings.experimentSettings.objective_weights=transpose(obj.rapidSettings.experimentSettings.objective_weights);
            end
        end
        function [sol, historic, rapidSettings]=runIdentification(obj)
            %% Check everything OK, if not fix things up
            if obj.dataSet==false
                obj.prepareData();
            end
            if obj.simulinkLoaded==false && obj.fmuLoaded ==false % this might be a bad practice
                obj.prepareSimulation();
            end
            % Everything should be OK!
            finishup = onCleanup(@(x)cleanFunc(obj.rapidSettings)); %execute on cleanup
            %% Selecting the chosen opimtization method

            switch lower(obj.rapidSettings.experimentSettings.optimizationAlgorithm) % use lower case
                case 'pso'
                    [sol, historic] = pso_algo(obj.rapidSettings);
                case 'ga'
                    [ sol, historic] = ga_algo(obj.rapidSettings);
                case 'naive'
                    sol = naive_algo(obj.rapidSettings);
                    historic = [];
                case 'cg'
                    [ sol, historic] = cg_algo(obj.rapidSettings);
                case 'nm'
                    [ sol, historic ] = nm_algo(obj.rapidSettings);
                case 'combi'
                    obj.rapidSettings.experimentSettings.methodName = obj.rapidSettings.combiSettings.firstMethod;
                    [sol1,historic1] = runIdentification(obj);
                    obj.rapidSettings.experimentSettings.methodName = obj.rapidSettings.combiSettings.secondMetod;
                    obj.rapidSettings.experimentSettings.p_0 = sol1;
                    [sol,historic2] = runIdentification(obj);
                    historic.sol1 = sol1;
                    historic.historic1 = historic1;
                    historic.historic2 = historic2;
                case 'psoext'
                    [ sol, historic] = psoExt_algo(obj.rapidSettings);
                case 'gaext'
                    [ sol, historic] = gaExt_algo(obj.rapidSettings);
                case 'knitro'
                    [ sol, historic] = knitro_algo(obj.rapidSettings);
                case 'fmincon'
                    [ sol, historic] = fmincon_algo(obj.rapidSettings);
                case 'pfnew'
                    [ sol, historic] = pf_algo(obj.rapidSettings);
                otherwise
                    error('Wrong Method name');         
            end
            obj.rapidSettings.resultData.parametersFound=sol;
            obj.hasResults=sol;
            obj.hasDataToPlot=false;
            %% Cleaning up after the optimization
            switch obj.rapidSettings.experimentSettings.solverMode
                case 'Simulink'
                    switch lower(obj.rapidSettings.experimentSettings.displayMode)
                        case {'show'}
                            % NOP
                        otherwise
                            close_system(obj.rapidSettings.experimentSettings.modelName,0)
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
            function cleanFunc(varargin)
                clear rapid_ODEsolve rapid_simuSystem  % clean up the persistent variable in this function.
                tm=timerfind('Tag', 'ODEtimeout');
                if ~isempty(tm)
                    stop(tm)
                    delete(tm);
                end
            end
        end
        function varargout=plotBestTracking(obj,ax, selection)
            if ~obj.hasDataToPlot
                obj.simulateOnce()
            end
            if nargin ==2
                selection=1;
            end
            if nargin==1
                fig=figure; % new figure
                ax=get(fig,'CurrentAxes');
            end
            if nargout==1 % return cell-array of signals in future
                varargout{1}=size(obj.res,2);
            end
            plot(ax,obj.rapidSettings.experimentData.referenceTime,obj.res(:,selection))
            hold on
            plot(ax,obj.rapidSettings.experimentData.referenceTime,obj.rapidSettings.experimentData.referenceOutdata,'r')
            hold off
        end
    end
    methods (Access=private, Hidden=true)
        function simulateOnce(obj)
            if obj.dataSet==false
                obj.prepareData();
            end
            if obj.hasResults 
                params=obj.rapidSettings.resultData.parametersFound;
            else
                params=obj.rapidSettings.experimentSettings.p_0;
                warning('plot using guess values for parameters');
            end
            switch lower(obj.rapidSettings.experimentSettings.solverMode) % use lower case
                case 'simulink'
                    if obj.simulinkLoaded==false && obj.fmuLoaded ==false % this might be a bad practice
                        obj.prepareSimulation();
                    end
                    obj.res = rapid_simuSystem(params,obj.rapidSettings);
                case 'ode'
            end
            if isempty(obj.res)
                error('Failed to simulate');
            else
                obj.hasDataToPlot=true;
            end
        end
    end
end