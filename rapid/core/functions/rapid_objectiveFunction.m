function fitness = rapid_objectiveFunction(referenceResults,simulatedResults,rapidSettings)
%RAPID_OBJECTIVEFUNCTION computes a fitness according to a fitness criterion
%   FITNESS=RAPID_OBJECTIVEFUNCTION(REFERENCERESULTS,SIMULATEDRESULTS, RAPIDSETTINGS)
%   calculates the FITNESS as the similarity between REFERENCERESULTS 
%   and SIMULATEDRESULT.  Where
%   FITNESS: a scalar value
%   REFERENCERESULTS: array of width == #signals and height == # amples,
%   SIMULATEDESULTS: array of the same size as REFERENCERESULTS
%   RAPIDSETTINGS: an instance of the RaPIdClass (or an equivalent structure)
%
% See also: FUNC, RAPID, RAPID_INTERPOLATE, RAPIDCLASS
      
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

assert(all(size(simulatedResults)==size(referenceResults)),'The size of reference and simulation data is not the same.')
delta = abs(referenceResults-simulatedResults);   

%% Calculate similarity according to different criteria
switch rapidSettings.experimentSettings.cost_type
    % Add your case here and set the rapidSettings accordingly if you
    % want to compute the fitness function differently.
    case 1, % something
       fitness = sum(sum(delta.*delta))   
    case 2,
       weights = rapidSettings.experimentSettings.objective_weights;
       fitness=sum(sum(delta.*delta*weights)); 
    case 3, % Frobenius 
       fitness = sqrt(sum(sum(delta.*delta))); 
    otherwise
        error('Non-existing cost type!');
end

%% Check that it is a valid fitness value
if (isnan(fitness))
    disp(delta(isnan(delta.*delta)))
    error('Something went wrong when calculating the fitness, check the vectors supplied to the objective function');
end
end



