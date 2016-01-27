function [modes ] = SmallSignalPerformance(p, RaPIdObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
parameterNames=RaPIdObject.parameterNames;
% parameterNames{1}='G2_bus5400.sEXS.TB';
% parameterNames{2}='G1_bus7000.gENROU.H';

CriticalMode=abs(RaPIdObject.ReferenceMode);
dymolaPath=RaPIdObject.DymolaPath;
dymolaModelName=RaPIdObject.DymolaModelName;

for i=1:length(p)
    dymola([parameterNames{i} '=' num2str(p(i))]);
end
fprintf('parameter: %15.9f    ;'   , p(1));

if (all(dymolaModelName ~='IEEE_14_Buses.mo'))
    dymola(['Modelica_LinearSystems2.ModelAnalysis.Poles("iPSL.' dymolaModelName '")']);
else
    %dymola( 'cd("C:/Users/vperic/Documents/iTesla_RaPId_fork/Examples/IEEE14/iPSL")');
    dymola('Modelica_LinearSystems2.ModelAnalysis.Poles("iPSL.Examples.IEEE_14_Buses")');
end

load( [dymolaPath 'dslin.mat'])
[Wn,zeta,P]=damp(ABCD);
[C,I] = min(abs(Wn-CriticalMode));
modes=P(I);
end
