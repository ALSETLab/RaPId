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

classdef chromosome < matlab.mixin.Copyable
    %CHROMOSOME Class representing a chromosome, entity of the parameter 
    % space. 
    % The chromosome is characterised by genes (parameters) and is able to
    % organise crossovers with other chromosomes or to undergo a mutation
    % attributes:
    %   p_min,p_max: limit the search path, must be defined in
    %       settings.p_mxx
    %   p: position of the particle, i.e. vector of parameters
    %   fitness: objective function evaluated at position p
    properties
        p_min = 0;
        p_max = 0;
        p = 0;
        n = 0;
        fitness = Inf; % how good it is with regard with the cost function (0 is ideal)
    end
    
    methods
        %% Constructors
        % constructor generating the initial position randomly
        function obj = chromosome(pmin,pmax,p, varargin)
            if nargin ==0
                % Allow initalization of chromosome-arrays
            else
                if nargin == 3
                    N=1;
                else
                    N=varargin{1};
                    pN=length(p);
                end
                obj(N) = chromosome;
                assert(isempty(p) || iscell(p),'Starting position must be given as cell-array')                   
                assert(length(pmax) == length(pmin),'wrong size for pmin or pmax');
                for ii=1:N
                    obj(ii).p_min = pmin;
                    obj(ii).p_max = pmax;
                    obj(ii).n = length(pmin);
                    if isempty(p)
                        obj(ii).p = (obj(ii).p_max - obj(ii).p_min).*rand(obj(ii).n,1)' + obj(ii).p_min;
                    else
                        if ii<=pN
                            obj(ii).p = p{ii};
                        else
                            obj(ii).p = (obj(ii).p_max - obj(ii).p_min).*rand(obj(ii).n,1)' + obj(ii).p_min;
                        end
                    end
                end
            end
        end
        
%         % constructor receiving the initial position
%         function obj = chromosome2(pm,pM,pos,verbose)
%             if length(pM) ~= length(pm)
%                 throw('wrong size for pM or pm');
%             end
%             obj.p_min = pm;
%             obj.p_max = pM;
%             obj.n = length(pm);
%             obj.p = pos;
%         end
% Sort
        function [obj,idx]=sort(obj,varargin)
            %sort object array with respect to 'Fitness' property
            [~,idx]=sort([obj.fitness],varargin{:}); 
            obj=obj(idx);
        end
    %% Mutation
        % One gene is chosen randomly and changed with a truncated normal
        % distribution of variance decreasing with the iterations 
        % (power 5 chosen arbitrarily, could be parametrised)
        function [obj, out_indices] = mutate(obj,nbMutations,n_iter,n_final)
            nObjplus1=length(obj)+1;
            for ii=1:nbMutations
                chromosomeIndex=randperm(nObjplus1-2+ii,1);
                [obj, mutatedChromosomeIndex]=obj.duplicateChromosome(chromosomeIndex);
                %  index = ceil(obj.n*rand(1,1));
                geneIndex=randi([1 obj(1).n]);
                pp = inf;
                while pp>obj(mutatedChromosomeIndex).p_max(geneIndex) || pp<obj(mutatedChromosomeIndex).p_min(geneIndex)
                    pp = normrnd(obj(mutatedChromosomeIndex).p(geneIndex),(obj(mutatedChromosomeIndex).p_max(geneIndex)-obj(mutatedChromosomeIndex).p_min(geneIndex))/(3+497*(n_iter/n_final).^5),1,1);
                end
                obj=obj.setGenes(mutatedChromosomeIndex,geneIndex,pp);
            end
            out_indices=(nObjplus1):(nObjplus1+nbMutations-1);
        end
        %% functions for the cross-over of type 1 (mix some genes determined randomly)
        % One of the two chromosome has to organise the exchange, we will
        % call on the cross-over by doing [obj, out_indices] = obj.organiseCrossOver1(numberOfChromoseo)
        % f1 and f2 are two new chromosomes with mixed genes, this way c1
        % and c2 are unchanged
        function [obj, out_indices] = organiseCrossOver1(obj,numberOfChromosomePairs)
            nObj=length(obj);
            for ii=1:numberOfChromosomePairs
                indices=randperm(nObj-2+2*ii,2);
                [indexOfGenesToCross, index1Genes] = obj.initiateCrossOver1(indices(1));
                index2Genes=obj.getGenes(indices(2),indexOfGenesToCross);
                obj=obj.duplicateChromosome(indices(1));
                obj=obj.duplicateChromosome(indices(2));
                obj=obj.setGenes(nObj-1+2*ii,indexOfGenesToCross,index2Genes);
                obj=obj.setGenes(nObj+2*ii,indexOfGenesToCross,index1Genes);
            end
            out_indices=(nObj+1):(nObj+2*numberOfChromosomePairs);
        end
        
        % generate indexes of genes to switch randomly, output the
        % genes and the indexes
        function [genesToCross,genes] = initiateCrossOver1(obj, index)
            nb_exchange = ceil((obj(index).n-1)*rand(1,1));
            ls = randperm(obj(index).n);
            genesToCross = ls(1:nb_exchange);
            genes = obj(index).p(genesToCross);
        end
        
        % change its own genes
        function obj = setGenes(obj,index, genesToCross,genes)
            obj(index).p(genesToCross) = genes;
            obj(index).fitness=Inf;
        end
        
        
        
        %% Cross-over of type 2
        % One of the two chromosome has to organise the crossover, we will
        % call on the cross-over by doing [obj, out_indices] = c1.organiseCrossOver2(c2)
        % obj will contain two new chromosomes with mixed genes per cross-over,
        % out_indices will save the indices so that their fitness can be
        % calculated
        function [obj, out_indices] = organiseCrossOver2(obj,numberOfChromosomePairs)
            nGenes=obj(1).n;
            nObj=length(obj);
            for ii=1:numberOfChromosomePairs
                indices=randperm(nObj-2+2*ii,2);
                index1Genes = obj.getGenes(indices(1),1:obj(1).n);
                index2Genes = obj.getGenes(indices(2),1:obj(1).n);
                rd = rand(1,obj(1).n);
                obj=obj.duplicateChromosome(indices(1)); 
                obj=obj.duplicateChromosome(indices(2));
                NewGenes1 = rd.*index1Genes + (1 - rd).*index2Genes;
                NewGenes2 = rd.*index2Genes + (1 - rd).*index1Genes;
                obj = obj.setGenes(nObj-1+2*ii,1:nGenes,NewGenes1); 
                obj = obj.setGenes(nObj+2*ii,1:nGenes,NewGenes2);
            end
            out_indices=(nObj+1):(nObj+2*numberOfChromosomePairs);
        end
        
        %% function for both crossovers
        function genes = getGenes(obj,index,geneList)
            genes = obj(index).p(geneList);
        end
        function [obj, out_index]=duplicateChromosome(obj, index)
            out_index=length(obj)+1;
            obj(out_index)=obj(index);
        end
        function obj = survivalOfTheFittest(obj, numberOfSurvivors)
            obj=sort(obj,'ascend');
            kill=min(0,length(obj)-numberOfSurvivors);
            obj(end-kill:end)=[];
        end
    end
    
end

