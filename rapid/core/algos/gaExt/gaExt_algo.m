function [ sol, other] = gaExt_algo(rapidSettings)
%GAEXT_ALGO applying matlab ga function to compute the minimum of the 
% objective function defined by the parameter identification problem
% settings must contain:
%     - p0, initial guess for the value of the parameter vector
%     - p_min, vector containing the minimal values of all parameters
%     - p_max, vector containing the maximal values of all parameters
%     - gaExtOptions, string containing a command providing an optimset for
%       the matlab ga function, see the doc for the ga function

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
%     options = psooptimset();
%        ga(@rastr,2,                  [],[],[],[],[],            [],[],options)
%     sol = ga(@func,length(settings.p0),[],[],[],[],settings.p_min,settings.p_max);
options = eval(rapidSettings.gaExtOptions);
sol = ga(@(x)func(x,rapidSettings),length(rapidSettings.experimentSettings.p_0),[],[],[],[],rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max,[],options);
other = [];
if rapidSettings.experimentSettings.verbose
    part.p = rapidSettings.experimentSettings.p_0;
    [simuRes] = rapid_simuSystem( part,rapidSettings);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction(rapidSettings.experimentData.realData(i_s,k),simuRes(:,k),rapidSettings,1);
    end
    other.beginning =fitness;
    part.p = sol;
    [simuRes] = rapid_simuSystem( part,rapidSettings);
    for k=1:size(simuRes,2)
        fitness=fitness+rapid_objectiveFunction(rapidSettings.experimentData.realData(i_s,k),simuRes(:,k),rapidSettings,1);
    end
    other.end = fitness;
end
end