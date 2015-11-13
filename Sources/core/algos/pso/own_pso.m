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
%       - alpha1: multiplier on the contribution of the last sample of the
%            particle's speed to it's next sample
%       - alpha2: multiplier on the contribution of the distance to the
%           particle's personal best position to the next sample of
%           the speed
%       - alpha3: multiplier on the contribution of the distance to the swarm's
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
alpha1 = RaPIdObject.psoSettings.alpha1;
alpha2 = RaPIdObject.psoSettings.alpha2;
alpha3 = RaPIdObject.psoSettings.alpha3;
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
k=2; % pointer in history arrays
%% Init the swarm: give positions to all particles
list = generateOrganisedSwarm( RaPIdObject.psoSettings.nb_particles, RaPIdObject.psoSettings.nRandMin,RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,RaPIdObject.experimentSettings.p_0);
for i = 1:size(list,1)
    swarm{i} = particle(RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,list{i});
end
for i = size(list,1)+1:RaPIdObject.psoSettings.nb_particles
    swarm{i} = particle(RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,[]);
end
% we should modify this to include the possibility of having a grid along
% with the randomly drawn particles

%% init the algorithm, set the best position and fitness to every particle
% and to the overall best
verbose=RaPIdObject.experimentSettings.verbose; % used to decide if displaying progress
for i = 1:length(swarm)
    if debugging&&mod(i,10)==0 % debug info display
        sprintf(strcat('init particle ',int2str(i),' in pso'));
    end
    fitness = func(swarm{i}.p, RaPIdObject); % calculate fitness of particle i
    swarm{i} = swarm{i}.setBest(fitness); % save fitness in particle i
    if fitness < bestfitness % new best fitness?
        bestfitness = fitness; % update best fitness
        bestparameters = swarm{i}.p; % and corresponding parameters
        bestfitness_history(k) = bestfitness;
        if RaPIdObject.experimentSettings.saveHist
            bestparameters_history(k,:) = bestparameters;
            improved_at_iterations(k) = 1; 
        else
            improved_at_iterations = 1;
        end
        if verbose
            disp(['i = 1. Best parameters: ' num2str(bestparameters) ' with fitness = ' num2str(bestfitness)])
        end
        %k=k+1;
    end
end
iteration = 2;
initial_fitness=bestfitness_history(2);
%% Algorithm's main body
while iteration <= limit && bestfitness >= initial_fitness*RaPIdObject.psoSettings.fitnessStopRatio % speed update loop
    k=k+1;
    if debugging&&mod(iteration,10) == 0 % debug info display
        sprintf(strcat('iteration ',int2str(iteration),' in pso body'));
    end
    for i = 1:length(swarm) % loop on all the particles of the swarm
        if debugging&&mod(i,10) == 0 % debug info display
            sprintf(strcat('particle ',int2str(iteration)));
        end
        swarm{i}.v = alpha1 * rand * swarm{i}.v + alpha2*rand(1,length(swarm{i}.p)).*(swarm{i}.bestPos - swarm{i}.p) + alpha3*rand(1,length(swarm{i}.p)).*(bestparameters - swarm{i}.p); % update of the particle's speed
        if norm(swarm{i}.v) < norm(swarm{i}.v_max)*RaPIdObject.psoSettings.kick_multiplier % kicks the particle when it's starting to get stuck (position converges)
            r = 2*rand(1,length(swarm{i}.p))-1;
            swarm{i}.v = (r + swarm{i}.v)*norm(swarm{i}.v_max)/norm(r+swarm{i}.v);
        end
        swarm{i} = swarm{i}.updatePart(); % change the position according to the speed update and update best fitness and best position
        fitness = func(swarm{i}.p, RaPIdObject); %calculate fitness
        if fitness < swarm{i}.bestValue
            swarm{i}.bestPos = swarm{i}.p;
            swarm{i}.bestValue = fitness;
            %swarm{i}.setBest(fitness);
        end
        if fitness < bestfitness % new best fitness?
            bestparameters = swarm{i}.p;
            bestfitness = fitness;
            bestfitness_history(k) = bestfitness;
            if verbose
                disp(['i = ' num2str(iteration) '. Best parameters: ' num2str(swarm{i}.p) ' with fitness = ' num2str(fitness)])
            end            
            if RaPIdObject.experimentSettings.saveHist
                bestparameters_history(k,:) = bestparameters;
                improved_at_iterations(k) = iteration;
                
%                 if ~is(Best_H(worst_pointer))
%                     worst_pointer=max(bestfitness_history((bestfitness_history(1:k)<1e66)));
%                 end
            else
                improved_at_iterations = iteration;
            end
            
        end
    end % end of looping through particles of the swam
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



