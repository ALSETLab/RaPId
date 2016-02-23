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

function  list  = generateOrganisedSwarm( nbParticles, nminRand,p_min,p_max,p0s )
%GENERATEORGANISEDSWARM Create a list of particles to be given to the
%constructor of chromosome or particle (depends on the algorithm in use)
%   nbParticles: number total of particles to be created
%   nminRand: number minimal of particles that will have to be generated
%             randomly
%   p0s: particles that have to be in the list (they might come from
%   computations performed in other methods for example)
%   this means that we'll try to generate a grid of nbParticles - nminRand -p0s
%   regularly spaced particles in the parameter space
%   we'll try to have a "cubical grid", that is to say, the discretisation
%   of space will be the same on orthogonal directions (there are as
%   many points to the grid between p_min(1) and p_max(1) as between p_min(i)
%   and p_max(i))
%
list = {p0s};
n_a = floor(((nbParticles - nminRand)-size(p0s,1))^(1/length(p_min)));
if n_a > 1
    for i = 1:length(p_min)
        t{i} = p_min(i):(p_max(i)-p_min(i))/(n_a-1):p_max(i);
    end
    
    bulk = t{end}';
    for k = length(t)-1:-1:1
        bulk2 = [];
        for j = 1:n_a
            bulk2 = [bulk2;t{k}(j)*ones(n_a^(length(t)-k),1) bulk];
        end
        bulk = bulk2;
    end
    rndMat = rand(nbParticles-size(p0s,1)-n_a^length(p_min),length(p_min));
    list = num2cell([p0s;bulk]);%;rndMat.*repmat((p_max-p_min),size(rndMat,1),1) + repmat(p_min,size(rndMat,1),1)
end
end
