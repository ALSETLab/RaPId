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

function fitness = rapid_objectiveFunction(referenceResults,simulatedResults,RaPIdObject, modes)
%RAPID_OBJECTIVEFUNCTION computes a fitness according to a fitness criterion
%   realRes is data used for matching, from measurments
%   simuRes is the data we want to have matching realRes
%   the two of them are under the shape [[x[1];y[1]] [x[2];y[2]] ... [x[nStep];y[nStep]]]
%
%   settings has to contain the fields
%       cost: integer, for quadratic cost the value is 2
%       objective: struct adapted to the method chosen
%           if cost = 2, objective contains the field:
%               vect: nb_parameters*nb_parameters weight matrix, should take
%               into account the respective outputs scaling
% This function should never be called, the function FUNC does all the job
% for you
% --------> See the help for FUNC
      
   % simuResvector = rapid_interpolate(realTime,simuTime,simuRes); % here we perform the interpolation
    % interpolation is need since in most cases the measured output signals
    % and the simulated output signals weren't sampled at the same sampling instants.
    % after interpolation simuRes contains the simulated output evaluated
    % at the same time instant as settings.realTime  
if nargin < 4
   modes = 0;
end

assert(all(size(simulatedResults)==size(referenceResults)),'The size of reference and simulation data is not the same.')

delta = abs(referenceResults-simulatedResults);   
switch RaPIdObject.experimentSettings.cost_type
    % Add your case here and set the RaPIdObject accordingly if you
    % want to compute the fitness function differently.
    case 1, % norm 2 error cost function
       fitness = sum(sum(delta.*delta));   
    case 2,
       weights = RaPIdObject.experimentSettings.objective_weights;
       fitness=sum(sum(delta.*delta*weights));
    case 3 % small signal analysis
       weights = RaPIdObject.experimentSettings.objective_weights;
       TDfitness=sum(sum(delta.*delta*weights)); 
       
       refmode=RaPIdObject.ReferenceMode;
       if ~isreal(refmode)
           SSfitness=abs(modes-refmode);
       else
           error('Referent mode is not a complex number');  
       end
       
       TDweight=RaPIdObject.experimentSettings.TDweight;
       SSweight=RaPIdObject.experimentSettings.SSweight;
       
       fitness=TDweight*TDfitness + SSweight*SSfitness;
       fprintf('fitness : %15.9f \n' , fitness);
       fprintf('\n');
    
       
    otherwise
        errorWrongCost
end
if (isnan(fitness))
    disp(delta(isnan(delta.*delta)))
    error('Something went wrong when calculating the fitness, check the vectors supplied to the objective function');
end
end



