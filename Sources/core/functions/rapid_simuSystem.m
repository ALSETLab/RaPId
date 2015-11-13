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

function [res] = rapid_simuSystem(newParameters,RaPIdObject)
%RAPID_SIMUSYSTEM Function simulating the simulink model using the values
%for the parameter vector given as input
%  part: particle or chromosome, any kind of object having for field p, a
%  vector of parameters of appropriate size settings: settings struct used
%  everywhere in RaPId res: matrix whose columns are outputs of the
%  simulink model The simulink model should contain a FMI_ME block loaded
%  with the appropriate *.fmu file and with the appropriate variables
%  selected as outputs
%
% The settings struct must include:
%	path2simulinkModel: path to... simulink model
%   modelName: sumulink model name without ".mdl"
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
global nbIterations
persistent paramStruct

if isempty(paramStruct)
    paramStruct.SaveOutput='on';
    paramStruct.OutputSaveName='simout';
    paramStruct.StartTime='0';
    paramStruct.FixedStep=num2str(RaPIdObject.experimentSettings.ts);
    paramStruct.FixedStep='auto';
    paramStruct.StopTime=num2str(RaPIdObject.experimentSettings.tf);
    paramStruct.Solver=RaPIdObject.experimentSettings.integrationMethod;
    paramStruct.TimeOut=RaPIdObject.experimentSettings.timeOut;
    paramStruct.RelTol=num2str(1e-3);
end
debugging=0; % will use this for troubleshooting
parameterName = RaPIdObject.parameterNames;
for l = 1:length(newParameters)
    fmuSetValueSimulink(RaPIdObject.experimentSettings.blockName,parameterName{l},num2str(newParameters(l))); % set FMU-block parameters
end

try
%   output=sim(settings.modelName,'SaveOutput','on','OutputSaveName','simout','StartTime','0','FixedStep',num2str(settings.Ts),'StopTime',num2str(settings.tf),'Solver',settings.intMethod,'TimeOut',10, 'LoadExternalInput', 'on','ExternalInput', '[settings.realTime settings.realData]');
    [stuff,output]=evalc('sim(RaPIdObject.experimentSettings.modelName,paramStruct);');
    if debugging
        disp(stuff);
    end
    tmp=get(output,'simout');
    res=tmp.signals.values;
    time=tmp.time;
catch err
    if strcmp(err.identifier,'Simulink:Commands:SimTimeExceededTimeOut')
        res=[];
        return;
    elseif strcmp(err.identifier,'Simulink:SFunctions:SFcnErrorStatus')
        res=[];
        return;
        
    else
        disp(err.identifier);
        res=[];
        return;
    end
    %disp(err.message);
    %rethrow(err);
end

if isempty(time)
    error('Make sure the To Workspace component in the simulink model outputs a struct with time')
end
res = rapid_interpolate(time,res,RaPIdObject.experimentData.referenceTime);
nbIterations = nbIterations + 1; % debug variable, how many times was the system simulated...
end