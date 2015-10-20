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

%% Script For Initializing the Toolbox for the first time on a Computer
% Make sure this file is in the RaPId Toolbox folder
%
addpath(fullfile(fileparts(mfilename('fullpath'))));
addpath(fullfile(fileparts(mfilename('fullpath')), 'gui'));
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), 'core')));
savepath
if isempty(ver('FMItoolbox'))
    warning('FMI toolbox does not seem to be installed! Keep this in mind if you receive error-messages while using RaPId.')
end
 
run_rapid_gui