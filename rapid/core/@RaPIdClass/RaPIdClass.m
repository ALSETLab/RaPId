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
                    obj = RaPIdClass(s); % update object
                elseif s.version <1.41 % check if latest ver
                    obj = RaPIdClass(s); % update object
                else
                    obj=s; % everything is up to date
                end
            catch err
                disp(err)
                disp(struct2table(err.stack))
            end
        end
        
    end
    
    methods
        function obj = RaPIdClass(varargin) %Constructor
            if nargin == 0 %Create a new object of the latest version
                try
                    obj=initRapidObj(obj);
                catch 
                    %NOP, will still give a an object 
                end
            elseif isa(varargin{1},'RaPIdClass') && varargin{1}.version==1.41 
                %NOP, up to date
                obj=varargin{1};
            else  % Old version, try to update
                obj=RaPIdClass(); % New object
                obj=obj.updateRapidObj(varargin{1}); % update old object
            end
        end
        function obj = saveobj(obj)
            
        end
    end   
end