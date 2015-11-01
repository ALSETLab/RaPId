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

classdef Chromosome < matlab.mixin.Copyable
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
        %% Constructor
        % constructor generating the initial position randomly
        function obj = Chromosome(pmin,pmax,p, varargin)
            if nargin ==0
                % Allow initalization of chromosome-arrays
            else
                obj = Chromosome;
                %assert(isempty(p) || iscell(p),'Starting position must be given as cell-array')
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
            end
        end            
        %%  Set specified Genes
        function genes = getGenes(obj,geneList)
            genes = obj.p(geneList);
        end        % change its own genes
        %% Get specified Genes
        function obj = setGenes(obj,genesToCross,genes)
            obj.p(genesToCross) = genes;
            obj.fitness=Inf;
        end
        %% Get random Genes
        function [genesToCross,genes] = getRandomGenes(obj)
            nb_exchange = ceil((obj.n-1)*rand(1,1));
            ls = randperm(obj.n);
            genesToCross = ls(1:nb_exchange);
            genes = obj.p(genesToCross);
        end
    end
end

