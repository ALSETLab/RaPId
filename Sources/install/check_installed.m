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

%Load list of dependencies
load('dependancy_list.mat');

dep_inst = ver;
dep_inst = struct2cell(dep_inst);
check = false;
 
%List the dependencies (with -- not installed! if not installed)
disp('RaPId Toolbox dependancies are: ');
for (i=1:length(dep_list))
    if  ~sum(ismember(dep_inst(1,1,:),dep_list(i)))
        warning(strcat(dep_list{i},' -- not installed!'));
        check = check || true;
    else
        disp(strcat(dep_list{i}, ' -- OK !'));
    end
end

% Reminder in case one of the dependency is not installed
if check
    warning('Not all dependencies are installed, Keep this in mind if you receive error-messages while using RaPId.');
end
    
clear dep_inst dep_list i check