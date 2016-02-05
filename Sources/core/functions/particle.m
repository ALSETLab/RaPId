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

classdef particle
    %PARTICLE 
    % Class representing a particle in the parameter space 
    % The speed of the particle is given in increment (no sampling time involved)
    % particle is characterized by its position 
    %   p: position of the particle, i.e vector of parameters
    %   v: speed, give the next position
    %   p_min, p_max: vector defining the size of the parameter space,
    %       these values constrain v to a limited space
    %   bestPos, bestValue: we keep in memory a trace of where and how the
    %       particule best behaved form the first iteration
    %   positions: historic of the positions for plotting, if plot = true
    % given through the function update, don't forget to take into account
    % v_min and v_max before calling this function
    % use horizontal vector everywhere
    %
    % Methods:
    %       updatePart: apply the speed to the particle and update the
    %           position, v needs to be redefined just before calling this
    %           function
    %       setBest: to define and reccord the bestPosition, not a part
    %           of the method updatePart since the fitness computation is
    %           exterior to the particle
    
    properties
        v_min = 0;
        v_max = 0;
        p_min = 0;
        p_max = 0;
        v = 0;
        p = 0;
        n = 0;
        Ts = 0;
        bestPos;
        bestValue ;
        plot = false;
        positions = [];
        fitness;
    end
    
    methods
        function obj = particle(varargin)
            if nargin==3 
                pMin=varargin{1};
                pMax=varargin{2};
                parameters=varargin{3};
            if length(pMax) ~= length(pMin) 
                throw('wrong size for pmax or pmin');
            end
            obj.p_min = pMin;
            obj.p_max = pMax;
            obj.n = length(pMin);
            if isempty(parameters)
                obj.p = (obj.p_max - obj.p_min).*rand(obj.n,1)' + obj.p_min;
            else
                obj.p = parameters;
            end
            obj.v_max = (obj.p_max - obj.p);
            obj.v_min = (obj.p_min - obj.p);
            obj.v = (obj.v_max - obj.v_min).*rand(obj.n,1)' + obj.v_min;
            obj.plot = false;
            else
                % just return a particle with default properties
            end 
        end
        
        function obj = particleV(pm,pM,verbose)
            if length(pM) ~= length(pm)
                throw('wrong size for pM or pm');
            end
            obj.p_min = pm;
            obj.p_max = pM;
            obj.n = length(pm);
            obj.p = (obj.p_max - obj.p_min).*rand(obj.n,1)' + obj.p_min;
            obj.v_max = (obj.p_max - obj.p);
            obj.v_min = (obj.p_min - obj.p);
            obj.v = (obj.v_max - obj.v_min).*rand(obj.n,1)' + obj.v_min;
            obj.plot = verbose; % boolean for plotting
        end
        
        function obj = updatePart(obj)
            obj.v = max(min(obj.v,obj.v_max),obj.v_min);
            obj.p = obj.p + obj.v;
            obj.v_max = obj.p_max - obj.p;
            obj.v_min = obj.p_min - obj.p;
            obj.positions = [obj.positions, obj.p'];
            
        end
        
        function obj = setBest(obj,value)
            if isempty(obj.bestValue) || obj.bestValue>=value
                obj.bestPos = obj.p;
                obj.bestValue = value;
            end
        end
                
            
        
    end
    
end

