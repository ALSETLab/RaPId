within ;
model Rafael_original_estimated
  Modelica.Blocks.Sources.Step step1(startTime=1)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Interfaces.RealOutput y1
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(b={0.2}, a={4.1,
        1.5,1.1})
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(step1.y, transferFunction.u) annotation (Line(
      points={{-59,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(transferFunction.y, y1) annotation (Line(
      points={{-19,30},{10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (uses(Modelica(version="3.2.3")),
                                             Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Rafael_original_estimated;
