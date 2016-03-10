function res = rapid_ODEsolve(newParameters,rapidSettings)
%RAPID_ODESOLVE Function simulating the FMU by solving it using one of
%the ODE solvers of Matlab (without using Simulink).
%
%  RES = RAPID_ODESOLVE(PARAMETERVECTOR, RAPIDSETTINGS) outputs an array RES
%  given the PARAMETERVECTOR and the rapidSettings as inputs, where
%  RES: array of width == #outputs and height == #(interpolated) samples,
%  PARAMETERVECTOR is a vector of parameters, and
%  RAPIDSETTINGS is an instance of the RaPIdClass (or equivalent struct)
%
%   See also: FUNC, RAPID, RAPID_SIMUSYSTEM, RAPID_INTERPOLATE, RAPIDCLASS

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
persistent inputconf outconf postprocessing parameterNames options fmupath

if isempty(inputconf) % will run once
    if exist(rapidSettings.experimentSettings.pathToFmuModel,'file') % FMU exist on absolute path
        fmupath=rapidSettings.experimentSettings.pathToFmuModel;
    elseif ~exist(rapidSettings.experimentSettings.pathToFmuModel,'file') && exist(fullfile(evalin('base','pwd'),rapidSettings.experimentSettings.pathToFmuModel),'file') %FMU exist on relative path
        fmupath=fullfile(evalin('base','pwd'),rapidSettings.experimentSettings.pathToFmuModel);
    else
        error('FMU file could not be found!')
    end
    parameterNames=rapidSettings.parameterNames;
    options=odeset('MaxStep',10*rapidSettings.experimentSettings.ts,'RelTol', 1^-4,'Events',@(x)(disp('kek')) ); % just a temporary hack with ts
    T=timer('StartDelay',rapidSettings.experimentSettings.timeOut, 'Period', 10.0,'ExecutionMode','fixedSpacing','Tag','ODEtimeout','UserData',0);
    T.TimerFcn={@mycallback};
    outconf.name=rapidSettings.fmuOutputNames;
    outconf.toplevel = false; %disable standard model outputs to avoid duplicates
    if isprop(rapidSettings,'fmuInputNames') && iscell(rapidSettings.fmuInputNames)  % do we use inputs to the fmu?
        for k=1:length(rapidSettings.fmuInputNames)
            inputconf{k}.name=rapidSettings.fmuInputNames{k};
            inputconf{k}.vec=rapidSettings.experimentData.IndataMatrix(:,[1,k+1]); % this is the indata
        end
    else % no fmu inputs
        inputconf=[];
    end
    % Test anonymous function + compability work-around for old matlab & handle functions
    if ~isempty(rapidSettings.experimentSettings.outputPostProcessing)
        postprocessing=str2func(func2str(rapidSettings.experimentSettings.outputPostProcessing));
        try
            assert( all(size(postprocessing(ones(2,length(outconf))))==[2, size(rapidSettings.experimentData.referenceOutdata,2)]));
        catch err %not a good function - reset this
            disp(err);
            postprocessing=[]; %nothing
        end
    else
        postprocessing=[];
    end
end
fmu = loadFMU(fmupath,'Loglevel','warning');  % load fmu
maxInstantiateAttempts=5;  % limit the amounts of attempts to instantiate
for k=1:maxInstantiateAttempts
    try
        fmu.fmiInstantiateModel
        break;
    catch err
        pause(0.1); % wait 100 ms
    end
end
if ~fmu.isInstantiated
    rethrow(err);
end
for l = 1:length(newParameters)
    fmu.setValue(parameterNames{l},newParameters(l));
end

try %needs fixes!
    apa=fmu.fmiInitialize;
    start(T)
    tspan=0:rapidSettings.experimentSettings.ts:rapidSettings.experimentSettings.tf; % needs fixing
    [time,res,yname]=fmu.simulate([0 rapidSettings.experimentSettings.tf],'Output',outconf,'Input',inputconf,'Options',options,'Solver',rapidSettings.experimentSettings.integrationMethod);
    stop(T)
    if isempty(time)
        error('please make sure the To Workspace component in the simulink model outputs a struct with time')
    end
    if ~isempty(res) && ~isempty(postprocessing)
        res=postprocessing(res); % this is a user-defined function
    end    
    realTime=rapidSettings.experimentData.referenceTime;
    res = rapid_interpolate(time,res,realTime);
catch err
    if ~strcmp(err.message,'Simulation timed out')
        disp(err.message);
    end
    disp(err)
    res=[];
    return;
end
end
function mycallback(myTimerObj,thisEvent, varargin)
    set(myTimerObj,'UserData',myTimerObj.UserData+1);
    if rem(myTimerObj.UserData,9)==1
        disp(['FMU took more than ', num2str(myTimerObj.StartDelay+myTimerObj.TasksExecuted*myTimerObj.StartDelay),' sec. to simulate - total number of ' num2str(myTimerObj.UserData) ' time(s).'])
    end
end