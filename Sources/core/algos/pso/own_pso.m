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
best = 1e66;
bestP = [];

best = func(RaPIdObject.experimentSettings.p_0, RaPIdObject);
bestP=RaPIdObject.experimentSettings.p_0;
fit_store=[0;best];
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
iteration = 2;
%% init the algorithm, set the best position and fitness to every particle
% and to the overall best
verbose=RaPIdObject.experimentSettings.verbose;
for i = 1:length(swarm)
    % debug info display
    if verbose&&mod(i,10)==0
        sprintf(strcat('init particle ',int2str(i),' in pso'));
    end
    fitness = func(swarm{i}.p, RaPIdObject);
    swarm{i} = swarm{i}.setBest(fitness);
    if fitness < best
        best = fitness;
        bestP = swarm{i}.p;
        fit_store(1,1)=1;
        fit_store(2,1)=fitness;
    end
end
best_H = [best];
bestP_H = [bestP];
disp(['i = 1. Best parameters: ' num2str(bestP) ' with fitness = ' num2str(best)])
worst_pointer=1;
%% Algorithm's body
% speed update loop
while iteration <= limit&&best_H(end) >= best_H(worst_pointer)*RaPIdObject.psoSettings.fitnessStopRatio
    % debug info display
    if verbose&&mod(iteration,10) == 0
        sprintf(strcat('iteration ',int2str(iteration),' in pso body'));
    end
    % loop on all the particles of the swarm
    for i = 1:length(swarm)
        % debug info display
        if verbose&&mod(i,10) == 0
            sprintf(strcat('particle ',int2str(iteration)));
        end
        % update of the particle's speed
        swarm{i}.v = alpha1 * rand * swarm{i}.v + alpha2*rand(1,length(swarm{i}.p)).*(swarm{i}.bestPos - swarm{i}.p) + alpha3*rand(1,length(swarm{i}.p)).*(bestP - swarm{i}.p);
        % kicks the particle when it's starting to get stuck (position converges)
        if norm(swarm{i}.v) < norm(swarm{i}.v_max)*RaPIdObject.psoSettings.kick_multiplier
            r = 2*rand(1,length(swarm{i}.p))-1;
            swarm{i}.v = (r + swarm{i}.v)*norm(swarm{i}.v_max)/norm(r+swarm{i}.v);
        end
        % change the position according to the speed update and update best
        % fitness and best position
        swarm{i} = swarm{i}.updatePart();
        fitness = func(swarm{i}.p, RaPIdObject);
        if fitness < swarm{i}.bestValue
            swarm{i}.bestPos = swarm{i}.p;
            swarm{i}.bestValue = fitness;
            %swarm{i}.setBest(fitness);
        end
        if fitness < best
            disp(['i = ' num2str(iteration) '. Best parameters: ' num2str(swarm{i}.p) ' with fitness = ' num2str(fitness)])
            bestP = swarm{i}.p;
            best = fitness;
            fit_store([1,2],end+1)=[iteration*RaPIdObject.psoSettings.nb_particles + i;fitness];  
        end
        
    end
    iteration = iteration + 1;
   
    if RaPIdObject.experimentSettings.saveHist
        best_H = [best_H; best];
        bestP_H = [bestP_H; bestP];
        if ~isfinite(Best_H(worst_pointer))
            worst_pointer=max(best_H(isfinite(best_H)));
        end
    end
end
if ~RaPIdObject.experimentSettings.saveHist
    best_H=best;
    bestP_H=bestP;
end
sol = bestP;
historic.best_H = best_H;
historic.bestP_H = bestP_H;
historic.swarm = swarm;
historic.fit_store=fit_store;
end



