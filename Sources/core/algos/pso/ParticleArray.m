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

classdef ParticleArray < handle
    properties 
        ParticleList=Particle % the main Particle array
        listOfUnfitted  % unused as of now
        n % size of non-empty array
        globalbestvalue=Inf;
        globalbestpos
    end
    methods
        %% Constructor which create the object and pre-allocates an array of Particles
        function obj = ParticleArray(n) % Pre-allocate Array
            for n=n:-1:1 % counting backwards for Memory pre-allocation
                obj.ParticleList(n)=Particle();
            end
            obj.n=0;
        end
        %% Create new Particle
        function obj=createParticle(obj,pmin,pmax,p) % Create actual Particles
            ii=obj.n+1;
            assert(length(pmax) == length(pmin),'wrong size for pmin or pmax');
            if isempty(p) || length(pmin) ~= length(p)          
                obj.ParticleList(ii) = Particle(pmin,pmax,(pmax - pmin).*rand(length(pmin),1)' + pmin);
            else
                obj.ParticleList(ii) = Particle(pmin,pmax,p);
            end
            obj.n=obj.n+1;

        end
        %% Sort according to fitness
        function obj=sort(obj,varargin)
            %sort Particle array with respect to 'Fitness' property
            [~,idx]=sort([obj.ParticleList(1:(obj.n)).fitness],varargin{:});
            obj.ParticleList(1:obj.n)=obj.ParticleList(idx);
        end
        %% Duplicate specified Particles
        function obj=duplicateParticle(obj, index)
            obj.ParticleList(obj.n+1)=copy(obj.ParticleList(index));
            obj.n=obj.n+1;
        end
        function obj=updateCFASpeed(obj,constriction,wt,self_coeff,social_coeff)
            for ii=1:obj.n
                obj.ParticleList(ii).updateSpeed(constriction*(wt * obj.ParticleList(ii).v + self_coeff*rand*(obj.ParticleList(ii).bestPos - obj.ParticleList(ii).p) + social_coeff*rand*(obj.globalbestpos - obj.ParticleList(ii).p)));
            end
        end
        function positions=updatePositions(obj)
            for ii=1:obj.n
                positions=obj.ParticleList(ii).updatePosition();
            end
        end
        function fitnesses=calculateFitnesses(obj,fitnessfunction)
            fitnesses=zeros(1,obj.n);
            for ii=1:obj.n
                fitnesses(ii)=obj.ParticleList(ii).calculateFitness(fitnessfunction);
            end
            
        end
        function [globalbestvalue,globalbestpos,newbestboolean]=updateGlobalBest(obj)
            newbestboolean=0;
            for ii=1:obj.n
                [particlesbest,particlesbestpos]=obj.ParticleList(ii).getParticlesBest();
                if particlesbest<obj.globalbestvalue
                    obj.globalbestvalue=particlesbest;
                    obj.globalbestpos=particlesbestpos;
                    newbestboolean=1;
                end
            end
            globalbestvalue=obj.globalbestvalue;
            globalbestpos=obj.globalbestpos;
        end
    end
end