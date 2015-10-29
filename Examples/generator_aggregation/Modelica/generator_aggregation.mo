within ;
package generator_aggregation
  model reference_system "Original model of simple example for RaPId paper"
    //Tin Rabuzin
    import PowerSystems;

    PowerSystems.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{22,-10},
              {42,10}})));
    PowerSystems.Electrical.Branches.PwLine pwLine1(
      R=0.001,
      X=0.2,
      G=0,
      B=0,
      S_b=100)                                                                                                 annotation(Placement(transformation(extent={{82,10},
              {102,30}})));
    PowerSystems.Electrical.Branches.PwLine2Openings pwLine3(
      t2=100,
      G=0,
      B=0,
      t1=100,
      R=0.001,
      X=0.2,
      S_b=100)                                                                                                   annotation(Placement(transformation(extent={{82,-30},
              {102,-10}})));
    PowerSystems.Electrical.Loads.PSSE.ConstantLoadvary2 constantLoad(
      S_i(im=0, re=0),
      S_y(re=0, im=0),
      a(re=1, im=0),
      b(re=0, im=1),
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9983706,
      angle_0=-2.873504,
      S_p(re=1, im=0.5))                                                                                        annotation(Placement(transformation(extent={{72,-74},
              {94,-50}})));
    PowerSystems.Electrical.Machines.PSSE.GENROE.GENROE gENROE(
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
      angle_0=-0.1696705,
      P_0=50,
      Q_0=54.87792,
      V_0=1.05)
      annotation (Placement(transformation(extent={{-58,-20},{-18,20}})));
    PowerSystems.Electrical.Machines.PSSE.GENROE.GENROE gENROE1(
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
      angle_0=0,
      P_0=25.03128,
      Q_0=1.317227,
      M_b=1000)
      annotation (Placement(transformation(extent={{184,20},{144,60}})));
    PowerSystems.Electrical.Machines.PSSE.GENROE.GENROE gENROE2(
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
      angle_0=0,
      P_0=25.03128,
      Q_0=1.317227,
      M_b=1000)
      annotation (Placement(transformation(extent={{184,-60},{144,-20}})));
    PowerSystems.Electrical.Buses.Bus LOAD
      annotation (Placement(transformation(extent={{52,-10},{72,10}})));
    PowerSystems.Electrical.Buses.Bus GEN1
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    PowerSystems.Electrical.Buses.Bus GEN2
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
  equation
    connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-58,10},{-68,10},
            {-68,26},{-6,26},{-6,-10},{-16.4,-10}},   color={0,0,127}));
    connect(gENROE.p, GEN1.p)
      annotation (Line(points={{-16,0},{2,0},{2,0}},     color={0,0,255}));
    connect(GEN1.p, pwLine.p)
      annotation (Line(points={{2,0},{14,0},{14,0},{25,0}},
                                                 color={0,0,255}));
    connect(pwLine.n, LOAD.p)
      annotation (Line(points={{39,0},{62,0},{62,0}},    color={0,0,255}));
    connect(LOAD.p, pwLine1.p)
      annotation (Line(points={{62,0},{70,0},{70,20},{85,20}},
                                                            color={0,0,255}));
    connect(pwLine3.p, pwLine1.p) annotation (Line(points={{85,-20},{70,-20},{70,20},
            {85,20}}, color={0,0,255}));
    connect(pwLine1.n, GEN2.p)
      annotation (Line(points={{99,20},{114,20},{114,0},{122,0}},
                                                               color={0,0,255}));
    connect(pwLine3.n, GEN2.p) annotation (Line(points={{99,-20},{114,-20},{114,
            0},{122,0}},
                    color={0,0,255}));
    connect(gENROE1.p, GEN2.p)
      annotation (Line(points={{142,40},{130,40},{130,0},{122,0}},
                                                               color={0,0,255}));
    connect(gENROE2.p, GEN2.p) annotation (Line(points={{142,-40},{130,-40},{
            130,0},{122,0}},
                    color={0,0,255}));
    connect(constantLoad.p, pwLine1.p) annotation (Line(points={{75.3,-60.8},{66,-60.8},
            {66,0},{70,0},{70,20},{85,20}},
                                         color={0,0,255}));
    connect(gENROE1.EFD0, gENROE1.EFD) annotation (Line(points={{142.4,26},{138,26},
            {138,14},{190,14},{190,30},{184,30}},color={0,0,127}));
    connect(gENROE2.EFD0, gENROE2.EFD) annotation (Line(points={{142.4,-54},{136,-54},
            {136,-66},{190,-66},{190,-50},{184,-50}},color={0,0,127}));
    connect(gENROE2.PMECH, gENROE2.PMECH0) annotation (Line(points={{184,-30},{194,
            -30},{194,-70},{132,-70},{132,-50},{142.4,-50}},
                                                          color={0,0,127}));
    connect(gENROE1.PMECH, gENROE1.PMECH0) annotation (Line(points={{184,50},{194,
            50},{194,10},{134,10},{134,30},{142.4,30}},
                                                     color={0,0,127}));
    connect(add.y,add1. u1)
      annotation (Line(points={{-129,-4},{-112,-4}},     color={0,0,127}));
    connect(step1.y, add.u2) annotation (Line(points={{-169,-24},{-160,-24},{-160,
            -10},{-152,-10}}, color={0,0,127}));
    connect(step.y, add.u1) annotation (Line(points={{-169,16},{-160,16},{-160,2},
            {-152,2}}, color={0,0,127}));
    connect(add1.y, gENROE.EFD)
      annotation (Line(points={{-89,-10},{-58,-10}}, color={0,0,127}));
    connect(gENROE.EFD0, add1.u2) annotation (Line(points={{-16.4,-14},{-6,-14},{-6,
            -40},{-122,-40},{-122,-16},{-112,-16}}, color={0,0,127}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-200,
              -100},{200,100}})),
      Icon(coordinateSystem(extent={{-200,-100},{200,100}})));
  end reference_system;

  model aggregated_system "SMIB system with one load and GENROE model"

    PowerSystems.Electrical.Branches.PwLine pwLine(
      R=0.001,
      G=0,
      B=0,
      X=0.1)                                                                                                   annotation(Placement(transformation(extent={{46,-6},
              {66,14}})));
    PowerSystems.Electrical.Machines.PSSE.GENROE.GENROE gENROE(
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
      angle_0=-0.1696705,
      P_0=50,
      Q_0=54.87792,
      V_0=1.05)
      annotation (Placement(transformation(extent={{-16,-16},{24,24}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
    Modelica.Blocks.Sources.Step step(
      startTime=2,
      offset=0,
      height=0.1)
      annotation (Placement(transformation(extent={{-112,-4},{-92,16}})));
    Modelica.Blocks.Sources.Step step1(height=-0.1, startTime=10)
      annotation (Placement(transformation(extent={{-112,-42},{-92,-22}})));
    Modelica.Blocks.Math.Add add1
      annotation (Placement(transformation(extent={{-48,-16},{-28,4}})));
    PowerSystems.Electrical.Machines.PSSE.GENROE.GENROE gENROE1(
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
      Xl=0.1111,
      S10=0.11,
      S12=0.39,
      V_0=1,
      angle_0=0,
      M_b=1000,
      P_0=2*25.03128,
      Q_0=2*1.317227)
      annotation (Placement(transformation(extent={{158,-16},{118,24}})));
    PowerSystems.Electrical.Branches.PwLine pwLine1(
      R=0.001,
      G=0,
      B=0,
      X=0.2)                                                                                                   annotation(Placement(transformation(extent={{78,-6},
              {98,14}})));
    PowerSystems.Electrical.Loads.PSSE.ConstantLoadvary2 constantLoad(
      S_i(im=0, re=0),
      S_y(re=0, im=0),
      a(re=1, im=0),
      b(re=0, im=1),
      PQBRAK=0.7,
      d_t=0,
      d_P=0,
      t1=0,
      V_0=0.9983706,
      angle_0=-2.873504,
      S_p(re=1, im=0.5))                                                                                        annotation(Placement(transformation(extent={{70,-54},
              {92,-30}})));
    PowerSystems.Electrical.Branches.PwLine pwLine2(
      R=0.001,
      G=0,
      B=0,
      X=0.2)                                                                                                   annotation(Placement(transformation(extent={{78,-24},
              {98,-4}})));
  equation
    connect(gENROE.p, pwLine.p)
      annotation (Line(points={{26,4},{49,4}}, color={0,0,255}));
    connect(step.y, add.u1)
      annotation (Line(points={{-91,6},{-85.5,6},{-80,6}}, color={0,0,127}));
    connect(step1.y, add.u2) annotation (Line(points={{-91,-32},{-86,-32},{-86,-6},
            {-80,-6}}, color={0,0,127}));
    connect(add.y, add1.u1)
      annotation (Line(points={{-57,0},{-54,0},{-50,0}}, color={0,0,127}));
    connect(add1.y, gENROE.EFD)
      annotation (Line(points={{-27,-6},{-16,-6}}, color={0,0,127}));
    connect(add1.u2, gENROE.EFD0) annotation (Line(points={{-50,-12},{-58,-12},{
            -58,-38},{30,-38},{30,-10},{25.6,-10}}, color={0,0,127}));
    connect(gENROE.PMECH, gENROE.PMECH0) annotation (Line(points={{-16,14},{-28,
            14},{-28,34},{42,34},{42,-6},{25.6,-6}}, color={0,0,127}));
    connect(gENROE1.EFD0,gENROE1. EFD) annotation (Line(points={{116.4,-10},{112,
            -10},{112,-22},{164,-22},{164,-6},{158,-6}},
                                                 color={0,0,127}));
    connect(gENROE1.PMECH,gENROE1. PMECH0) annotation (Line(points={{158,14},{168,
            14},{168,-26},{108,-26},{108,-6},{116.4,-6}},
                                                     color={0,0,127}));
    connect(pwLine.n, pwLine1.p)
      annotation (Line(points={{63,4},{74,4},{81,4}},
                                               color={0,0,255}));
    connect(pwLine1.n, gENROE1.p)
      annotation (Line(points={{95,4},{106,4},{116,4}},
                                                color={0,0,255}));
    connect(constantLoad.p, pwLine1.p) annotation (Line(points={{73.3,-40.8},{68,
            -40.8},{68,4},{81,4}}, color={0,0,255}));
    connect(pwLine2.p, pwLine1.p) annotation (Line(points={{81,-14},{72,-14},{72,
            4},{81,4}}, color={0,0,255}));
    connect(pwLine2.n, gENROE1.p) annotation (Line(points={{95,-14},{98,-14},{98,
            -12},{102,-12},{102,4},{116,4}}, color={0,0,255}));
    annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
              -100},{100,100}})));
  end aggregated_system;
  annotation (uses(PowerSystems(version="0.7"), Modelica(version="3.2.1")));
end generator_aggregation;
