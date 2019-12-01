function [ sol, other] = fmincon_algo(rapidSettings)
%FMINCON_ALGO applying fmincon to compute the minimum of the objective
%function defined by the parameter identification problem settings must
%contain the fields:
%       - settings.p0, initial guess for the vector of parameters 
%       - settings.p_min, vector of minimum values for all parameters; 
%       - settings.p_max, vector of maximum values for all parameters; 
%       - settings.fminconOptions, string representing a command setting the
%       options for the matlab function fminunc, can consist of the
%       optimset function, please refer to doc fmincon

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
options = eval(rapidSettings.fminconSettings);
funcwrapper = @(x) func(x, rapidSettings);

if isempty(options)
    sol = fmincon(funcwrapper,rapidSettings.experimentSettings.p_0,[],[],[],[],rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max);
else
    sol = fmincon(funcwrapper,rapidSettings.experimentSettings.p_0,[],[],[],[],rapidSettings.experimentSettings.p_min,rapidSettings.experimentSettings.p_max,[],options);
end
other = [];
%print sol
end


