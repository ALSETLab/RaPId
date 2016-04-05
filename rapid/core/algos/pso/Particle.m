classdef Particle < matlab.mixin.Copyable
%Particle - class representing a particle, an entity of the parameter 
% space. 
% The particle is characterised by its position, speed (parameters) and fitness and is able to
% be attracted to the best position of particles (including self)
% 
%   p_min,p_max: limits to the search space
%   p: the position of the particle, i.e. a vector of parameters
%   fitness: objective function evaluated at position p
    
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
    properties
        v_min = 0; % minimum speed for current position
        v_max = 0; % maximum speed for current position
        v=0;    % current speed of the particle
        p_min = 0; %lower boundary (vector) for search space
        p_max = 0; %upper boundary (vector) for search space
        p = 0;  % current position of the particle
        n = 1;  % dimension of search space
        fitness = Inf; % how good it is with regard with the cost function (0 is ideal)
        bestPos;  % personal best position attained
        bestValue; % personal best fitness value
        positions; % history of positions
        kick=0.01; % kick constant
    end
    methods
        function obj = Particle(pmin,pmax,p,kick) 
            %% Constructor
            % obj=Particle(pmin,pmax,p,kick) creates a new particle obj
            % (also accepts zero input parameters)
            if nargin ==0
                % Allow initalization of chromosome-arrays, props will have
                % default values
            else
                obj = Particle;
                assert(length(pmax) == length(pmin),'wrong size for pmin or pmax');
                obj.p_min = pmin;
                obj.p_max = pmax;
                obj.n = length(pmin);
                if isempty(p)
                    obj.p = (obj.p_max - obj.p_min).*rand(obj.n,1)' + obj.p_min;
                else
                    if obj.n==length(p)
                        obj.p = p;
                    else
                        obj.p = (obj.p_max - obj.p_min).*rand(obj.n,1)' + obj.p_min;
                    end
                end
                obj.v_max = (obj.p_max - obj.p);
                obj.v_min = (obj.p_min - obj.p);
                obj.v = (obj.v_max - obj.v_min).*rand(obj.n,1)' + obj.v_min;
                if nargin==4
                    obj.kick=kick;
                end
            end
        end
       function updateSpeed(obj,v,varargin)
           % obj.updateSpeed(v, varargin) updates the speed of the particle
           % obj to v, varargin can contain a custom "kick"
           if nargin==3
               obj.kick=varargin{1}; %allow to change this
           end
           obj.v=max(min(v,obj.v_max),obj.v_min); % update speed
           if all(obj.v==0) && obj.kick ~=0 % we are stuck, particle will behave chaotically
               obj.v=(obj.v_max - obj.v_min).*obj.kick*rand(obj.n,1)' + obj.v_min; %random
           end
       end
        function updatePosition(obj)
            % update position after speed has been updated
            obj.p = obj.p + obj.v;
            obj.v_max = obj.p_max - obj.p;
            obj.v_min = obj.p_min - obj.p;
            obj.positions = [obj.positions, obj.p'];
        end
        
        function setBest(obj,value)
            % set the personal best position & value attained
            if isempty(obj.bestValue) || obj.bestValue>=value %new best
                obj.bestPos = obj.p;
                obj.bestValue = value;
            end
        end
        function fitness=calculateFitness(obj,fitnessfunction)    
            %calculate fitness using the fitness function given as input
            fitness=fitnessfunction(obj.p);
            obj.fitness=fitness;
           if isempty(obj.bestValue) || obj.bestValue>=fitness
                obj.bestPos = obj.p;
                obj.bestValue = fitness;
           end
        end
        function [personalbest,personalbestpos] = getParticlesBest(obj)
            % get the particle's personal best value and position
            personalbest=obj.bestValue;
            personalbestpos=obj.bestPos;
        end
    end
end

