function setupRapid
%% SETUPRAPID installs the RaPId Toolbox for the first time on a Computer
% Make sure this file is not moved from the rapid-folder inside your copy
% of the RaPID Toolbox.

% Copyright 2015-2016 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
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
addpath(fullfile(fileparts(mfilename('fullpath'))));
addpath(fullfile(fileparts(mfilename('fullpath')), 'gui'));
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), 'core')));
savepath
pathToHere=fileparts(mfilename('fullpath'));
% Check of RaPId dependencies
run([pathToHere '\install\check_installed.m'])
disp('======= Running the test example =======');
try
    run([pathToHere '\install\run_example'])
catch msg_error
    disp(' /!\ Something went wrong in the example /!\');
    throwAsCaller(msg_error);
end
% End of setup, run the GUI
runRapidGui();
end