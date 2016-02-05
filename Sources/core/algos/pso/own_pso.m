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

function [sol, historic] = own_pso(RaPIdObject,func)
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
%       - kick_multiplier: when the speed becomes lower than
%           norm(v_max)*kick_multiplier, v_max being the speed (computed
%           internally) which would lead the particle as far as possible
%           inside the space defined by p_min/p_max
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
w = RaPIdObject.psoSettings.w;
self_coeff = RaPIdObject.psoSettings.self_coeff;
social_coeff = RaPIdObject.psoSettings.social_coeff;
limit = RaPIdObject.experimentSettings.maxIterations;
if RaPIdObject.experimentSettings.saveHist %pre-allocate for speed
    bestfitness_history = zeros(limit,1); % pre-allocate vector (guesstimate size)
    bestparameters_history = zeros(limit,length(RaPIdObject.experimentSettings.p_0)); % pre-allocate some array (guesstimate size)
    improved_at_iterations=bestfitness_history; % pre-allocate vector (guesstimate size)
end
debugging=0; % set to 1 for troubleshooting the code
bestfitness = func(RaPIdObject.experimentSettings.p_0, RaPIdObject); % calculate fitness for initial parameter guess
bestfitness_history(1)=bestfitness; % save fitness history
bestparameters=RaPIdObject.experimentSettings.p_0; % best current parameters
bestparameters_history(1)=bestfitness; % save best parameter history
improved_at_iterations(1)=0;  % save at which iterations the fitness & best parameters were saved

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
    fitness = func(swarm{k}.p, RaPIdObject); % calculate fitness of particle k
    swarm{k} = swarm{k}.setBest(fitness); % save fitness in particle k
    if fitness < bestfitness % new best fitness?
        bestfitness = fitness; % update best fitness
        bestparameters = swarm{k}.p; % and corresponding parameters
        bestfitness_history(1) = bestfitness;
        if RaPIdObject.experimentSettings.saveHist
            bestparameters_history(1,:) = bestparameters;
            improved_at_iterations(1) = 1; 
        else
            improved_at_iterations = 1;
        end
        if verbose
            disp(['i = 1. Best parameters: ' num2str(bestparameters) ' with fitness = ' num2str(bestfitness)])
        end
    end
end
iteration = 1;
initial_fitness=bestfitness_history(1);
%% Algorithm's main body
while iteration <= limit && bestfitness >= initial_fitness*RaPIdObject.psoSettings.fitnessStopRatio % speed update loop
    if debugging&&mod(iteration,10) == 0 % debug info display
        sprintf(strcat('iteration ',int2str(iteration),' in pso body'));
    end
    
    for k = 1:length(swarm) % loop on all the particles of the swarm
        if debugging&&mod(k,10) == 0 % debug info display
            sprintf(strcat('particle ',int2str(iteration)));
        end
        swarm{k}.v = w * rand * swarm{k}.v + self_coeff*rand(1,length(swarm{k}.p)).*(swarm{k}.bestPos - swarm{k}.p) + social_coeff*rand(1,length(swarm{k}.p)).*(bestparameters - swarm{k}.p); % update the particle's speed
        if norm(swarm{k}.v) < norm(swarm{k}.v_max)*RaPIdObject.psoSettings.kick_multiplier % kicks the particle when it's starting to get stuck (position converges)
            r = 2*rand(1,length(swarm{k}.p))-1;
            swarm{k}.v = (r + swarm{k}.v)*norm(swarm{k}.v_max)/norm(r+swarm{k}.v);
        end
        
        swarm{k} = swarm{k}.updatePart(); % change the position according to the speed update and update best fitness and best position
        fitness = func(swarm{k}.p, RaPIdObject); %calculate fitness
        swarm{k}.setBest(fitness);
        
        if fitness < bestfitness % new best fitness?
            bestparameters = swarm{k}.p;
            bestfitness = fitness;
            bestfitness_history(iteration) = bestfitness;
            if verbose
                disp(['i = ' num2str(iteration) '. Best parameters: ' num2str(swarm{k}.p) ' with fitness = ' num2str(fitness)])
            end            
            if RaPIdObject.experimentSettings.saveHist
                bestparameters_history(iteration,:) = bestparameters;
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
    bestfitness_history=bestfitness;
    bestparameters_history=bestparameters;
end
sol = bestparameters;
historic.best_H = bestfitness_history;
historic.bestP_H = bestparameters_history;
historic.improvement_at_iterations=improved_at_iterations;
historic.swarm = swarm;
end



