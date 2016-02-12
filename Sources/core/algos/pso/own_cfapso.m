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

function [sol, historic] = own_cfapso(RaPIdObject,func)
%OWN_PSO Applies the particle swar optimisation function OWN_PSO and
%applies it to the parameter identification problem specified.
%   Takes as argument the settings struct in which the data to be matched
%   by the parameter estimation was integrated by the function rapid.m It
%   starts by generating nb_particle particles (value set in
%   settings.pso_options). The initial particles are partly randomlu chosen
%   and partly spans the parameter space, being regularly spaced out within
%   the bounds specified by p_min and p_max the objective function is
%   evaluated at every iterations, after each has been given a speed which
%   is determined by random parameters and influenced by the position of
%   the overall best solution found and the particle personal best position
%   The function returns the historic of all the best position and best
%   fitness at every iteration of the process and the swarm at final time
%   if required.
%
%   settings should include a struct field name pso_options containing:
%       - w: inertia weight - multiplier on the contribution of the last sample of the
%            particle's speed to it's next sample
%       - self_coeff: self-recognition coefficient - multiplier on the contribution of the distance to the
%           particle's personal best position to the next sample of
%           the speed
%       - social_coeff: social coefficient - multiplier on the contribution of the distance to the swarm's
%           overall best position to the next sample of the speed
%       - limit: number maximal of iterations in the speeds updates
%       - fitnessStopRatio: the algorithm stops if the best fitness reaches
%           initialFitness*fitnessStopRatio
%       - nb_particles: number of particles in the swarm
%       - nRandMin, minimum of initial particles to be generated
%       randomly, restricts the number of particles to be set on a grid
%       regularly spaced out in the parameter space, see function
%       generateOrganisedSwarm
%       - p0s, matrix whose rows are different initial guesses for the
%       vector of parameters
%       - saveHist, boolean allowing to store all the best fitness and
%       particles at every iterations (get's big very quickly)

global nbIterations
nbIterations=0;
wmin = RaPIdObject.psoSettings.w_min;
wmax = RaPIdObject.psoSettings.w_max;
self_coeff = RaPIdObject.psoSettings.self_coeff;
social_coeff = RaPIdObject.psoSettings.social_coeff;
limit = RaPIdObject.experimentSettings.maxIterations;
if RaPIdObject.experimentSettings.saveHist %pre-allocate for speed
    bestfitness_history = zeros(limit,1); % pre-allocate vector (guesstimate size)
    bestparameters_history = zeros(limit,length(RaPIdObject.experimentSettings.p_0)); % pre-allocate some array (guesstimate size)
    improved_at_iterations=bestfitness_history; % pre-allocate vector (guesstimate size)
end
debugging=0; % set to 1 for troubleshooting the code
globalBestFit = func(RaPIdObject.experimentSettings.p_0, RaPIdObject); % calculate fitness for initial parameter guess
bestfitness_history(1)=globalBestFit; % save fitness history
globalBestPos=RaPIdObject.experimentSettings.p_0; % best current parameters
bestparameters_history(1)=globalBestFit; % save best parameter history
improved_at_iterations(1)=0;  % save at which iterations the fitness & best parameters were saved

if social_coeff+self_coeff <4 %the acceleration coefficients should be over 4 too guarantee stability
   self_coeff=1.55+rand;  %random number between 1.55 and 2.55
   social_coeff=4.1-self_coeff; %number between 1.55 and 2.55  
end
phi=social_coeff+self_coeff;    
constriction=2/(2-phi-sqrt(phi^2 - 4*phi));   %constriction factor 
%% Init the swarm: give positions to all particles
list = generateOrganisedSwarm( RaPIdObject.psoSettings.nb_particles, RaPIdObject.psoSettings.nRandMin,RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,RaPIdObject.experimentSettings.p_0);
for k = 1:size(list,1)
    swarm{k} = particle(RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,list{k});
end
for k = size(list,1)+1:RaPIdObject.psoSettings.nb_particles
    swarm{k} = particle(RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,[]);
end
% we should modify this to include the possibility of having a grid along
% with the randomly drawn particles

%% initialize the algorithm, set the best position and fitness to every particle
% and to the overall best
verbose=RaPIdObject.experimentSettings.verbose; % used to decide if displaying progress
for k = 1:length(swarm)
    if debugging&&mod(k,10)==0 % debug info display
        sprintf(strcat('init particle ',int2str(k),' in pso'));
    end
    fitness = func(swarm{k}.p, RaPIdObject); % calculate fitness of particle i
    swarm{k} = swarm{k}.setBest(fitness); % save fitness in particle i
    if fitness < globalBestFit % new best fitness?
        globalBestFit = fitness; % update best fitness
        globalBestPos = swarm{k}.p; % and corresponding parameters
        bestfitness_history(1) = globalBestFit;
        if RaPIdObject.experimentSettings.saveHist
            bestparameters_history(1,:) = globalBestPos;
            improved_at_iterations(1) = 1; 
        else
            improved_at_iterations = 1;
        end
        if verbose
            disp(['i = 1. Best parameters: ' num2str(globalBestPos) ' with fitness = ' num2str(globalBestFit)])
        end
    end
end
iteration = 1;
initial_fitness=bestfitness_history(2);
%% Algorithm's main body
while iteration <= limit && globalBestFit >= initial_fitness*RaPIdObject.psoSettings.fitnessStopRatio % speed update loop
    if debugging&&mod(iteration,10) == 0 % debug info display
        sprintf(strcat('iteration ',int2str(iteration),' in pso body'));
    end
    wt=wmax-(wmax-wmin)*iteration/limit;
    length(swarm);
    for k = 1:length(swarm) % loop on all the particles of the swarm
        if debugging&&mod(k,10) == 0 % debug info display
            sprintf(strcat('particle ',int2str(iteration)));
        end
        swarm{k}.updateSpeed(constriction*(wt * swarm{k}.v + self_coeff*rand*(swarm{k}.bestPos - swarm{k}.p) + social_coeff*rand*(globalBestPos - swarm{k}.p))); % update the particle's speed
        swarm{k}.updatePart(); % change the position according to the speed update and update best fitness and best position
        fitness = func(swarm{k}.p, RaPIdObject); %calculate fitness
        swarm{k}.setBest(fitness); % Check if new best for particle
        if fitness < globalBestFit % new best fitness?
            globalBestPos = swarm{k}.p;
            globalBestFit = fitness;
            bestfitness_history(iteration) = globalBestFit;
            if verbose
                disp(['i = ' num2str(iteration) '. Best parameters: ' num2str(swarm{k}.p) ' with fitness = ' num2str(fitness)])
            end            
            if RaPIdObject.experimentSettings.saveHist
                bestparameters_history(iteration,:) = globalBestPos;
                improved_at_iterations(iteration) = iteration;
            else
                improved_at_iterations = iteration;
            end
        end
        
    end % end of looping through particles of the swarm
    iteration = iteration + 1;
end  % end of main iteration loop
%% Finish and return results
if ~RaPIdObject.experimentSettings.saveHist
    bestfitness_history=globalBestFit;
    bestparameters_history=globalBestPos;
end
sol = globalBestPos;
historic.best_H = bestfitness_history;
historic.bestP_H = bestparameters_history;
historic.improvement_at_iterations=improved_at_iterations;
historic.swarm = swarm;
end



