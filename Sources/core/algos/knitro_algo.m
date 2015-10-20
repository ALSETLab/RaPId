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

function [ sol, other] = knitro_algo(RaPIdObject)
%KNITRO_ALGO applies the ktrlink function from the KNITRO toolbox to
%compute the minimum of the objective function defined by the parameter
%identification problem
%   settings must have as a fields:
%   - p0, vector containing an initial guess for the vector of parameters
%   - p_min, vector containing the minimal values acceptable for every
%   parameter of the parametere vector
%   - p_min, vector containing the maximal values acceptable for every
%   parameter of the parametere vector
%   - kn_options.knOptions, a string containing a command allowing the
%   specification of the optimset for the function KTRLINK, please refer to
%   the documentation of this function (can be left empty)
%   - kn_options.knOptionsFile, a string containing the path to a
%   configuration file for KTRLINK, see the doc of the so-called functions
%   for more details, needs to be left empty if not used
%   - verbose, if verbose is anything else than zero, the algorithm will
%   save some information and output it in second output argument (used for
%   debugging)
options = eval(RaPIdObject.knitroSettings.knOptions);
if isempty(RaPIdObject.knitroSettings.knOptionsFile)&&isempty(options)
    sol = ktrlink(@func,RaPIdObject.experimentSettings.p_0,[],[],[],[],RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max);
elseif isempty(RaPIdObject.knitroSettings.knOptionsFile)
    sol = ktrlink(@func,RaPIdObject.experimentSettings.p_0,[],[],[],[],RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,[],options);
else
    str  = RaPIdObject.knitroSettings.knOptionsFile;
    sol = ktrlink(@func,RaPIdObject.experimentSettings.p_0,[],[],[],[],RaPIdObject.experimentSettings.p_min,RaPIdObject.experimentSettings.p_max,[],options,str );
end
% storage of historic data
if RaPIdObject.experimentSettings.verbose
    part.p = RaPIdObject.experimentSettings.p_0;
    [simuRes] = rapid_simuSystem( part,RaPIdObject);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction2(RaPIdObject.experimentData.realData(i_s,k),simuRes(:,k),RaPIdObject,1);
    end
    other.beginning =fitness;
    part.p = sol;
    [simuRes] = rapid_simuSystem( part,RaPIdObject);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction2(RaPIdObject.experimentData.realData(i_s,k),simuRes(:,k),RaPIdObject,1);
    end
    other.end = fitness;
end
end