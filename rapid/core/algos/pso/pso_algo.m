function [sol, historic] = pso_algo(rapidSettings)
%%PSO_ALGO function wrapper for Particle Swarm Optimization algorithms to
%	solve parameter identification problem specified.
%
%   [SOL, HISTORIC] = PSO_ALGO(RAPIDSETTINGS) carries out the PSO specified
%   in RAPIDSETTINGS and returns the best parameters in SOL and a history
%   of the particle swarm in HISTORIC.
%
%   RAPIDSETTINGS: either, 1) an instance of the RaPIdClass 
%   or 2) a struct with appropriate fields and structure. See OWN_PSO and
%   OWN_CFAPSO for more details.
%
%
%   See also: OWN_PSO, OWN_CFAPSO, RAPID, RAPIDCLASS

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
switch rapidSettings.psoSettings.method
    case 'CFA-PSO'
        [ sol, historic] = own_cfapso(rapidSettings,@func);
    case 'PSOPC'
        [ sol, historic] = own_psopc(rapidSettings,@func);
    case 'PSOCA'
        [ sol, historic] = own_psoca(rapidSettings,@func);
    otherwise
        [ sol, historic] = own_pso(rapidSettings,@func);
end
end






