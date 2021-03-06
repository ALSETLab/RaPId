function res = rapid_simuSystem_parallel(parameterVector,rapidSettings)
%RAPID_SIMUSYSTEM simulates a Simulink model in the RaPId Toolbox given the  
%  parameters.
%
%  RES = RAPID_SIMUSYSTEM(PARAMETERVECTOR, RAPIDSETTINGS) outputs an array RES
%  given the arguments PARAMETERVECTOR and RAPIDSETTINGS, where
%  RES: array of width == #outputs and height == #(interpolated) samples,
%  PARAMETERVECTOR is a vector of parameters, and
%  RAPIDSETTINGS is an instance of the RaPIdClass (or equivalent struct)
%  
% See also: FUNC, RAPID, RAPID_ODESOLVE, RAPID_INTERPOLATE, RAPIDCLASS

%% <Rapid Parameter Identification is a toolbox for automated parameter identification>
%
% Copyright 2016-2015 Luigi Vanfretti, Achour Amazouz, Maxime Baudette, 
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

%% Setup Simulink simulation parameters (run once)
persistent timeOut
if isempty(timeOut)
    configSet = getActiveConfigSet(rapidSettings.experimentSettings.modelName);
    set_param(configSet,'SaveOutput','on');
    set_param(configSet,'OutputSaveName','simout');
    set_param(configSet,'StartTime','0');
    set_param(configSet,'StopTime',num2str(rapidSettings.experimentSettings.tf));
    set_param(configSet,'Solver',rapidSettings.experimentSettings.integrationMethod);
    timeOut=rapidSettings.experimentSettings.timeOut;
    set_param(configSet,'RelTol',num2str(1e-3));
    switch lower(get_param(configSet,'SolverType'))
        case 'variable-step' 
               if rapidSettings.experimentSettings.ts > 0 %OK
                    set_param(configSet,'OutputOption','SpecifiedOutputTimes');
                    set_param(configSet,'OutputTimes', strcat('[0:',num2str(rapidSettings.experimentSettings.ts),':',num2str(rapidSettings.experimentSettings.tf),']'));
               else
                   disp('Using relative tolerance to produce output')
               end      
        otherwise
            if rapidSettings.experimentSettings.ts > 0
                set_param(configSet,'FixedStep',num2str(rapidSettings.experimentSettings.ts));
            else
               warning('No valid time step selected, output will get 100 intervals')
               set_param(configSet,'FixedStep',num2str(rapidSettings.experimentSettings.tf/100));
            end   
    end
end
debugging=0; % uncomment for troubleshooting
%% Set parameter inside model
parameterName = rapidSettings.parameterNames;
for l = 1:length(parameterVector)
    fmuSetValueSimulink(rapidSettings.experimentSettings.blockName,parameterName{l},num2str(parameterVector(l))); % set FMU-block parameters
end
%% Try to simulate while catching possible errors

try
    
        [stuff,output]=evalc('sim(rapidSettings.experimentSettings.modelName,''TimeOut'',timeOut);'); %simulate using capture
        if debugging
            disp(stuff);
        end
        tmp=get(output,'simout'); %retrieve signals
        res=tmp.signals.values;
        time=tmp.time;
    
catch err  %process errors
    disp(err)
    disp(err.message)
    if strcmp(err.identifier,'Simulink:Commands:SimTimeExceededTimeOut')
        res=[];
        return;
    elseif strcmp(err.identifier,'Simulink:SFunctions:SFcnErrorStatus')
        res=[];
        return;
    elseif strcmp(err.identifier,'Simulink:Engine:SolverNonlIterMinStepErr')
        res=[];
        return;  
    elseif strcmp(err.identifier,'Simulink:Engine:SolverConsecutiveZCNum')
        res=[];
        return;
    elseif strcmp(err.identifier,'Simulink:Commands:SimAborted')
        error('RaPId:AbortRaPId','User command: Abort simulations.');
    else
        disp(err.identifier);
        res=[];
        return;
    end
end
if isempty(time)  %if we an empty vector 'time' and still got here we will throw an error
    error('Make sure the To Workspace component in the simulink model outputs a struct with time')
end
%% Finally, interpolate to referenceTime
res = rapid_interpolate(time,res,rapidSettings.experimentData.referenceTime);
end
