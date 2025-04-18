function fitness = func(p,rapidSettings)
%% FUNC computes the fitness of a vector of parameters by simulation in RaPId
%   FITNESS = FUNC(P, rapidSettings) gives the scalar FITNESS where
%   P: vector of parameters to be tested
%   FITNESS: the calculated fitness after simulating with the parameters
%   RAPIDSETTINGS: an instance of the RaPIdClass (or the correct, equivalent structure)
%
%   RAPIDSETTINGS should contain all the appropriate parameters in
%   its properties (or fields).
%   Look below in the functions below for which parameters are necessary:
% See also: rapid_simuSystem, rapid_objectiveFunction, rapid_interpolate, rapid_ODEsolve 


%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
% Copyright 2015-2016 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
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

switch lower(rapidSettings.experimentSettings.solverMode)
    case 'ode'
        [simuRes] = rapid_ODEsolve(p,rapidSettings);
    case 'simulink'
        [simuRes] = rapid_simuSystem(p,rapidSettings);
    case 'simulink_parallel'
        [simuRes] = rapid_simuSystem_parallel(p,rapidSettings);
    otherwise
        error('In "mySettings.mode": You must select either "ODE" (internal ODE-solvers) or "Simulink"');
end
if isempty(simuRes)
    fitness=1e66;
else
    fitness=rapid_objectiveFunction(rapidSettings.experimentData.referenceOutdata,simuRes,rapidSettings);
    if length(fitness) > 1
        error('problem with fitness size')
    end
end

end