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

function [sol,other]  = naive(RaPIdObject,func)
%NAIVE applies iteratively 1D gradient methods in n = card{vector of
%parameters} perpendicular directions until a certain fitness or a number
%of iterations is reached, the settings struct should contain:
%   - naive_options.tolerance1, minimal bound for the ratio
%   currentFitness/initialFitness, when this value is reached, the
%   algorithm stops
%   - naive_options.tolerance2, minimal bound for the ratio
%   currentFitness/initialFitness, when this value is reached, the
%   algorithm stops, second loop
%   - naive_options.iterations,2,3 number maximal of iterations for three
%   different levels of loops
%   - verbose, should be anything other than 0 only if debug info needs to
%   be displayed in console
other = [];

%NAIVE_ALGO
part = particle(RaPIdObject.experimentSettings.p_0,RaPIdObject.experimentSettings.p_0,RaPIdObject.experimentSettings.p_0);
part.p = RaPIdObject.experimentSettings.p_0;
part.fitness = func(part.p,RaPIdObject);
verbose=RaPIdObject.experimentSettings.verbose;
% while abs(initialFitness - particle.fitness) > settings.tolerance1
for k=1:RaPIdObject.naiveSettings.iterations3
    noSolutionYet = true;
    while noSolutionYet
        A=rand(length(part.p));
        
        B=A'*A ;
        [P,D] = eig(B); % P's columns are an orthonormal basis of the particle space
        if ((P'*P - eye(length(part.p)))>eps)
            % error, some vectors are not orthonormal, repeat the random matrix draw again
        else
            noSolutionYet = false;
        end
        P = eye(length(part.p));
    end
    % while abs(initialFitness - particle.fitness) > settings.tolerance1
    initialFitness = part.fitness;
    for l=1:RaPIdObject.naiveSettings.iterations2
        if verbose
        sprintf(strcat('outer ',int2str(l),'***************'))
        end
        for i = 1:length(part.p)
            
            fitnessForVector = inf;
            for j=1:RaPIdObject.naiveSettings.iterations
                if verbose
                sprintf(strcat('inner ',int2str(j)))
                end
                alpha = 1;
                fitnessPos = part.fitness;
                while alpha > RaPIdObject.naiveSettings.tolerance2
                    particle2 = part;
                    particle2.p = alpha*P(:,i)'+part.p;
                    particle2.fitness = func(particle2.p,RaPIdObject);
                    if part.fitness > particle2.fitness
                        part = particle2;
                    else
                        alpha = alpha/2;
                    end
                end
                alpha = -1;
                while abs(alpha) > RaPIdObject.naiveSettings.tolerance2
                    particle2 = part;
                    particle2.p = alpha*P(:,i)'+part.p;
                    particle2.fitness = func(particle2.p,RaPIdObject);
                    if part.fitness > particle2.fitness
                        part = particle2;
                    else
                        alpha = alpha/2;
                    end
                end
                fitnessForVector = part.fitness;
            end
        end
    end
    % end
    sol = part.p;
end






