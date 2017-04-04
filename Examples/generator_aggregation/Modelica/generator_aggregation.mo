within ;
package generator_aggregation
  model reference_system "Original model of simple example for RaPId paper"
    //Tin Rabuzin
    import OpenIPSL;

    OpenIPSL.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{22,-10},
              {42,10}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine1(
      R=0.001,
      X=0.2,
      G=0,
      B=0,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{82,10},
              {102,30}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine3(
      t2=100,
      G=0,
      B=0,
      t1=100,
      R=0.001,
      X=0.2,
      S_b=100,
      opening=1)                                                                                                 annotation(Placement(transformation(extent={{84,-30},
              {104,-10}})));
    OpenIPSL.Electrical.Loads.PSSE.Load_variation constantLoad(
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9983706,
      angle_0=-2.873504,
      P_0=100,
      Q_0=50)                                                                                                   annotation(Placement(transformation(extent={{62,-48},
              {70,-40}})));
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
      angle_0=-0.1696705,
      P_0=50,
      Q_0=54.87792,
      V_0=1.05)
      annotation (Placement(transformation(extent={{-58,-20},{-18,20}})));
    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE1(
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
      angle_0=0,
      P_0=25.03128,
      Q_0=1.317227,
      M_b=1000)
      annotation (Placement(transformation(extent={{184,20},{144,60}})));
    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE2(
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
      angle_0=0,
      P_0=25.03128,
      Q_0=1.317227,
      M_b=1000)
      annotation (Placement(transformation(extent={{184,-60},{144,-20}})));
    OpenIPSL.Electrical.Buses.Bus LOAD
      annotation (Placement(transformation(extent={{52,-10},{72,10}})));
    OpenIPSL.Electrical.Buses.Bus GEN1
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    OpenIPSL.Electrical.Buses.Bus GEN2
      annotation (Placement(transformation(extent={{112,-10},{132,10}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-150,-14},{-130,6}})));
    Modelica.Blocks.Sources.Step step(
      startTime=2,
      offset=0,
      height=0.1)
      annotation (Placement(transformation(extent={{-190,6},{-170,26}})));
    Modelica.Blocks.Sources.Step step1(height=-0.1, startTime=10)
      annotation (Placement(transformation(extent={{-190,-34},{-170,-14}})));
    Modelica.Blocks.Math.Add add1
      annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
    inner OpenIPSL.Electrical.SystemBase SysData
      annotation (Placement(transformation(extent={{-200,80},{-160,100}})));
  equation
    connect(gENROE.p, GEN1.p)
      annotation (Line(points={{-18,0},{2,0}},           color={0,0,255}));
    connect(GEN1.p, pwLine.p)
      annotation (Line(points={{2,0},{14,0},{23,0}},
                                                 color={0,0,255}));
    connect(pwLine.n, LOAD.p)
      annotation (Line(points={{41,0},{62,0}},           color={0,0,255}));
    connect(LOAD.p, pwLine1.p)
      annotation (Line(points={{62,0},{70,0},{70,20},{83,20}},
                                                            color={0,0,255}));
    connect(pwLine3.p, pwLine1.p) annotation (Line(points={{85,-20},{70,-20},{
            70,20},{83,20}},
                      color={0,0,255}));
    connect(pwLine1.n, GEN2.p)
      annotation (Line(points={{101,20},{114,20},{114,0},{122,0}},
                                                               color={0,0,255}));
    connect(pwLine3.n, GEN2.p) annotation (Line(points={{103,-20},{114,-20},{
            114,0},{122,0}},
                    color={0,0,255}));
    connect(gENROE1.p, GEN2.p)
      annotation (Line(points={{144,40},{130,40},{130,0},{122,0}},
                                                               color={0,0,255}));
    connect(gENROE2.p, GEN2.p) annotation (Line(points={{144,-40},{130,-40},{130,0},
            {122,0}},
                    color={0,0,255}));
    connect(constantLoad.p, pwLine1.p) annotation (Line(points={{66,-39.6},{66,-39.6},
            {66,0},{70,0},{70,20},{83,20}},
                                         color={0,0,255}));
    connect(gENROE1.EFD0, gENROE1.EFD) annotation (Line(points={{142,30},{138,30},
            {138,14},{190,14},{190,30},{188,30}},color={0,0,127}));
    connect(gENROE2.EFD0, gENROE2.EFD) annotation (Line(points={{142,-50},{136,-50},
            {136,-66},{190,-66},{190,-50},{188,-50}},color={0,0,127}));
    connect(gENROE2.PMECH, gENROE2.PMECH0) annotation (Line(points={{188,-30},{194,
            -30},{194,-70},{132,-70},{132,-30},{142,-30}},color={0,0,127}));
    connect(gENROE1.PMECH, gENROE1.PMECH0) annotation (Line(points={{188,50},{194,
            50},{194,10},{134,10},{134,50},{142,50}},color={0,0,127}));
    connect(add.y,add1. u1)
      annotation (Line(points={{-129,-4},{-112,-4}},     color={0,0,127}));
    connect(step1.y, add.u2) annotation (Line(points={{-169,-24},{-160,-24},{-160,
            -10},{-152,-10}}, color={0,0,127}));
    connect(step.y, add.u1) annotation (Line(points={{-169,16},{-160,16},{-160,2},
            {-152,2}}, color={0,0,127}));
    connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-62,10},{-70,
            10},{-70,28},{-10,28},{-10,10},{-16,10}}, color={0,0,127}));
    connect(add1.y, gENROE.EFD) annotation (Line(points={{-89,-10},{-62,-10},{
            -62,-10}}, color={0,0,127}));
    connect(add1.u2, gENROE.EFD0) annotation (Line(points={{-112,-16},{-120,-16},
            {-120,-36},{-10,-36},{-10,-10},{-16,-10}}, color={0,0,127}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-200,
              -100},{200,100}})),
      Icon(coordinateSystem(extent={{-200,-100},{200,100}})));
  end reference_system;

  model aggregated_system "SMIB system with one load and GENROE model"

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
      angle_0=-0.1696705,
      P_0=50,
      Q_0=54.87792,
      V_0=1.05)
      annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-162,-14},{-142,6}})));
    Modelica.Blocks.Sources.Step step(
      startTime=2,
      offset=0,
      height=0.1)
      annotation (Placement(transformation(extent={{-196,-8},{-176,12}})));
    Modelica.Blocks.Sources.Step step1(height=-0.1, startTime=10)
      annotation (Placement(transformation(extent={{-196,-46},{-176,-26}})));
    Modelica.Blocks.Math.Add add1
      annotation (Placement(transformation(extent={{-132,-20},{-112,0}})));
    OpenIPSL.Electrical.Machines.PSSE.GENROE gENROE1(
      Tpd0=7.6969,
      Tppd0=0.0413,
      Tpq0=1.6732,
      Tppq0=0.0763,
      H=7.92,
      D=0,
      Xd=1.003,
      Xq=1.3005,
      Xpd=0.1638,
      Xpq=0.8517,
      Xppd=0.1331,
      Xppq=0.2,
      Xl=0.1111,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=0,
      M_b=1000,
      P_0=2*25.03128,
      Q_0=2*1.317227)
      annotation (Placement(transformation(extent={{180,-20},{140,20}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{0,-10},
              {20,10}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine1(
      R=0.001,
      X=0.2,
      G=0,
      B=0,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{60,10},
              {80,30}})));
    OpenIPSL.Electrical.Branches.PwLine pwLine3(
      t2=100,
      G=0,
      B=0,
      t1=100,
      R=0.001,
      X=0.2,
      S_b=100,
      opening=1)                                                                                                 annotation(Placement(transformation(extent={{62,-30},
              {82,-10}})));
    OpenIPSL.Electrical.Loads.PSSE.Load_variation constantLoad(
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9983706,
      angle_0=-2.873504,
      P_0=100,
      Q_0=50)                                                                                                   annotation(Placement(transformation(extent={{40,-48},
              {48,-40}})));
    OpenIPSL.Electrical.Buses.Bus LOAD
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    OpenIPSL.Electrical.Buses.Bus GEN1
      annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
    OpenIPSL.Electrical.Buses.Bus GEN2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    inner OpenIPSL.Electrical.SystemBase SysData
      annotation (Placement(transformation(extent={{-200,80},{-160,100}})));
  equation
    connect(step.y, add.u1)
      annotation (Line(points={{-175,2},{-169.5,2},{-164,2}},
                                                           color={0,0,127}));
    connect(step1.y, add.u2) annotation (Line(points={{-175,-36},{-170,-36},{
            -170,-10},{-164,-10}},
                       color={0,0,127}));
    connect(add.y, add1.u1)
      annotation (Line(points={{-141,-4},{-138,-4},{-134,-4}},
                                                         color={0,0,127}));
    connect(add1.y, gENROE.EFD)
      annotation (Line(points={{-111,-10},{-104,-10}},
                                                   color={0,0,127}));
    connect(add1.u2, gENROE.EFD0) annotation (Line(points={{-134,-16},{-142,-16},
            {-142,-42},{-54,-42},{-54,-10},{-58,-10}},
                                                    color={0,0,127}));
    connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-104,10},{
            -112,10},{-112,24},{-54,24},{-54,10},{-58,10}},
                                                     color={0,0,127}));
    connect(gENROE1.EFD0,gENROE1. EFD) annotation (Line(points={{138,-10},{134,
            -10},{134,-26},{186,-26},{186,-10},{184,-10}},
                                                 color={0,0,127}));
    connect(gENROE1.PMECH,gENROE1. PMECH0) annotation (Line(points={{184,10},{
            190,10},{190,-30},{130,-30},{130,10},{138,10}},
                                                     color={0,0,127}));
    connect(GEN1.p,pwLine. p)
      annotation (Line(points={{-20,0},{-8,0},{1,0}},
                                                 color={0,0,255}));
    connect(pwLine.n,LOAD. p)
      annotation (Line(points={{19,0},{40,0}},           color={0,0,255}));
    connect(LOAD.p,pwLine1. p)
      annotation (Line(points={{40,0},{48,0},{48,20},{61,20}},
                                                            color={0,0,255}));
    connect(pwLine3.p,pwLine1. p) annotation (Line(points={{63,-20},{48,-20},{
            48,20},{61,20}},
                      color={0,0,255}));
    connect(pwLine1.n,GEN2. p)
      annotation (Line(points={{79,20},{92,20},{92,0},{100,0}},color={0,0,255}));
    connect(pwLine3.n,GEN2. p) annotation (Line(points={{81,-20},{92,-20},{92,0},
            {100,0}},
                    color={0,0,255}));
    connect(constantLoad.p,pwLine1. p) annotation (Line(points={{44,-39.6},{44,
            -39.6},{44,0},{48,0},{48,20},{61,20}},
                                         color={0,0,255}));
    connect(GEN2.p, gENROE1.p)
      annotation (Line(points={{100,0},{120,0},{140,0}}, color={0,0,255}));
    connect(GEN1.p, gENROE.p)
      annotation (Line(points={{-20,0},{-40,0},{-60,0}}, color={0,0,255}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-200,
              -100},{200,100}})), Icon(coordinateSystem(extent={{-200,-100},{
              200,100}})));
  end aggregated_system;
  annotation (uses(PowerSystems(version="0.7"),
      Modelica(version="3.2.2"),
      OpenIPSL(version="1.0.0")), version="1");
end generator_aggregation;
