function interpolatedData = rapid_interpolate(simulationTime,simulationData,referenceTime)
%RAPID_INTERPOLATE interpolate and return simulated output data at reference time instants
% in RaPId Toolbox.
%
%	INTERPOLATEDDATA = RAPID_INTERPOLATE(SIMULATIONTIME,SIMULATIONDATA,REFERENCETIME)
%   where
%   INTERPOLATEDDATA: array of width == #outputs and height == length of REFERENCETIME,
%   SIMULATIONTIME: time vector of length == height of SIMULATIONDATA
%   SIMULATIONDATA: array of width == #outputs and height == length of SIMULATIONTIME,
%   REFERENCETIME: time vector of instants to where SIMULATIONDATA should
%   be interpolated to.
%
%   This allows direct comparison of the measured data with the simulated data.
% 
%	See Also: RAPID, RAPID_SIMUSYSTEM, RAPID_ODESOLVE, INTERP1 

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

%% Pre-process data
assert(iscolumn(simulationTime),'The time of the simulation is not a column vector.')
assert(size(simulationData,1)==length(simulationTime),'The simulated outdata is not in column form.')  
interpolatedData=zeros(length(referenceTime),size(simulationData,2)); %pre-allocate
k=find(simulationTime>=referenceTime(1),1,'first');
simulationTime=simulationTime(k:end);
simulationData=simulationData(k:end,:);
[simulationTime,i_s] = unique(simulationTime);

%% Interpolate each signal
for k = 1:size(simulationData,2)
    try
        interpolatedData(:,k)=interp1(simulationTime,simulationData(i_s,k),referenceTime)';
    catch err
        disp('error in interpolate, some debug info:')
        disp(err)
        rethrow(err);
    end
end

end