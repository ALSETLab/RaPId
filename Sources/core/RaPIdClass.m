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

classdef  RaPIdClass <handle
    %RAPIDCLASS defines a handle object to store and send settings and data in RaPId 
    % without too much overhead
    
    
    properties
        psoSettings
        gaSettings
        combiSettings
        naiveSettings
        knitroSettings
        nmSettings
        cgSettings        
        psoExtSettings
        gaExtSettings
        fminconSettings
        pfSettings
        experimentSettings
        experimentData
        resultData
        fmuOutputNames
        parameterNames
        fmuInputNames
        version;  %decimals of sqrt(2)
    end
    
    methods (Static)
        % Implement loading features to ensure backwards compatibility
        function obj = loadobj(s)
            try
                if ~isprop(s, 'version') || isempty(s.version) % if no version -> assign version=1
                    s.version=double(~isempty(isprop(s, 'version'))); % 0 if really old, else 1 - old
                    obj = RaPIdClass(s); % update object
                elseif s.version <1.4 % check if latest ver
                    obj = RaPIdClass(s); % update object
                else
                    obj=s; % everything is up to date
                end
            catch err
                disp(err)
            end
        end
    end
    methods
        function obj = RaPIdClass(varargin)
            if nargin > 0 && isstruct(varargin{1}) && varargin{1}.version==0 %to convert some old mySettings-structs, will be removed in future.
                tmp=varargin{1};
                obj.psoSettings = tmp.pso_options;
                obj.naiveSettings = tmp.naive_options;
                obj.gaSettings = tmp.ga_options;
                obj.combiSettings = tmp.combiOptions;
                obj.knitroSettings = tmp.kn_options;
                obj.nmSettings = tmp.nmOptions;
                obj.cgSettings = tmp.cgOptions;
                obj.psoExtSettings = tmp.psoExtOptions;
                obj.gaExtSettings = tmp.gaExtOptions;
                obj.fminconSettings = tmp.fminconOptions;
                obj.fmuOutputNames = tmp.fmuOutData;
                obj.parameterNames = tmp.parameterNames;
                obj.experimentSettings = struct('tf',tmp.tf,'ts',tmp.Ts,...
                    'p_min',tmp.p_min,'p_max',tmp.p_max,'p_0',tmp.p0,'cost_type',tmp.cost,'objective_weights',tmp.objective.vect,...
                    't_fitness_start',tmp.t0_fitness,'integrationMethod',tmp.intMethod, ...
                    'pathToSimulinkModel',tmp.path2simulinkModel,'modelName',tmp.modelName,'blockName',tmp.blockName,...
                    'scopeName',tmp.scopeName,'verbose',tmp.verbose,'saveHist', false,'optimizationAlgorithm',tmp.methodName);
                obj.experimentData = struct('referenceOutdata',tmp.realData,'referenceTime',tmp.realTime,'pathToReferenceData',tmp.path2data,...
                    'expressionReferenceTime',tmp.dataT,'expressionReferenceData',tmp.dataY);
                obj.experimentSettings.outputPostProcessing=@(x)x; %function handle, do nothing as standard
                if isfield(tmp,'displayMode')
                    obj.experimentSettings.displayMode = tmp.displayMode;
                else
                    obj.experimentSettings.displayMode = 'hide';
                end
                if isfield(tmp,'nbMaxIterations')
                obj.experimentSettings.maxIterations = tmp.nbMaxIterations;
                else
                    obj.experimentSettings.maxIterations = 100;
                end
                if isfield(tmp, 'mode')
                    obj.experimentSettings.solverMode = tmp.mode;
                else
                    obj.experimentSettings.solverMode = 'Simulink';
                end         
                if isfield(tmp,'fmuInputNames')
                    obj.fmuInputNames = tmp.fmuInputNames;
                end
                if isfield(tmp,'path2fmuModel')
                    obj.experimentSettings.pathToFmuModel = tmp.path2fmuModel;
                end
                if isfield(tmp,'pf_options') && ~isempty(tmp.pf_options)
                    obj.pfSettings = tmp.pf_options;
                else
                    obj.pfSettings = struct('nb_particles', 100,'prune_threshold', 0.1,'kernel_sigma',1);
                end
                if ~isfield(tmp,'inDat')
                    tmp.inDat = struct('path',[],'signal',[],'time',[]);
                end
                obj.experimentData.pathToInData = tmp.inDat.path;
                obj.experimentData.expressionInData = tmp.inDat.signal;
                obj.experimentData.expressionInDataTime = tmp.inDat.time;
                obj.version=1; % ver should be according to 1
                obj=RaPIdClass(obj); % update to latest version
            end
            if nargin > 0 && isstruct(varargin{1}) && varargin{1}.version==1
                tmp=varargin{1};
                obj.psoSettings=tmp.psoSettings;
                obj.gaSettings=tmp.gaSettings;
                obj.combiSettings=tmp.combiSettings;
                obj.naiveSettings=tmp.naiveSettings;
                obj.knitroSettings=tmp.knitroSettings;
                obj.nmSettings=tmp.nmSettings;
                obj.cgSettings=tmp.cgSettings;
                obj.psoExtSettings=tmp.psoExtSettings;
                obj.gaExtSettings=tmp.gaExtSettings;
                obj.fminconSettings=tmp.fminconSettings;
                obj.pfSettings=tmp.pfSettings;
                obj.experimentSettings=tmp.experimentSettings;
                obj.experimentData=tmp.experimentData;
                obj.resultData=tmp.resultData;
                obj.fmuOutputNames=tmp.fmuOutputNames;
                obj.parameterNames=tmp.parameterNames;
                obj.fmuInputNames=tmp.fmuInputNames;
                obj.version=tmp.version;
                obj=RaPIdClass(obj); % update rapidobject to latest version
            elseif nargin>0 && isa(varargin{1},'RaPIdClass')
                if varargin{1}.version<1.4
                    obj=varargin{1};
                    obj.experimentSettings.timeOut=2; %default
                    obj.version=1.4;
                    % this should contain more things as changed to attributes
                    % are introduced. i.e if <1.41 and so on.
                end
            end
            
        end
        function obj = saveobj(obj)
            
        end
    end   
end

