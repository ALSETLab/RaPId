function  obj = updateRapidSettings(obj,oldThing)
% UPDATERAPIDOBJ this function will update old rapid-objects
%   Detailed explanation goes here
if isfield(oldThing,'version') || isprop(oldThing,'version')
    objversion=oldThing.version; %old version number
else % we are dealing with a struct with no version, probably user forgot this
    objversion=1.41; % we assume that we conform to latest version 
end
%% This part takes care of updating old structs to rapidSettingss
if isstruct(oldThing) && objversion==0 %to convert some legacy mySettings-structs
    obj.psoSettings = oldThing.pso_options;
    obj.naiveSettings = oldThing.naive_options;
    obj.gaSettings = oldThing.ga_options;
    obj.combiSettings = oldThing.combiOptions;
    obj.knitroSettings = oldThing.kn_options;
    obj.nmSettings = oldThing.nmOptions;
    obj.cgSettings = oldThing.cgOptions;
    obj.psoExtSettings = oldThing.psoExtOptions;
    obj.gaExtSettings = oldThing.gaExtOptions;
    obj.fminconSettings = oldThing.fminconOptions;
    obj.fmuOutputNames = oldThing.fmuOutData;
    obj.parameterNames = oldThing.parameterNames;
    obj.experimentSettings = struct('tf',oldThing.tf,'ts',oldThing.Ts,...
        'p_min',oldThing.p_min,'p_max',oldThing.p_max,'p_0',oldThing.p0,'cost_type',oldThing.cost,'objective_weights',oldThing.objective.vect,...
        't_fitness_start',oldThing.t0_fitness,'integrationMethod',oldThing.intMethod, ...
        'pathToSimulinkModel',oldThing.path2simulinkModel,'modelName',oldThing.modelName,'blockName',oldThing.blockName,...
        'scopeName',oldThing.scopeName,'verbose',oldThing.verbose,'saveHist', false,'optimizationAlgorithm',oldThing.methodName);
    obj.experimentData = struct('referenceOutdata',oldThing.realData,'referenceTime',oldThing.realTime,'pathToReferenceData',oldThing.path2data,...
        'expressionReferenceTime',oldThing.dataT,'expressionReferenceData',oldThing.dataY);
    obj.experimentSettings.outputPostProcessing=@(x)x; %function handle, do nothing as standard
    if isfield(oldThing,'displayMode')
        obj.experimentSettings.displayMode = oldThing.displayMode;
    end
    if isfield(oldThing,'nbMaxIterations')
        obj.experimentSettings.maxIterations = oldThing.nbMaxIterations;
    end
    if isfield(oldThing, 'mode')
        obj.experimentSettings.solverMode = oldThing.mode;
    end
    if isfield(oldThing,'fmuInputNames')
        obj.fmuInputNames = oldThing.fmuInputNames;
    end
    if isfield(oldThing,'path2fmuModel')
        obj.experimentSettings.pathToFmuModel = oldThing.path2fmuModel;
    end
    if isfield(oldThing,'pf_options') && ~isempty(oldThing.pf_options)
        obj.pfSettings = oldThing.pf_options;
    end
    if isfield(oldThing,'inDat')
        oldThing.inDat = struct('path',[],'signal',[],'time',[]);
    end
    obj.experimentData.pathToInData = oldThing.inDat.path;
    obj.experimentData.expressionInData = oldThing.inDat.signal;
    obj.experimentData.expressionInDataTime = oldThing.inDat.time;
    objversion=1; % ver should now be according to 1
end
%% Copy settings to new object

oldnames=fieldnames(oldThing);  % should work for both objs/structs
oldnames=oldnames(~strcmp(oldnames,'version')); % dont copy version
for k=1:length(oldnames)
    if isprop(obj,oldnames{k})  
        obj.(oldnames{k})=oldThing.(oldnames{k}); %only copy correct stuff
    end
end
%% We can now be sure that the object has the right properties copied, time to update the last changes to make objects up to date to 1.41
if objversion<1.4  %Make sure everythings is up to date to 1.4
    obj.experimentSettings.timeOut=2;
    objversion=1.4; % increment version number
end
    
    if objversion <1.41 % Make sure everythings is up to date to 1.41
        oldnames={'alpha1','alpha2','alpha3'};
        newnames={'w','self_coeff','social_coeff'};
        for k=1:3 %renaming fields in psoSettings
            obj.psoSettings.(newnames{k})=obj.psoSettings.(oldnames{k});
            
        end
        obj.psoSettings=rmfield(obj.psoSettings,oldnames);
        obj.psoSettings.method='PSO';
        obj.psoSettings.w_min=0.01;
        obj.psoSettings.w_max=1;
        objversion=1.41;  % will be used when incrementing
    end
    % this will contain more things as changed to attributes
    % are introduced. i.e if ==1.4 and so on.
end