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

function [sol,other]  = naive_algo(RaPIdObject)
%NAIVE_ALGO applies iteratively 1D gradient methods in n = card{vector of
%parameters} perpendicular directions until a certain fitness or a number
%of iterations is reached, the settings struct should contain:
%   - naive_options.tolerance1, minimal bound for the ratio
%   currentFitness/initialFitness, when this value is reached, the
%   algorithm stops
%   - naive_options.tolerance2, minimal bound for the ratio
%   currentFitness/initialFitness, when this value is reached, the
%   algorithm stops, second loop
%   - naive_options.iterations,2,3 number maximal of iterations for three
%   different levels of loops
%   - verbose, should be anything other than 0 only if debug info needs to
%   be displayed in console
    [sol,other] = naive(RaPIdObject, @func);
end






