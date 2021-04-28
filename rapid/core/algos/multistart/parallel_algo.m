function [ sol, other] = parallel_algo(rapidSettings)
%MULTISTART_ALGO applying fmincon to compute the minimum of the objective
%function defined by the parameter identification problem settings must
%contain the fields:
%       - settings.p0, initial guesses for the vector of parameters 
%       - settings.p_min, vector of minimum values for all parameters; 
%       - settings.p_max, vector of maximum values for all parameters; 
%       - settings.fminconOptions, string representing a command setting the
%       options for the matlab function fminunc, can consist of the
%       optimset function, please refer to doc fmincon.
%   Multistart utilizes multiple inputs for the initial guess and optimizes
%   based off the individual results of each fmincon routine for each
%   guess.

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
options = eval(rapidSettings.parallelSettings.parallel);
funcwrapper = @(x) func(x, rapidSettings);
tpoints = CustomStartPointSet(rapidSettings.experimentSettings.p_0);
ms = MultiStart('UseParallel',options.UseParallel);
problem = createOptimProblem(rapidSettings.parallelSettings.solver,'x0',rapidSettings.experimentSettings.p_0(1,:),...
          'objective',funcwrapper,'lb',rapidSettings.experimentSettings.p_min,'ub',rapidSettings.experimentSettings.p_max);
[sol,f] = run(ms,problem,tpoints)

other = [];
end


