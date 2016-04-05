
classdef ParticleArray < handle
%% PARTICLEARRAY is a class to hold an array of particles for PSOs.
%   See methods for further details.
%   
% See also: RAPID, PARTICLE, OWN_CFAPSO
    
    
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
        ParticleList=Particle % the main Particle array
        listOfUnfitted  % unused as of now
        n % size of non-empty Particle array
        globalbestvalue=Inf;
        globalbestpos
    end
    methods
        %% Constructor which create the object and pre-allocates an array of Particles
        function obj = ParticleArray(varargin)  % Pre-allocate Array
            if nargin==1
                k=varargin{1};
                for ii=k:-1:1 % counting backwards for Memory pre-allocation
                    obj.ParticleList(k)=Particle();
                end
            end
            obj.n=0;
        end
        function createParticle(obj,pmin,pmax,p) 
            % Create Particles with specified PMIN, PMAX, and P
            ii=obj.n+1;
            obj.ParticleList(ii) = Particle(pmin,pmax,p);
            obj.n=obj.n+1;
        end
    
        function obj=sort(obj,varargin)
            %Sorts Parictles with respect to 'fitness' property
            [~,idx]=sort([obj.ParticleList(1:(obj.n)).fitness],varargin{:});
            obj.ParticleList(1:obj.n)=obj.ParticleList(idx);
        end

        function duplicateParticle(obj, index)
            % Duplicate Particle specified by INDEX.
            obj.ParticleList(obj.n+1)=copy(obj.ParticleList(index));
            obj.n=obj.n+1;
        end
        function updateCFASpeed(obj,constriction,wt,self_coeff,social_coeff)
            %update speed of Particles in array according to CFA-PSO.
            for ii=1:obj.n
                obj.ParticleList(ii).updateSpeed(constriction*...
                    (wt * obj.ParticleList(ii).v + ...
                    self_coeff*rand*(obj.ParticleList(ii).bestPos - obj.ParticleList(ii).p) ... 
                    + social_coeff*rand*(obj.globalbestpos - obj.ParticleList(ii).p)));
            end
        end
        function positions=updatePositions(obj)
            %Update the positions of Particles in the array.
            for ii=1:obj.n
                obj.ParticleList(ii).updatePosition();
            end
        end
        
        function fitnesses=calculateFitnesses(obj,func)
            % Update the fitness of Particles in array using FUNC
            fitnesses=zeros(1,obj.n);
            for ii=1:obj.n
                fitnesses(ii)=obj.ParticleList(ii).calculateFitness(func);
            end
            
        end
        
        function [gbestv,gbestp,newbestbool]=updateGlobalBest(obj)
            % Update the best position and fitness value obtained by
            % particles
            newbestbool=0;
            for ii=1:obj.n
                [pbestv,pbestp]=obj.ParticleList(ii).getParticlesBest();
                if pbestv<obj.globalbestvalue
                    obj.globalbestvalue=pbestv;
                    obj.globalbestpos=pbestp;
                    newbestbool=1;
                end
            end
            gbestv=obj.globalbestvalue;
            gbestp=obj.globalbestpos;
        end
    end
end