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

%% Main script for running RaPiD without a GUI
% To prepare the parameter estimation of your own model, copy first the
% simulink model contained in myTest (resp. myTestIO), load the appropriate
% *.fmu file and adapt the model where required (number of output/number
% of input)
% To use the toolbox in command line, change the parameters given in this
% script and run it.
% Change first the parameters relative to your system itself in the first
% then change the parameters of the different identification methods
% The usage and functionality of every parameter is disscussed in the user
% manual.

%% Print out the copyright statement on launch
type('copyright_statement')
%% Global Settings (independant of the method chosen)
[containerFile, pathname] = uigetfile('*.mat','Choose your container file');
load(strcat(pathname,containerFile));
oldFolder = cd(pathname);
contentOfContainer=who('-file',strcat(pathname,containerFile));
if any(strcmp(contentOfContainer,'mySettings'))
        try
            RaPIdObject=RaPIdClass(mySettings);
            disp('Converted old container to new, please save this new container');
        catch err
            disp(err.message)
        end
end

% We can either use Simulink or Matlab's ODE solver directly.
switch RaPIdObject.experimentSettings.solverMode
    case 'ODE'
        
    case 'Simulink'
        
end
RaPIdObject.experimentSettings.solverMode='ODE';
%% This part contains example of settings that can changed at will if needed
ChangeLoadedSettings=0;
if ChangeLoadedSettings
    switch RaPIdObject.experimentSettings.optimizationAlgorithm
        case 'pso'
            pso_options.alpha1 = 0.5/(0.5+1+0.8);
            pso_options.alpha2 = 1/(0.5+1+0.8);
            pso_options.alpha3 = 0.8/(0.5+1+0.8);
            pso_options.fitnessStopRatio = 1e-5;
            pso_options.kick_multiplier = 2e-3;
            pso_options.nb_particles = 5;
            pso_options.limit = psoSettings.nbMaxIterations/pso_options.nb_particles;
            pso_options.nRandMin = 2;
            pso_options.p0s = psoSettings.p0;
            pso_options.storeData = 0;
            RaPIdObject.psoSettings = pso_options;
        case 'ga'
            ga_options.nbCromosomes = 40;
            ga_options.nRandMin = 3;
            ga_options.p0s = [];
            ga_options.nbCroossOver1 = 10;
            ga_options.nbCroossOver2 = 10;
            ga_options.nbMutations = 30;
            ga_options.nbReproduction = ceil(ga_options.nbCromosomes/4);
            ga_options.limit = 10;
            ga_options.fitnessStopRatio = 1e-5;
            ga_options.headSize1 = ceil(ga_options.nbCroossOver1/2);
            ga_options.headSize2 = ceil(ga_options.nbCroossOver1/2);
            ga_options.headSize3 = ceil(ga_options.nbMutations/3);
            ga_options.nbReinjection = 5;
            ga_options.storeData = 0;
            RaPIdObject.gaSettings = ga_options;
        case 'naive'
            naive_options.tolerance1 = 1e-4;
            naive_options.tolerance2 = 1e-7;
            naive_options.iterations = 2;
            naive_options.iterations2 = 2;
            naive_options.iterations3 = 2;

            RaPIdObject.naiveSettings = naive_options;
        case 'fmincon'
            RaPIdObject.fminconSettings = 'optimset(''FinDiffRelStep'',0.1)';
        case 'cg'
            RaPIdObject.cgSettings = 'optimset(optimset(''fminunc''),''FinDiffType'',''central'',''TolX'',1e-6,''LargeScale'',''off'')';
        case 'nm'
            RaPIdObject.nmSettings = 'optimset(''fminsearch'')';
        case 'pf'
            pf_options.nb_particles = 10;
            pf_options.nb_iterations = 2;
            pf_options.prune_threshold = 0.2;
            pf_options.kernel_sigma = 0.5;
            pf_options.storeData = 0;
            RaPIdObject.pfSettings = pf_options;
        case 'combi'
            RaPIdObject.combiSettings.firstMethod = 'pf';
            RaPIdObject.combiSettings.secondMethod = 'naive';
        case 'psoExt'
            addpath(genpath(strcat(getPathToRapid,'\psopt'))); % change this path if needed
            RaPIdObject.psoExtSettings = 'optimset(psooptimset,''TolFun'',1e-2)';
        case 'gaExt'
            RaPIdObject.gaExtSettings = 'gaoptimset';
        case 'knitro'
            RaPIdObject.knitroSettings.path2Knitro = 'P:\Program Files\Ziena\knitro';
            RaPIdObject.experimentSettings.p_0 = [0.35 0.4];
            RaPIdObject.knitroSettings.knOptions = 'optimset(''Algorithm'',''interior-point'')';
            RaPIdObject.knitroSettings.knOptionsFile = [];
    end
end
% run the computation
tic
[sol, hist] = rapid(RaPIdObject);
toc
sprintf('vector of parameter found:')
sol
hist