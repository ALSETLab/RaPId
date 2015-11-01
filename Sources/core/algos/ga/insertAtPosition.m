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

function [ list, cell ] = insertAtPosition( list, cell, index )
%INSERTATPOSITION insert the index of the element number index at the
% correct position in a list ordering the chromosomes by increasing fitness
% /!\ to test more thoroughly...
% list, list already existant of sorted particles
% cell, struct containing the whole mass of particles
% index, index in the cell of the particle we would like to add to the
% list
if isempty(list)
    list = index;
else
    for i = 1:length(list)           
        if cell{list(i)}.fitness >= cell{index}.fitness
            list = [list(1:i-1) index list(i:end)];
            break;
        end
        if i == length(list)
            list = [list index];
        end
    end
end

end

