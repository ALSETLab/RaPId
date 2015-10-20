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

function [res,fitness,settings] = rapid_ODEsolve( part,settings )
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
global fmu
res=[];
if ~fmu.isInstantiated
    fmu.fmiInstantiateModel;
    fmu.fmiSetDebugLogging(true)
end
T=timer('StartDelay',10, 'Period', 10.0,'ExecutionMode','singleShot');
T.TimerFcn={@mycallback,T};
cleanupObj = onCleanup(@()mycleanupfunc(T));
for l = 1:length(part.p)
    parameterName = settings.parameterNames(l);
    p = part.p(l);
    fmu.setValue(parameterName,p);
end
% simulate the system, this is done in the workspace of rapid.m where the
% simulation settings were defineds
outconf.name=settings.fmuOutData;
try
    start(T)
    fmu.fmiInitialize;
fmu.getValue(parameterName);
tspan=[0:settings.Ts*20:settings.tf];
options=odeset('MaxStep',settings.Ts*20,'RelTol', 1^-3 );
time=[];
[time,yout,yname]=fmu.simulate(tspan,'Output',outconf,'Options',options);
stop(T)


if isempty(time)
    error('please make sure the To Workspace component in the simulink model outputs a struct with time')
end

res(:,1)=yout(:,1);
res(:,2)=yout(:,2);
res(:,3)=yout(:,3);
res(:,4)=yout(:,4);
res(:,5)=yout(:,5);
res(:,6)=yout(:,6);
res(:,7)=yout(:,7);
res(:,8)=yout(:,8);

% res(:,7)=yout(:,7).*yout(:,9)+yout(:,8).*yout(:,10);
% res(:,8)=yout(:,8).*yout(:,9)-yout(:,7).*yout(:,10);

% res(:,1)=yout(:,1).*yout(:,3)+yout(:,2).*yout(:,4);
% res(:,2)=yout(:,2).*yout(:,3)-yout(:,1).*yout(:,4);
% res(:,3)=sqrt(yout(:,5).^2 +yout(:,6).^2);
% res(:,4)=sqrt(yout(:,7).^2 +yout(:,8).^2);

simuTime=time';
settings.lastSimu.res = res';
fitness=0;
realRes=settings.realData;
realTime=settings.realTime;
k = find(realTime>=settings.t0_fitness,1); % we remove the samples preceding the time t0_fitness, these first samples ain't taken into account in the computation of the fitness
realRes = realRes(:,k:end);
realTime = realTime(:,k:end);
l=find(simuTime>=settings.t0_fitness,1);
simuRes = res(:,l:end)';
simuTime = simuTime(:,l:end);


if (simuTime(end)<realTime(end))
    realTime=realTime(1:find(simuTime<realTime(end),1,'last')-1);
    'truncate realdata so that t_end "matches"'
    realRes=realRes(:,1:length(realTime));
end
for i=1:size(simuRes,1)
%      disp(['size of real time v ', num2str(size(realTime))])
%       disp(['size of simu time v ', num2str(size(simuTime))])
%       disp(['size of simu data ', num2str(size(simuRes(i,:)))])
    intpl8res = rapid_interpolate(simuTime,simuRes(i,:),realTime);
%     disp(['size of interpolated data ', num2str(size(intpl8res))])
    fitness=fitness+rapid_objectiveFunction2(realRes(i,:),intpl8res,settings,i);
end
%disp(['Parameter vector ' num2str(part.p) ' gives fitness = ' num2str(fitness)])

settings.lastSimu.time = simuTime;
settings.nbIterations = settings.nbIterations + 1; % debug variable, how many times was the system simulated...


catch err
    if ~strcmp(err.message,'Simulation timed out')
    disp(err.message);
    end
    if fmu.isInstantiated
        try 
            fmu.fmiFreeModelInstance;
        catch err1
        end
    end   
    stop(T);

    res=[];
    fitness=1e66;
    return;
end
if fmu.isInstantiated
    fmu.fmiFreeModelInstance;
end

end
function mycallback(varargin)
    global fmu
    obj=varargin{1};
    if nargin >= 3
        T=varargin{3};
    else
        T=obj;
    end
    strcmp(obj.Name,T.Name)
    nargin
    stop(obj)
    c=(clock);
    if fmu.isInstantiated
        disp([num2str(c(4)) ':' num2str(c(5)) ':' num2str(c(6)) ': Simulation timed-out?'])
        warning('off', 'FMIT:MEX:CallfmiTerminate');
        output=fmu.fmi_terminate();
        disp(num2str(output))
        warning('on', 'FMIT:MEX:CallfmiTerminate');
        fmu.fmiFreeModelInstance;
        fmu.fmi_error('something');
    %error('Simulation timed out');
    end
end
function mycleanupfunc(T,varargin)
 if ~isempty(T)
    stop(T)
    delete(T)
 end
end
