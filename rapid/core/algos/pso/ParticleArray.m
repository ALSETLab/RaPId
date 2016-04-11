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
        list=Particle % the main Particle array
        listOfUnfitted  % unused as of now
        n % size of non-empty Particle array
        globalbestvalue=Inf;
        globalbestpos
    end
    properties (Hidden=true)
        currach;
    end
    methods
        % Constructor create the object and pre-allocate array of Particles
        function obj = ParticleArray(varargin)  
            % Constructor of PARTICLEARRAY
            if nargin==1
                k=varargin{1};
                for ii=k:-1:1 % count backwards for Memory pre-allocation
                    obj.list(k)=Particle();
                end
            end
            obj.n=0;
        end
        function createParticle(obj,pmin,pmax,p) 
            % Create Particles with specified PMIN, PMAX, and P
            ii=obj.n+1;
            obj.list(ii) = Particle(pmin,pmax,p);
            obj.n=obj.n+1;
            obj.currach(obj.n)=Inf;
        end
    
        function obj=sort(obj,varargin)
            %Sorts Parictles with respect to 'fitness' property
            [~,idx]=sort([obj.list(1:(obj.n)).fitness],varargin{:});
            obj.list(1:obj.n)=obj.list(idx);
        end

        function duplicateParticle(obj, index)
            % Duplicate Particle specified by INDEX.
            obj.list(obj.n+1)=copy(obj.list(index));
            obj.n=obj.n+1;
        end
        function updateCFASpeed(obj,constriction,wt,self_c,social_c)
            %update speed of Particles in array according to CFA-PSO.
            for ii=1:obj.n
                obj.list(ii).updateSpeed(constriction*...
                    (wt * obj.list(ii).v  ...
                    + self_c*rand*(obj.list(ii).bestPos-obj.list(ii).p) ... 
                    + social_c*rand*(obj.globalbestpos-obj.list(ii).p)));
            end
        end
        
        function updatePSOPCSpeed(obj,wt,self_c,social_c,pass_c)
            for ii=1:obj.n
                Ri=obj.list(randi([1, obj.n])).p; % selects random particle
                obj.list(ii).updateSpeed(wt * obj.list(ii).v  ...
                    + self_c*rand*(obj.list(ii).bestPos-obj.list(ii).p) ...
                    + social_c*rand*(obj.globalbestpos-obj.list(ii).p)...
                    + pass_c*rand(Ri-obj.list(ii).p));
            end
        end
        
        function updateSpeedPSOCA(obj,wt)
            currbest=find(min(obj.list(1:end).fitness));
            for ii=1:obj.n
                if any(ii==currbest)
                    obj.list(ii).updateSpeed(wt*obj.list(ii).v + ...
                        rand*(obj.list(randi([1, obj.n])).p-obj.list(ii).p));
                else
                    w=(obj.list(1:end).p-obj.list(ii).p);
                    w=w/sum(w);
                    ca_vec=(obj.list(1:end).p-repmat(obj.list(ii).p,1,obj.n))*(w.*rand(obj.n,1));
                    obj.list(ii).updateSpeed(wt*obj.list(ii).v + ca_vec); 
                end
            end
        end
        
        function positions=updatePositions(obj)
            %Update the positions of Particles in the array.
            for ii=1:obj.n
                obj.list(ii).updatePosition();
            end
        end
        
        function fitnesses=calculateFitnesses(obj,func)
            % Update the fitness of Particles in array using FUNC
            fitnesses=zeros(1,obj.n);
            for ii=1:obj.n
                fitnesses(ii)=obj.list(ii).calculateFitness(func);
            end
            
        end
        
        function [gbestv,gbestp,newbestbool]=updateGlobalBest(obj)
            % Update the best position and fitness value obtained by
            % particles
            newbestbool=0;
            for ii=1:obj.n
                [pbestv,pbestp]=obj.list(ii).getParticlesBest();
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