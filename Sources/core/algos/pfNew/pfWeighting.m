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

function [weights,fitness] = pfWeighting(RaPIdObject,particles,func)

% mean = [1 1];
% sigma = 0.6;
% cum_sum=0;
weights = zeros(length(particles(:,1)),1);
fitness=zeros(length(particles(:,1)),1);
for k=1:length(fitness)
    fitness(k) = func(particles(k,:),RaPIdObject);  % dangerous since func could possibly leave []
%   diff = particles(i,:)-mean;
% 	sq_diff = diff*diff';
% 	weights = [weights; 1/sqrt(2*pi*sigma^2)*exp(-sq_diff/(2*sigma^2))];
end

cum_sum=sum(fitness);

for k=1:length(fitness)
    weights(k)=1-(fitness(k)/cum_sum);
end



	