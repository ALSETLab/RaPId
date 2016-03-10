function [sol, historic] = pfNew(rapidSettings,func)
% PFNEW description TODO

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

%%
min_value=rapidSettings.experimentSettings.p_min; %min_value = [0, 0];
max_value=rapidSettings.experimentSettings.p_max; %max_value = [2, 2];
num_params = length(rapidSettings.experimentSettings.p_min); %2;

num_epochs = rapidSettings.experimentSettings.maxIterations; %10;
if isempty(rapidSettings.pfSettings)
    rapidSettings.pfSettings.nb_particles=100;
    rapidSettings.pfSettings.prune_threshold=0.1;
    rapidSettings.pfSettings.kernel_sigma=1;
    
end
num_particles = rapidSettings.pfSettings.nb_particles; %100;
threshold = rapidSettings.pfSettings.prune_threshold; %0.1;
sigma = rapidSettings.pfSettings.kernel_sigma; %1;
max_tries=10000;


if rapidSettings.experimentSettings.saveHist
    particles_H=zeros(num_epoch*num_particles, num_params);
end

figure_handle=figure;

particles=zeros(num_particles,num_params);
particles(1,:)=rapidSettings.experimentSettings.p_0;
for k=2:num_params
    particles(:,num_params) = unifrnd(min_value(k), max_value(k), num_particles, 1);
end

% particles
figure(figure_handle);
plot_handle=plot(particles(:,1), particles(:,2), 'x');

set(plot_handle,'YDataSource','particles(:,2)')
set(plot_handle,'XDataSource','particles(:,1)')
drawnow();
refreshdata(plot_handle, 'caller')


%Start iterating

for epoch=1:num_epochs
    
    %Weight particles

    [weights,~] = pfWeighting(rapidSettings,particles, func);

    % Prune particles

    surviving_inds = (weights > (min(weights) + (1-threshold)*(max(weights)-min(weights))));
    survivedParticles = particles(surviving_inds,:);
    survivedWeights = weights(surviving_inds);
    num_particles_remaining=sum(surviving_inds);
    
    % Resampling
    
    newParticles = [survivedParticles; zeros(num_particles-num_particles_remaining,num_params)];
    counter=0;
    while num_particles_remaining < num_particles 
        counter=counter+1;
        randomParticle = generateRandomParticle(min_value, max_value);
        probParticle = gaussianKernelProbability(randomParticle, survivedParticles, sigma);
        if isempty(survivedWeights) || (unifrnd(0, max(survivedWeights)) < probParticle) || counter >= max_tries  % dont want to have infinity loops
            num_particles_remaining=num_particles_remaining+1;
            newParticles(num_particles_remaining,:) = randomParticle;
        end
    end
    

    
    if rapidSettings.experimentSettings.saveHist
        particles_H(((epoch-1)*num_particles + 1:num_particles ),num_params) = newParticles;
    end
    
    particles = newParticles;
    refreshdata(plot_handle, 'caller')
    drawnow()
    
end

%Define the best particle

[weights,fitness] = pfWeighting(rapidSettings,particles,func);

[~, I] = sort(weights, 'descend');

sol=particles(I(1), :);
%'Best particle:\n'
disp(fitness(I(1), :));
historic.particles_H=particles_H;

end