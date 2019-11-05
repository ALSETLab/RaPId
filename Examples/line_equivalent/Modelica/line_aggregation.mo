within ;
package line_aggregation
  model reference_system

    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE(
      M_b=100,
      Tpd0=5,
      Tppd0=0.07,
      Tpq0=0.9,
      Tppq0=0.09,
      H=4.28,
      D=0,
      Xd=1.84,
      Xq=1.75,
      Xpd=0.41,
      Xpq=0.6,
      Xppd=0.2,
      Xppq=0.2,
      Xl=0.12,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=1.726458,
      P_0=40,
      Q_0=6.086015)
      annotation (Placement(transformation(extent={{-78,-10},{-38,30}})));
    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE1(
      D=0,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=0,
      R_a=0.0030,
      Tpd0=7.6969,
      Tppd0=0.0413,
      Tpq0=1.6732,
      Tppq0=0.0763,
      H=7.9284,
      Xd=1.0003,
      Xq=1.3005,
      Xpd=0.1638,
      Xpq=0.8517,
      Xppd=0.1331,
      Xppq=0.1331,
      Xl=0.1111,
      P_0=10.01703,
      Q_0=5.683661,
      M_b=100)
      annotation (Placement(transformation(extent={{170,-10},{130,30}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1)                                                                                                   annotation(Placement(transformation(extent={{6,0},{
              26,20}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine1(
      R=0.001,
      X=0.2,
      G=0,
      B=0)                                                                                                     annotation(Placement(transformation(extent={{62,20},
              {82,40}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine3(
      t2=100,
      G=0,
      B=0,
      t1=100,
      R=0.001,
      X=0.2)                                                                                                     annotation(Placement(transformation(extent={{62,-20},
              {82,0}})));
    OpenIPSL.Electrical.Loads.PSSE.Load_variation constantLoad(
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9943165,
      angle_0=-0.5755869,
      P_0=50,
      Q_0=10)                                                                                                   annotation(Placement(transformation(extent={{40,-50},
              {52,-38}})));
    OpenIPSL.Electrical.Buses.Bus LOAD
      annotation (Placement(transformation(extent={{32,0},{52,20}})));
    OpenIPSL.Electrical.Buses.Bus GEN1
      annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
    OpenIPSL.Electrical.Buses.Bus GEN2
      annotation (Placement(transformation(extent={{92,0},{112,20}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
    Modelica.Blocks.Math.Add add1
      annotation (Placement(transformation(extent={{-158,4},{-138,24}})));
    Modelica.Blocks.Sources.Ramp ramp(
      height=0.01,
      duration=3,
      offset=0,
      startTime=2)
      annotation (Placement(transformation(extent={{-192,14},{-172,34}})));
    Modelica.Blocks.Sources.Ramp ramp1(
      height=-0.01,
      duration=5,
      startTime=10)
      annotation (Placement(transformation(extent={{-192,-16},{-172,4}})));
    inner OpenIPSL.Electrical.SystemBase SysData
      annotation (Placement(transformation(extent={{-200,40},{-160,60}})));
  equation
    connect(gENROE1.EFD0,gENROE1. EFD) annotation (Line(points={{128,0},{124,0},{124,
            -16},{176,-16},{176,0},{174,0}},     color={0,0,127}));
    connect(gENROE1.PMECH,gENROE1. PMECH0) annotation (Line(points={{174,20},{180,
            20},{180,-20},{120,-20},{120,20},{128,20}},
                                                     color={0,0,127}));
    connect(pwLine.n,LOAD. p)
      annotation (Line(points={{25,10},{25,10},{42,10}}, color={0,0,255}));
    connect(LOAD.p,pwLine1. p)
      annotation (Line(points={{42,10},{50,10},{50,30},{63,30}},
                                                            color={0,0,255}));
    connect(pwLine3.p,pwLine1. p) annotation (Line(points={{63,-10},{50,-10},{50,30},
            {63,30}}, color={0,0,255}));
    connect(pwLine1.n,GEN2. p)
      annotation (Line(points={{81,30},{94,30},{94,10},{102,10}},
                                                               color={0,0,255}));
    connect(pwLine3.n,GEN2. p) annotation (Line(points={{81,-10},{94,-10},{94,10},
            {102,10}},
                    color={0,0,255}));
    connect(gENROE1.p,GEN2. p)
      annotation (Line(points={{130,10},{130,10},{102,10}},    color={0,0,255}));
    connect(constantLoad.p,pwLine1. p) annotation (Line(points={{46,-38},{46,
            -38},{46,10},{50,10},{50,30},{63,30}},
                                         color={0,0,255}));
    connect(pwLine.p, GEN1.p)
      annotation (Line(points={{7,10},{7,10},{-14,10}},    color={0,0,255}));
    connect(gENROE.p, GEN1.p)
      annotation (Line(points={{-38,10},{-38,10},{-14,10}}, color={0,0,255}));
    connect(gENROE.EFD, gENROE.EFD0) annotation (Line(points={{-82,0},{-90,0},{-90,
            -20},{-34,-20},{-34,0},{-36,0}},         color={0,0,127}));
    connect(add.y, gENROE.PMECH)
      annotation (Line(points={{-99,20},{-82,20}},            color={0,0,127}));
    connect(add.u1, gENROE.PMECH0) annotation (Line(points={{-122,26},{-138,26},{-138,
            46},{-28,46},{-28,20},{-36,20}},      color={0,0,127}));
    connect(add.u2, add1.y)
      annotation (Line(points={{-122,14},{-130,14},{-137,14}}, color={0,0,127}));
    connect(add1.u1, ramp.y) annotation (Line(points={{-160,20},{-168,20},{-168,24},
            {-171,24}},     color={0,0,127}));
    connect(add1.u2, ramp1.y) annotation (Line(points={{-160,8},{-166,8},{-166,-6},
            {-171,-6}}, color={0,0,127}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-200,
              -60},{200,60}})),
      Icon(coordinateSystem(extent={{-200,-60},{200,60}})));
  end reference_system;

  model aggregated_system "Transformed simple example for RaPId paper"

    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE(
      M_b=100,
      Tpd0=5,
      Tppd0=0.07,
      Tpq0=0.9,
      Tppq0=0.09,
      H=4.28,
      D=0,
      Xd=1.84,
      Xq=1.75,
      Xpd=0.41,
      Xpq=0.6,
      Xppd=0.2,
      Xl=0.12,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=1.726458,
      P_0=40,
      Q_0=6.086015,
      Xppq=0.2)
      annotation (Placement(transformation(extent={{-78,-10},{-38,30}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1)                                                                                                   annotation(Placement(transformation(extent={{6,0},{
              26,20}})));
    OpenIPSL.Electrical.Buses.Bus LOAD
      annotation (Placement(transformation(extent={{32,0},{52,20}})));
    OpenIPSL.Electrical.Buses.Bus GEN1
      annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
    OpenIPSL.Electrical.Loads.PSSE.Load_variation constantLoad(
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9943165,
      angle_0=-0.5755869,
      P_0=50,
      Q_0=10)                                                                                                   annotation(Placement(transformation(extent={{44,-36},
              {56,-24}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine1(
      G=0,
      B=0,
      R=0.0001,
      X=0.02)                                                                                                  annotation(Placement(transformation(extent={{78,0},{
              98,20}})));
    OpenIPSL.Electrical.Buses.Bus GEN2
      annotation (Placement(transformation(extent={{102,0},{122,20}})));
    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE1(
      D=0,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=0,
      R_a=0.0030,
      Tpd0=7.6969,
      Tppd0=0.0413,
      Tpq0=1.6732,
      Tppq0=0.0763,
      H=7.9284,
      Xd=1.0003,
      Xq=1.3005,
      Xpd=0.1638,
      Xpq=0.8517,
      Xppd=0.1331,
      Xl=0.1111,
      P_0=10.01703,
      Q_0=5.683661,
      M_b=100,
      Xppq=0.1331)
      annotation (Placement(transformation(extent={{180,-10},{140,30}})));
    Modelica.Blocks.Interfaces.RealInput pref_disturb
      annotation (Placement(transformation(extent={{-182,-6},{-142,34}})));
  equation
    connect(pwLine.n,LOAD. p)
      annotation (Line(points={{25,10},{25,10},{42,10}}, color={0,0,255}));
    connect(pwLine.p, GEN1.p)
      annotation (Line(points={{7,10},{7,10},{-14,10}},    color={0,0,255}));
    connect(gENROE.p, GEN1.p)
      annotation (Line(points={{-38,10},{-38,10},{-14,10}}, color={0,0,255}));
    connect(gENROE.EFD, gENROE.EFD0) annotation (Line(points={{-82,0},{-90,0},{-90,
            -20},{-34,-20},{-34,0},{-36,0}},         color={0,0,127}));
    connect(gENROE.PMECH, add.y)
      annotation (Line(points={{-82,20},{-82,20},{-99,20}}, color={0,0,127}));
    connect(add.u1, gENROE.PMECH0) annotation (Line(points={{-122,26},{-132,26},{-132,
            42},{-28,42},{-28,20},{-36,20}},      color={0,0,127}));
    connect(constantLoad.p, LOAD.p) annotation (Line(points={{50,-24},{50,-24},
            {50,10},{42,10}},        color={0,0,255}));
    connect(pwLine1.n,GEN2. p)
      annotation (Line(points={{97,10},{97,10},{112,10}},      color={0,0,255}));
    connect(gENROE1.EFD0,gENROE1. EFD) annotation (Line(points={{138,0},{134,0},{134,
            -16},{186,-16},{186,0},{184,0}},     color={0,0,127}));
    connect(gENROE1.PMECH,gENROE1. PMECH0) annotation (Line(points={{184,20},{190,
            20},{190,-20},{130,-20},{130,20},{138,20}},
                                                     color={0,0,127}));
    connect(gENROE1.p, GEN2.p)
      annotation (Line(points={{140,10},{112,10}},          color={0,0,255}));
    connect(pwLine1.p, LOAD.p)
      annotation (Line(points={{79,10},{42,10}}, color={0,0,255}));
    connect(pref_disturb, add.u2) annotation (Line(points={{-162,14},{-134,14},{
            -122,14}},           color={0,0,127}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-200,
              -60},{200,60}})),
      Icon(coordinateSystem(extent={{-200,-60},{200,60}})));
  end aggregated_system;
  annotation (uses(PowerSystems(version="0.7"),
      OpenIPSL(version="1.0.0"),
      Modelica(version="3.2.3")), version="1");
end line_aggregation;
