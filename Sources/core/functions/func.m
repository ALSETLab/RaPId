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

function fitness = func(p,RaPIdObject)
%FUNC Function computing the fitness of a vector of parameter
%   p: vector of parameter to be tested
%   fitness: fitness of the vector of parameters, calculated relatively to
%   an objective function
%   see: rapid_simuSystem and rapid_objectiveFunction
%   It requires the global variable settings_ to be declared before call to
%   this function (in the toolbox this declaration is done in rapid)
%   settings should contain all the appropriate parameters
%   in this function are used the parameters relative to the simulink model
%   settings should contain:
%       - Ts, sampling time (not meaningful if variable step method is chosen)
%       - tf, final time for the simulation
%       - intMethod, integration method (solver used)

global nbIterations;

if ~isempty(nbIterations) && (nbIterations > RaPIdObject.experimentSettings.maxIterations)
    %error('Toolbox stopped because we reached the max number of iteration, you can ignore the error message and continue');
end
switch RaPIdObject.experimentSettings.solverMode
    case 'ODE'
        [simuRes] = rapid_ODEsolve(p,RaPIdObject);
    case 'Simulink'
        [simuRes] = rapid_simuSystem(p,RaPIdObject);
    otherwise
        error('In "mySettings.mode": You must select either "ODE" (internal ODE-solvers) or "Simulink"');
end
if isempty(simuRes)
    fitness=1e66;
else
    fitness=rapid_objectiveFunction(RaPIdObject.experimentData.referenceOutdata,simuRes,RaPIdObject);
    if length(fitness) > 1
        error('problem with fitness size')
    end
end

end