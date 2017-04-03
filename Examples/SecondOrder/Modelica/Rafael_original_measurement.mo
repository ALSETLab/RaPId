within ;
model Rafael_original_measurement
  Modelica.Blocks.Sources.Step step(startTime=1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Continuous.SecondOrder secondOrder(
    k=0.3,
    w=0.5,
    D=0.4) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(secondOrder.y, y) annotation (Line(
      points={{-19,70},{10,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, secondOrder.u) annotation (Line(
      points={{-59,70},{-42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (uses(Modelica(version="3.2")), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Rafael_original_measurement;
