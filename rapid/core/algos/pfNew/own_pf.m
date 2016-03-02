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

% function pf_track(Z,X,VERBOSE)
% Performs the particle filter tracking
% Inputs:
%           Z:          2xK
%           X:          2xK
%           VERBOSE:    1x1
% VERBOSE \in {0: no visual output, 1: information about end resutls, 2: shows particles}
function [ sol, historic,settings] = own_pf(settings,func) % excluded VERBOSE
%Parameter Initialization
%if nargin < 3; VERBOSE = 2; end;
%params.state_space_dimension = 3; % substitute with number of parameters
%params.Sigma_Q = diag([100 100]); % measurement noise covariance matrix
%params.M = 1000;
%settings.nbParticles=1000;
%params.motion_type = 2; %0=fixed, 1=linear, 2=circular
%params.v_0 = 2*pi*200/688;
%params.theta_0 = 0;
%params.omega_0 = 2*pi/688;
%params.state_space_bound = [640;480];
params.thresh_avg_likelihood = 0.0001; % to add into settings
RESAMPLE_METHOD = 1; % 0=vanilla resampling, 1=systematic resampling; % to add into settings
%switch params.state_space_dimension
    % case 2
       % params.Sigma_R = diag([2 2]); % process noise covariance matrix
       % if params.omega_0; error('2D state space can not use omega_0'); end;
    % case 3
        params.Sigma_R = diag([2 2 0.01]);
%end
dt = 1;
%%
% Variable Initialization
%close all;
% Initialise the particle space
list = generateOrganisedSwarm( settings.pf_options.nb_particles, settings.pf_options.nRandMin,settings.p_min,settings.p_max,settings.pf_options.p0s);

% S.X = [rand(1, params.M)*params.state_space_bound(1); % sampling uniformly from the state space
%      rand(1, params.M)*params.state_space_bound(2)];
% if params.state_space_dimension > 2
%     S.X = [S.X;rand(1, params.M)*2*pi - pi];
% end

S.W = 1/params.M * ones(1,params.M); % initialize equal weights 
%K = size(Z,2); % number of observations
%mean_S = zeros(2,K);
%figure(1);
%clf;
%%
% Particle Filter Algorithm
for i = 1 : K %end when
    %S_bar = pf_predict(S,params,dt); % the same role as parameters given to func to produce the fitness per each particle
    %z = Z(:,i); % measurements
    
    S_bar = pf_weight(S_bar,z,params); % also in the func
    switch RESAMPLE_METHOD
        case 0
            S = multinomial_resample(S_bar);
        case 1
            S = systematic_resample(S_bar);
    end
    mean_S(:,i) = mean(S.X(1:2,:),2); % compute the center of the distribution
%     if VERBOSE > 1
        plot(Z(1,i),Z(2,i),'rx','MarkerSize',10);
        hold on;
        plot(X(1,i),X(2,i),'go','MarkerSize',20);
        plot(S.X(1,:),S.X(2,:),'b.');
        hold off;
        axis([0 640 0 480]);
        title(sprintf('timestep %d of %d',i,K));
        drawnow;
%     end
end
%%
% Analyzing the estimates
err_z = sqrt(sum((Z - X).^2,1));
err_xhat = sqrt(sum((X - mean_S).^2,1));
merr_z = mean(err_z);
merr_xhat = mean(err_xhat);
stderr_z = std(err_z);
stderr_xhat = std(err_xhat);
format compact;
display(sprintf('absolute error analysis: measurements: %0.1f +- %0.1f, estimates: %0.1f +- %0.1f',merr_z,stderr_z, merr_xhat,stderr_xhat));
% if VERBOSE
    figure(3);
    clf;
    plot(err_z,'r-');
    hold on;
    plot(err_xhat,'b-');
    title(sprintf('absolute error analysis: measurements: %0.1f \\pm %0.1f, estimates: %0.1f \\pm %0.1f',merr_z,stderr_z, merr_xhat,stderr_xhat));
%     if VERBOSE > 1
%         figure(2);
%         visualize_vision_data(Z,X,mean_S);
%     end
% end
end

% function S = multinomial_resample(S_bar)
% Inputs:   
%           S_bar(t):       structure
% Outputs:
%           S(t):           structure
function S = multinomial_resample(S_bar)
cdf = cumsum(S_bar.W);
M = size(S_bar.X,2);
S.X = zeros(size(S_bar.X));
for m = 1 : M
    r_m = rand;
    i = find(cdf >= r_m,1,'first');
    S.X(:,m) = S_bar.X(:,i);
end
S.W = 1/M*ones(size(S_bar.W));
end

% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       structure
% Outputs:
%           S(t):           structure
function S = systematic_resample(S_bar)
cdf = cumsum(S_bar.W);
M = size(S_bar.X,2);
S.X = zeros(size(S_bar.X));
r_0 = rand / M;
for m = 1 : M
    i = find(cdf >= r_0,1,'first');
    S.X(:,m) = S_bar.X(:,i);
    r_0 = r_0 + 1/M;
end
S.W = 1/M*ones(size(S_bar.W));
end