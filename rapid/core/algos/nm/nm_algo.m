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

function [ sol, other] = nm_algo(RaPIdObject)
%NM_ALGO applies the FMINSEARCH matlab function to compute the minimum of
%the objective function defined by the parameter identification problem.
%   settings contain the fields:
%   	- p0, vector representing the initial guess for the vector of
%   	parameters
%       - nmOptions, a string which, when evaluated, provides an optimset
%       to be provided to FMINSEARCH, see the documentation for the
%       aforementioned function.
%       - verbose, verbose can be anything other than 0 if debuf info is
%       needed in console

options = eval(RaPIdObject.nmSettings);
options.MaxFunEvals=RaPIdObject.experimentSettings.nbMaxIterations;

[sol, other] = fminsearch(@func,RaPIdObject.experimentSettings.p_0,options);
%other = [];
if RaPIdObject.experimentSettings.verbose
    part.p = RaPIdObject.experimentSettings.p_0;
    [simuRes] = rapid_simuSystem( part,RaPIdObject);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction(RaPIdObject.experimentData.realData(i_s,k),simuRes(:,k),RaPIdObject,1);
    end
    other.beginning =fitness;
    part.p = sol;
    [simuRes] = rapid_simuSystem( part,RaPIdObject);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction(RaPIdObject.experimentData.realData(i_s,k),simuRes(:,k),RaPIdObject,1);
    end
    other.end = fitness;
end
end