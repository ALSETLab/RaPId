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

classdef RaPIdClass <handle
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
        ReferenceMode
        version=1;  %decimals of sqrt(2)
    end
    
    methods (Static)
        % Implement loading features to ensure backwards compatibility
        function obj = loadobj(obj) % we will use version here later
            if isstruct(obj)
                obj = RaPIdClass(obj);
            end
        end
    end
    methods
        function obj = RaPIdClass(varargin)
            if nargin==1 && isstruct(varargin{1}) % just to convert some old mySettings structs that was used for storing settings will be removed in future
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
                if ~isfield(tmp,'ReferenceMode')
                   obj.ReferenceMode = tmp.ReferenceMode;
                end
            end
        end
        function obj = saveobj(obj)
            
        end
    end   
end

