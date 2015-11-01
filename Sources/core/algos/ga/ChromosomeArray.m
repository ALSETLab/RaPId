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

classdef ChromosomeArray < handle
    properties
        ChromosomeList=Chromosome % the main Chromosome array
        pointerToLastOldChromosome % ptr to place for last old Chromosomes
        pointerToNewChromosome  % ptr to place for new Chromosomes
        listOfUnfitted  % unused as of now
    end
    methods
        %% Constructor which create the object and pre-allocates an array of Chromosomes
        function obj = ChromosomeArray(n) % Pre-allocate Array
            for n=n:-1:1 % counting backwards for Memory pre-allocation
                obj.ChromosomeList(n)=Chromosome();
            end
            obj.pointerToNewChromosome=1;
            obj.pointerToLastOldChromosome=0;
        end
        %% Create new chromosome
        function obj=createChromosome(obj,pmin,pmax,p) % Create actual Chromosomes
            ii=obj.pointerToNewChromosome;
            assert(length(pmax) == length(pmin),'wrong size for pmin or pmax');
            obj.ChromosomeList(ii).p_min = pmin;
            obj.ChromosomeList(ii).p_max = pmax;
            obj.ChromosomeList(ii).n = length(pmin);
            if isempty(p) || length(pmin) ~= length(p)
                obj.ChromosomeList(ii).p = (pmax - pmin).*rand(obj.ChromosomeList(ii).n,1)' + pmin;
            else
                obj.ChromosomeList(ii).p = p;
            end
            obj.pointerToNewChromosome=obj.pointerToNewChromosome+1;
        end
        %% Sort according to fitness
        function obj=sort(obj,varargin)
            %sort Chromosome array with respect to 'Fitness' property
            [~,idx]=sort([obj.ChromosomeList(1:(obj.pointerToNewChromosome-1)).fitness],varargin{:});
            obj.ChromosomeList(1:obj.pointerToNewChromosome-1)=obj.ChromosomeList(idx);
        end
        %% Duplicate specified chromosomes
        function obj=duplicateChromosome(obj, index)
            obj.ChromosomeList(obj.pointerToNewChromosome)=copy(obj.ChromosomeList(index));
            obj.pointerToNewChromosome=obj.pointerToNewChromosome+1;
        end
        %% Mutation
        % Wherein genes are chosen randomly and changed with a truncated normal
        % distribution of variance decreasing with the iterations
        % (power of 5 chosen arbitrarily, could be parametrised)
        function obj = mutateRandomChromosomes(obj,nbMutations,n_iter,n_final)
            for ii=1:nbMutations
                pointerToMutatingChromosome=obj.pointerToNewChromosome;
                chromosomeIndex=randperm(pointerToMutatingChromosome-1,1);
                obj.duplicateChromosome(chromosomeIndex);
                geneIndex=randi([1 obj.ChromosomeList(1).n]);
                mutatedGenes = inf;
                while mutatedGenes>obj.ChromosomeList(pointerToMutatingChromosome).p_max(geneIndex) || mutatedGenes<obj.ChromosomeList(pointerToMutatingChromosome).p_min(geneIndex)
                    mutatedGenes = normrnd(obj.ChromosomeList(pointerToMutatingChromosome).p(geneIndex),(obj.ChromosomeList(pointerToMutatingChromosome).p_max(geneIndex)-obj.ChromosomeList(pointerToMutatingChromosome).p_min(geneIndex))/(3+497*(n_iter/n_final).^5),1,1);
                end
                obj.ChromosomeList(pointerToMutatingChromosome).setGenes(geneIndex,mutatedGenes);
            end
        end
        %% Cross-over of type 1 (mix some genes determined randomly)
        % One of the two chromosome has to organise the exchange, we will
        % call on the cross-over by doing [obj, out_indices] = obj.organiseCrossOver1(numberOfChromoseo)
        % f1 and f2 are two new chromosomes with mixed genes, this way c1
        % and c2 are unchanged
        % generate indexes of genes to switch randomly, output the
        % genes and the indexes
        function obj  = doCrossOverType1(obj,numberOfChromosomePairs)
            for ii=1:numberOfChromosomePairs
                indices=randperm(obj.pointerToNewChromosome-1,2);
                [indexOfGenesToCross, index1Genes] = obj.ChromosomeList(indices(1)).getRandomGenes();
                index2Genes=obj.ChromosomeList(indices(2)).getGenes(indexOfGenesToCross);
                obj=obj.duplicateChromosome(indices(1));
                obj.ChromosomeList(obj.pointerToNewChromosome-1).setGenes(indexOfGenesToCross,index2Genes);
                obj=obj.duplicateChromosome(indices(2));
                obj.ChromosomeList(obj.pointerToNewChromosome-1).setGenes(indexOfGenesToCross,index1Genes);
            end
        end
        %% Cross-over of type 2
        % One of the two chromosome has to organise the crossover, we will
        % call on the cross-over by doing [obj, out_indices] = c1.organiseCrossOver2(c2)
        % obj will contain two new chromosomes with mixed genes per cross-over,
        % out_indices will save the indices so that their fitness can be
        % calculated
        function  doCrossOverType2(obj,numberOfChromosomePairs)
            nGenes=obj.ChromosomeList(1).n;
            for ii=1:numberOfChromosomePairs
                indices=randperm(obj.pointerToNewChromosome-1,2);
                index1Genes=obj.ChromosomeList(indices(1)).getGenes(1:nGenes);
                index2Genes=obj.ChromosomeList(indices(2)).getGenes(1:nGenes);
                rd = rand(1,nGenes);
                NewGenes1 = rd.*index1Genes + (1 - rd).*index2Genes;
                NewGenes2 = rd.*index2Genes + (1 - rd).*index1Genes;
                obj=obj.duplicateChromosome(indices(1));
                obj.ChromosomeList(obj.pointerToNewChromosome-1).setGenes(1:nGenes,NewGenes1);
                obj=obj.duplicateChromosome(indices(2));
                obj.ChromosomeList(obj.pointerToNewChromosome-1).setGenes(1:nGenes,NewGenes2);
            end
        end
        %% Evolution: who survives to this round
        % remove the least fit ones, not the most clever option but easily put
        % into practice
        % to include a random parameter with can retain some of the ones in the
        % tail of the queue, to be fixed
        %     indexOfindexes = randperm(length(indexes));
        %     indexOfindexes = indexOfindexes(1:settings.ga_options.nbReinjection);
        %     indexes(indexOfindexes) = [];
        function obj = survivalOfTheFittest(obj, numberOfSurvivors)
            obj=sort(obj,'ascend');
            obj.pointerToLastOldChromosome=numberOfSurvivors;
            obj.pointerToNewChromosome=numberOfSurvivors+1;
        end
    end
end