function [ sol, other ] = ga_algo(rapidSettings)
%GA_ALGO applying OWN_GA to compute the minimum of the objective
%function defined by the parameter identification problem
%   settings.ga_options must contain the fields:
%       - nbCromosomes, number of chromosome (vectors of parameters) for
%       every iterations
%       - nbCroossOver1,2, number of crossover operations applied to the
%       chromosomes
%       - nbMutations, number of mutation operations applied to the
%       chromosomes
%       - nbReproduction, number of reproduction operations applied to the
%       chromosomes
%       - limit, number of iteration to the process of the Genetic
%       Algorithm
%       - fitnessStopRatio, minimal ration currentFitness/intial_Fitness,
%       if the ratio becomes lower than this real number, the algorithm
%       exits
%       - headSize1,2,3, number of chromosomes involved respectivelly in
%       the crossovers1/2 and mutations
%       - nbReinjection, number of random chromosomes that are kept alive
%       even if not performing well
%       - nRandMin, minimum of initial particles to be generated
%       randomly, restricts the number of particles to be set on a grid
%       regularly spaced out in the parameter space, see the function
%       GenerateOrganisedSwarm
%       - p0s, matrix whose rows are different initial guesses for the
%       vector of parameters
%       - storeData, boolean allowing to store all the best fitness and
%       particles at every iterations (get's big very quickly)

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
%%
[ sol, other] = own_ga(rapidSettings,@func);
end


