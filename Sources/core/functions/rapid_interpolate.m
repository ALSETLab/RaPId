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

function interpolatedData = rapid_interpolate(simulationTime,simulationData, referenceTime)
%RAPID_INTERPOLATE generates an interpolation of the simulated data at the
%instants found in the reference measurements. This allows direct comparison of the
%measured data with the simulated data.
% 
%   Assume everything is in column form
assert(iscolumn(simulationTime),'The time of the simulation is not a column vector.')
assert(size(simulationData,1)==length(simulationTime),'The simulated outdata is not in column form.')
    
interpolatedData=zeros(length(referenceTime),size(simulationData,2)); %pre-allocate

for k = 1:size(simulationData,2)
    [simulationTime,i_s] = unique(simulationTime);
    try
        interpolatedData(:,k)=interp1(simulationTime,simulationData(i_s,k),referenceTime)';
    catch err
        disp('error in interpolate, some debug info:')
        disp(err)
        size(referenceTime)
        size(simulationTime)
        rethrow(err);
    end
end
end