function [sol, historic] = own_pso(rapidSettings,func)
%%  OWN_PSO performs Particle Swarm Optimisation (with turbulence)
%  on the parameter identification problem specified in RAPIDSETTINGS.
%   
%   [SOL, HISTORIC] = OWN_PSO(RAPIDSETTINGS,FUNC)
%   performs the PSO using the settings in RAPIDSETTINGS and the function
%   FUNC which is a function that calculates the fitness of the parameters.
%
%   It starts by generating nb_particle particles . The initial particles 
%   are partly randomly chosen in parameter space, partly being regularly
%   spaced out within the bounds specified by p_min and p_max 
%   the objective function is evaluated at every iteration, whereupon each
%   particle is given a speed which depends on random parameters and 
%   1. the position of overall best solution found and 
%   2. the particle personal best position
%   The function returns in HISTORIC the history of best positions and best
%   fitness for every iteration of the process and solution SOL.
%
%   RAPIDSETTINGS: either, 1) an instance of the RaPIdClass 
%   or 2) a struct, both of which must contain fields as specified below.
%   In field/property psoSettings:
%       - w: inertia weight - scales the influence of the particles current
%           speed to it's future speed.
%       - self_coeff: self-recognition coefficient - scales the influence
%           particle's personal best position to the particle's speed
%       - social_coeff: social coefficient - scales the influence
%           of swarm's overall best position to the particle's speed.
%       - nb_particles: number of particles in the swarm
%   In field/property experimentSettings
%       - limit: number maximal of position updates
%       - fitnessStopRatio: stop PSO if fitness improves by this factor
%       - nRandMin: minimum of initial particles to be randomized,
%           see function generateOrganisedSwarm:
%       - p0: initial guess of vector of parameters
%       - saveHist: toggles storing all history in PSO (gets big very fast)
%
%   FUNC: a function to calculate the scalar fitness value for a vector of
%   parameters. See FUNC below for more info.
%
%   See also: RAPID, OWN_CFAPSO, FUNC, GENERATEORGANISEDSWARM, RAPIDCLASS

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

%% initialize settings
w = rapidSettings.psoSettings.w;
self_coeff = rapidSettings.psoSettings.self_coeff;
social_coeff = rapidSettings.psoSettings.social_coeff;
limit = rapidSettings.experimentSettings.maxIterations;
if rapidSettings.experimentSettings.saveHist %pre-allocate for speed
    bestfitness_history = zeros(limit,1); % pre-allocate vector (guesstimate size)
    bestparameters_history = zeros(limit,length(rapidSettings.experimentSettings.p_0)); % pre-allocate some array (guesstimate size)
    improved_at_iterations=bestfitness_history; % pre-allocate vector (guesstimate size)
end
debugging=0; % set to 1 for troubleshooting the code
bestfitness = func(rapidSettings.experimentSettings.p_0, rapidSettings); % calculate fitness for initial parameter guess
bestfitness_history(1)=bestfitness; % save fitness history
bestparameters=rapidSettings.experimentSettings.p_0; % best current parameters
bestparameters_history(1)=bestfitness; % save best parameter history
improved_at_iterations(1)=0;  % save at which iterations the fitness & best parameters were saved

%% Init the swarm: give positions to all particles
list = generateOrganisedSwarm( rapidSettings.psoSettings.nb_particles, rapidSettings.psoSettings.nRandMin,rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max,rapidSettings.experimentSettings.p_0);
for k = 1:size(list,1)
    swarm{k} = particle(rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max,list{k});
end
for k = size(list,1)+1:rapidSettings.psoSettings.nb_particles
    swarm{k} = particle(rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max,[]);
end
% we should modify this to include the possibility of having a grid along
% with the randomly drawn particles
try
    %% initialize the algorithm, set the best position and fitness to every particle
    % and to the overall best
    verbose=rapidSettings.experimentSettings.verbose; % used to decide if displaying progress
    for k = 1:length(swarm)
        if debugging&&mod(k,10)==0 % debug info display
            sprintf(strcat('init particle ',int2str(k),' in pso'));
        end
        fitness = func(swarm{k}.p, rapidSettings); % calculate fitness of particle k
        swarm{k} = swarm{k}.setBest(fitness); % save fitness in particle k
        if fitness < bestfitness % new best fitness?
            bestfitness = fitness; % update best fitness
            bestparameters = swarm{k}.p; % and corresponding parameters
            bestfitness_history(1) = bestfitness;
            if rapidSettings.experimentSettings.saveHist
                bestparameters_history(1,:) = bestparameters;
                improved_at_iterations(1) = 1;
            else
                improved_at_iterations = 0;
            end
            if verbose
                disp(['i = 0. Best parameters: ' num2str(bestparameters) ' with fitness = ' num2str(bestfitness)])
            end
        end
    end
    initial_fitness=bestfitness_history(1);
    target_fitness=initial_fitness*rapidSettings.psoSettings.fitnessStopRatio;
    %% Algorithm's main body
    for iteration=1:limit  
        if debugging&&mod(iteration,10) == 0 %info display if debugging
            sprintf(strcat('iteration ',int2str(iteration),' in pso body'));
        end
        
        for k = 1:length(swarm) % loop on all the particles of the swarm
            if debugging&&mod(k,10) == 0 % debug info display
                sprintf(strcat('particle ',int2str(iteration)));
            end
            swarm{k}.updateSpeed(w * rand * swarm{k}.v + self_coeff*rand(1,length(swarm{k}.p)).*(swarm{k}.bestPos - swarm{k}.p) + social_coeff*rand(1,length(swarm{k}.p)).*(bestparameters - swarm{k}.p)); % update the particle's speed
            if norm(swarm{k}.v) < norm(swarm{k}.v_max)*rapidSettings.psoSettings.kick_multiplier % kicks the particle when it's starting to get stuck (position converges)
                r = 2*rand(1,length(swarm{k}.p))-1;
                swarm{k}.updateSpeed((r + swarm{k}.v)*norm(swarm{k}.v_max)/norm(r+swarm{k}.v));
            end
            
            swarm{k}.updatePart(); % change the position according to the speed update and update best fitness and best position
            fitness = func(swarm{k}.p, rapidSettings); %calculate fitness
            swarm{k}.setBest(fitness);
            
            if fitness < bestfitness % new best fitness?
                bestparameters = swarm{k}.p;
                bestfitness = fitness;
                bestfitness_history(iteration) = bestfitness;
                if verbose
                    disp(['i = ' num2str(iteration) '. Best parameters: ' num2str(swarm{k}.p) ' with fitness = ' num2str(fitness)])
                end
                if rapidSettings.experimentSettings.saveHist
                    bestparameters_history(iteration,:) = bestparameters;
                    improved_at_iterations(iteration) = iteration;
                else
                    improved_at_iterations = iteration;
                end
            end
        end % end of looping through particles of the swarm
        if bestfitness <= target_fitness
            break;
        end
    end  % end of main iteration loop
catch err % error handling
    disp(err)
    % placeholder for any custom error handling that we might want to do in
    % the future, for now we just clear the error 
end
%% Finish and return results
if ~rapidSettings.experimentSettings.saveHist
    bestfitness_history=bestfitness;
    bestparameters_history=bestparameters;
end
sol = bestparameters;
historic.best_H = bestfitness_history;
historic.bestP_H = bestparameters_history;
historic.improvement_at_iterations=improved_at_iterations;
historic.swarm = swarm;
end



