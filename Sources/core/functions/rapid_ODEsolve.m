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

function [res] = rapid_ODEsolve(newParameters,RaPIdObject)
%RAPID_SIMUSYSTEM Function simulating the FMU by solving it using one of
%the ODE solvers of Matlab.
%
% The settings struct must include:
%   parameterNames: cell of strings with all the names of the parameters
%       ordered in a way agreeing to the the parameter vector part.p
%   
%   blockName: string containing the name of the FMU_ME block in the
%   simulink model
%   scopeName: name of the variable created by the to workspace object
%   blockName: name of the FMUme block preceded of the simulink model name
%   and of the character "/", example: 'variable/FMUme'
%   scopeName: name of the variable created by a "To Workspace" component
%   in the simulink model. The To Workspace component must be set to
%   generate a structure with time and takes as an input a vector (from a
%   mux) containing all outputs.
% This function should never be called, the function FUNC does all the job
% for you
% --------> See the help for FUNC
persistent inputconf outconf

if isempty(inputconf)
    if isprop(RaPIdObject,'fmuInputNames') && iscell(RaPIdObject.fmuInputNames)
        for k=1:length(RaPIdObject.fmuInputNames)
        inputconf{k}.name=RaPIdObject.fmuInputNames{k};
        inputconf{k}.vec=RaPIdObject.experimentData.IndataMatrix(:,[1,k+1]);
        end
        outconf.name=RaPIdObject.fmuOutputNames;
    else
        inputconf=[];
    end
end

if exist(RaPIdObject.experimentSettings.pathToFmuModel,'file') % FMU exist on absolute path
    fmu = FMUModelME1(RaPIdObject.experimentSettings.pathToFmuModel,'Loglevel','warning'); % or change to loadFMU?
elseif ~exist(RaPIdObject.experimentSettings.pathToFmuModel,'file') && exist(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToFmuModel),'file') %FMU exist on relative path
    fmu = FMUModelME1(fullfile(evalin('base','pwd'),RaPIdObject.experimentSettings.pathToFmuModel),'Loglevel','warning'); % or change to loadFMU?
else
    error('FMU file could not be found!')
end

parameterNames=RaPIdObject.parameterNames;
maxInstantiateAttempts=1;
timeouts=1;
if ~fmu.isInstantiated
   for k=1:maxInstantiateAttempts
    try
        fmu.fmiInstantiateModel
        break;
    catch err
        %disp(err.message)
        %pause(timeouts)
    end
   end
   if ~fmu.isInstantiated
       tmp=fmu.fmupath;
       try
          % clearvars('fmu');
           pause(timeouts)
           fmu=[];    
           fmu=FMUModelME1(tmp);
           fmu.fmiInstantiateModel;
       catch err
           disp('Error while trying to create new fmu?');
           disp(err);
           
       end
   end
end
for l = 1:length(newParameters)
    fmu.setValue(parameterNames{l},newParameters(l));
end
% simulate the system, this is done in the base-workspace 


try %needs fixes!
    apa=fmu.fmiInitialize;
    tspan=0:RaPIdObject.experimentSettings.ts:RaPIdObject.experimentSettings.tf; % needs fixing
    options=odeset('MaxStep',10*RaPIdObject.experimentSettings.ts,'RelTol', 1^-4 ); % just a temporary hack with ts
    [time,res,yname]=fmu.simulate([0 RaPIdObject.experimentSettings.tf],'Output',outconf,'Input',inputconf,'Options',options,'Solver',RaPIdObject.experimentSettings.integrationMethod);
    fmu=[];
    if ~isempty(res)
        res=RaPIdObject.experimentSettings.outputPostProcessing(res); % this is a user-defined function
    end
    if isempty(time)
        error('please make sure the To Workspace component in the simulink model outputs a struct with time')
    end
    %% Do something with res here!
    realTime=RaPIdObject.experimentData.referenceTime;
    res = rapid_interpolate(time,res,realTime);
catch err
    if ~strcmp(err.message,'Simulation timed out')
        disp(err.message);
    end
    disp(err) %%%%%%% WHY 2 DISPLAYS? -Ravi
    %disp(err)
    res=[];
    return;
end
end
