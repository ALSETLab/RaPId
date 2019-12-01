classdef  RaPIdClass <handle
    %RAPIDCLASS defines a handle object to store and send settings and data in RaPId
    % without too much overhead
       
%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
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
% along with RaPId.  If not, see <http://www.gnu.org/licenses/>.
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
        parallelSettings
        multiObjSettings
        experimentSettings
        experimentData
        resultData
        fmuOutputNames
        parameterNames
        fmuInputNames
        version;  %decimals of sqrt(2)
    end
    
    methods (Static)
        function obj = loadobj(s)% Implements self-updating loading features to ensure backwards
                                    % compatibility with old objects
            try
                if ~isprop(s, 'version') || isempty(s.version) % if no version -> assign version=1
                    s.version=double(~isempty(isprop(s, 'version'))); % 0 if really old, else 1 - old
                end
                    obj = RaPIdClass(s); % make sure settings up-to-date
            catch err
                disp(err)
                disp(struct2table(err.stack))
            end
        end
        
    end
    
    methods
        function obj = RaPIdClass(varargin) %Constructor
            obj=initRapidSettings(obj); % Create new settings object
            if nargin == 0
                 %return object
            else
                % Make sure it is updated, by copying and updating props/fields
                try
                    obj=obj.updateRapidSettings(varargin{1}); % update old object
                catch err
                    disp(err)
                    warning('Your settings could not be loaded updated! Using defaults for some properties!')
                end
            end
        end
        function obj=makePathsRelative(obj,pathstr)
            if pathstr(end)==filesep
                pathstr=pathstr(1:end-1); % remove filesep
            end
            a={'experimentSettings','pathToSimulinkModel','pathToFmuModel';'experimentData','pathToReferenceData','pathToInData'};
            for k=1:2
                for j=1:2
                    oldfull=obj.(a{k,1}).(a{k,1+j});
                    [success,fileinfo]=fileattrib(oldfull); % get full path
                    if success && ~isempty(oldfull)
                        oldfull=fileinfo.Name;
                        [oldpath,filestr,extstr]=fileparts(oldfull);
                        if isempty(oldpath) || ispc && pathstr(1) ~= oldpath(1)
                            % we cannot traverse to other drive on PC
                        elseif strcmp(oldpath,pathstr) %same folder
                            obj.(a{k,1}).(a{k,1+j})=fullfile(strcat(filestr,extstr));
                        elseif any(strfind(oldpath,pathstr)) %old path is a subfolder)
                            m=fullfile(oldpath(length(pathstr)+1:end),strcat(filestr,extstr));
                            obj.(a{k,1}).(a{k,1+j})=m;%fullfile(oldpath(length(pathstr)+1),strcat(filestr,extstr));
                        else %new path is on subfolder
                            buildingrel='./../'; %one level up
                            tmpath=fileparts(pathstr);
                            while isempty(strfind(oldpath,tmpath)) && ~isempty(tmpath)
                                buildingrel=strcat(buildingrel,'../');
                                tmpath=fileparts(tmpath);
                            end
                            obj.(a{k,1}).(a{k,1+j})=fullfile(buildingrel,oldpath(length(tmpath)+1:end),strcat(filestr,extstr));
                        end
                    end
                end
            end
           % cd(oldFolder) % restore path

        end
        function obj = saveobj(obj)
            % Not implemented, possible remove some stuff that needn't be
            % saved
        end
    end   
end