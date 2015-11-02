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

function [flist]=list_structure(directory)
flist = {};
files_folders = dir(directory);

%Go to subfolders
for (i=1:length(files_folders))
if isdir(files_folders(i).name) &&   ~strcmp(files_folders(i).name,'.')...
        && ~strcmp(files_folders(i).name,'..')
     bottom_list = list_structure(strcat(directory,'\',files_folders(i).name));
     if ~isempty(bottom_list)
      flist = [flist bottom_list ];
     end
end
%Add files in a folder to the list
if strcmp(files_folders(i).name(find(files_folders(i).name=='.',1,'last'):end),'.m')
   if exist('flist')
    flist(end+1) = cellstr(strcat(directory,'\',files_folders(i).name)); 
   else
    flist(1) = cellstr(strcat(directory,'\',files_folders(i).name));
   end
end
end
end