function  obj = updateRapidSettings(obj,oldThing)
%% UPDATERAPIDOBJ this method updates old structures and objects containing settings for RaPId
%   Detailed explanation goes here
% 

%% Check version
if isfield(oldThing,'version') || isprop(oldThing,'version')
    objversion=oldThing.version; %old version number
else % we are dealing with a struct with no version, probably user forgot this
    warning(strcat('Assuming that RapidSettings conforms to ver. ',num2str(1.41)));
    objversion=1.41; % we assume that we conform to latest version 
end

%% Update legacy settings
if isstruct(oldThing) && objversion==0 %to convert loaded legacy structs
    oldThing=updateLegacy(oldThing);
    objversion=1; % ver should now be according to 1
end

%% Copy settings to new object
oldnames=fieldnames(oldThing);  % should work for both objs/structs
oldnames=oldnames(~strcmp(oldnames,'version')); % dont copy version
for k=1:length(oldnames) % cycle through old fieldnames
    if isprop(obj,oldnames{k}) %if corresponding field exist in new obj
        obj.(oldnames{k})=copyRecursively(obj.(oldnames{k}),oldThing.(oldnames{k})); %copy recursively if needed
    end
end


%% For certain versions we will convert some old settings to new
if objversion==1.41; 
    return; % return if up to date
elseif objversion <1.41 % Make sure everythings is up to date to 1.41
        oldnames={'alpha1','alpha2','alpha3'};
        newnames={'w','self_coeff','social_coeff'};
        for k=1:3 %renaming fields in psoSettings
            obj.psoSettings.(newnames{k})=oldThing.psoSettings.(oldnames{k});
        end
      %  objversion=1.41;  % will be used when incrementing
    % this will contain more things as changed to attributes
    % are introduced. i.e if ==1.4 and so on.
end
    
end %end of method
%% Supplemental functions
function target=copyRecursively(target,source)
        % copy content & if struct copy fields recursively
if isstruct(source) && isstruct(target) %recursively copy if structs
    f=intersect(fieldnames(source),fieldnames(target)); %only copy common fields
    for k=1:length(f)
        content=source.(f{k});
        if isstruct(content) % if true, apply function recursively
            target.(f{k})=copyRecursively(target.(f{k}),content);
        else % just copy
            target.(f{k})=source.(f{k});
        end
    end
else %not a struct, just copy
    target=source;
end
end
function target=updateLegacy(source)
    % update some very old legacy structs to a struct which is easier to
    % update
    target.psoSettings = source.pso_options;
    target.naiveSettings = source.naive_options;
    target.gaSettings = source.ga_options;
    target.combiSettings = source.combiOptions;
    target.knitroSettings = source.kn_options;
    target.nmSettings = source.nmOptions;
    target.cgSettings = source.cgOptions;
    target.psoExtSettings = source.psoExtOptions;
    target.gaExtSettings = source.gaExtOptions;
    target.fminconSettings = source.fminconOptions;
    target.fmuOutputNames = source.fmuOutData;
    target.parameterNames = source.parameterNames;
    target.experimentSettings = struct('tf',source.tf,'ts',source.Ts,...
        'p_min',source.p_min,'p_max',source.p_max,'p_0',source.p0,'cost_type',source.cost,'objective_weights',source.objective.vect,...
        't_fitness_start',source.t0_fitness,'integrationMethod',source.intMethod, ...
        'pathToSimulinkModel',source.path2simulinkModel,'modelName',source.modelName,'blockName',source.blockName,...
        'scopeName',source.scopeName,'verbose',source.verbose,'saveHist', false,'optimizationAlgorithm',source.methodName);
    target.experimentData = struct('referenceOutdata',source.realData,'referenceTime',source.realTime,'pathToReferenceData',source.path2data,...
        'expressionReferenceTime',source.dataT,'expressionReferenceData',source.dataY);
    target.experimentSettings.outputPostProcessing=@(x)x; %function handle, do nothing as standard
    if isfield(source,'displayMode')
        target.experimentSettings.displayMode = source.displayMode;
    end
    if isfield(source,'nbMaxIterations')
        target.experimentSettings.maxIterations = source.nbMaxIterations;
    end
    if isfield(source, 'mode')
        target.experimentSettings.solverMode = source.mode;
    end
    if isfield(source,'fmuInputNames')
        target.fmuInputNames = source.fmuInputNames;
    end
    if isfield(source,'path2fmuModel')
        target.experimentSettings.pathToFmuModel = source.path2fmuModel;
    end
    if isfield(source,'pf_options') && ~isempty(source.pf_options)
        target.pfSettings = source.pf_options;
    end
    if isfield(source,'inDat')
        source.inDat = struct('path',[],'signal',[],'time',[]);
    end
    target.experimentData.pathToInData = source.inDat.path;
    target.experimentData.expressionInData = source.inDat.signal;
    target.experimentData.expressionInDataTime = source.inDat.time;
end