function [modes ] = SmallSignalPerformance(p, RaPIdObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
parameterNames=RaPIdObject.parameterNames;
% parameterNames{1}='G2_bus5400.sEXS.TB';
% parameterNames{2}='G1_bus7000.gENROU.H';

CriticalMode=abs(RaPIdObject.ReferenceMode);

%-------------------Calling Dymola for Linear Analysis----------------
% dymolaPath=RaPIdObject.DymolaPath;
% dymolaModelName=RaPIdObject.DymolaModelName;
% 
% for i=1:length(p)
%     dymola([parameterNames{i} '=' num2str(p(i))]);
% end
% fprintf('parameter: %15.9f    ;'   , p(1));
% 
% if (all(dymolaModelName ~='IEEE_14_Buses.mo'))
%     dymola(['Modelica_LinearSystems2.ModelAnalysis.Poles("iPSL.' dymolaModelName '")']);
% else
%     %dymola( 'cd("C:/Users/vperic/Documents/iTesla_RaPId_fork/Examples/IEEE14/iPSL")');
%     dymola('Modelica_LinearSystems2.ModelAnalysis.Poles("iPSL.Examples.IEEE_14_Buses")');
% end
% 
% load( [dymolaPath 'dslin.mat'])
% [Wn,zeta,P]=damp(ABCD);
% [C,I] = min(abs(Wn-CriticalMode));
% modes=P(I);
%---------------------------------------------------------------------

%-------------Using Matlab Function for Linear Analysis---------------

%-------------Method 1 DoE---------------
params=[];  % new set of parameters given by the algo (name could be changed)
param_names = cell(1,length(p)); 
param_types = cell(1,length(p));
exp_setup = cell(length(p),1); %dummy experiment setup (required to create the 'OPTIONS' structure)
 for l = 1:length(p)
      params(l)=p(l); 
      exp_setup{l}.name=RaPIdObject.parameterNames{1,l};
      exp_setup{l}.type='FMUParameter';
      exp_setup{l}.dist = 'constant'; %constant so that FMUDoESetup doesnt create a testmatrix using different values for the params.
      exp_setup{l}.value = p(l);
      param_names{1,l} =RaPIdObject.parameterNames{1,l};
      param_types{1,l} ='FMUParameter';
 end
OPTIONS=struct('mode','initial','Tmax','10','linearize','on','solver',RaPIdObject.experimentSettings.integrationMethod); %initial settings
%mode:initial so that linearization happens at the initial point.  But openning
%of line or fault can't be taken into account this way
DOE_SETUP = FMUDoESetup(RaPIdObject.experimentSettings.pathToFmuModel,exp_setup,OPTIONS);
DOE_SETUP.options.mode='initial'; % Linearizes at initial point.
DOE_SETUP.options.Tmax='10';
DOE_SETUP.options.Tmax=RaPIdObject.experimentSettings.integrationMethod; % solver choice
test_matrix = params; % single point because both the params were chosen constant.
 try
    result = DOE_SETUP.custom(test_matrix,param_names,param_types);
    A=result.linsys.sys{1,1}.a;
    [Wn,zeta,P]=damp(A);
    [C,I] = min(abs(Wn-CriticalMode));
    modes=P(I);
 catch ME
     disp(ME.message)
     disp('setting modes = 0 for this iteration')
     modes=0; 
 end
%-------------Method 2 DoE---------------


% fmu_obj = FMUModelME1(RaPIdObject.experimentSettings.pathToFmuModel,'Loglevel','warning');
% fmu_obj.fmiInstantiateModel();
% fmu_obj.fmiInitialize;
%  for l = 1:length(p)
%      fmu_obj.setValue(parameterNames{l},p(l));
%  end
% %disp(parameterNames{1}); %%% Ravi delete this
% new_value=getValue(fmu_obj, parameterNames{1}); %%% Ravi delete this
%  OPTIONS=struct();
%  OPTIONS.solver='ode15s';
%  %OPTIONS.solver_setting=
%  OPTIONS.Tmax=4;
%  U=[];
%  X_GUESS=[];
%  Y=[];
%  U_MIN=[];
%  U_MAX=[];
%  U_GUESS=[];
% try
%     [X_SS,U_SS,Y_SS,EXITFLAG] = fmu_obj.trim(U,X_GUESS,Y,U_GUESS,U_MIN,U_MAX,OPTIONS);
%     [A,B,C,D,YLIN] = fmu_obj.linearize(X_SS,U_SS);
%     [Wn,zeta,P]=damp(A);
%     [C,I] = min(abs(Wn-CriticalMode));
%     modes=P(I);
% catch ME
%     disp(ME.message)
%     if strcmp('fmiGetDerivatives returned with fmiError.',ME.message)==1
%        modes=0; 
%     end
% end


clear params 
end
