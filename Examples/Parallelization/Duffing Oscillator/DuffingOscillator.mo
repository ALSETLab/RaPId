within ;
package DuffingOscillator
  model DuffingOscillator
    Modelica.Electrical.Analog.Ideal.IdealDiode diode(Vknee=0.7)
      annotation (Placement(transformation(extent={{-62,8},{-42,28}})));
    Modelica.Electrical.Analog.Ideal.IdealDiode diode1(Vknee=0.7)
      annotation (Placement(transformation(extent={{-42,70},{-62,90}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor3(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-2,70},{18,90}})));
    Modelica.Electrical.Analog.Basic.OpAmp opAmp
      annotation (Placement(transformation(extent={{-22,22},{-2,2}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor1(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-58,-70},{-38,-50}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor2(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-22,-70},{-2,-50}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R=20)
      annotation (Placement(transformation(extent={{8,2},{28,22}})));
    Modelica.Electrical.Analog.Basic.Capacitor capacitor(v(fixed=false),
                                                         C(displayUnit="nF")=
        4.7e-7) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={70,-14})));
    Modelica.Electrical.Analog.Basic.Ground ground
      annotation (Placement(transformation(extent={{60,-72},{80,-52}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=2)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-12,38})));
    Modelica.Electrical.Analog.Basic.Ground ground1 annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-12,66})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage1(V=-2)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-12,-20})));
    Modelica.Electrical.Analog.Basic.Ground ground2
      annotation (Placement(transformation(extent={{-98,34},{-78,54}})));
    Modelica.Electrical.Analog.Basic.Ground ground3
      annotation (Placement(transformation(extent={{-22,-54},{-2,-34}})));
    Modelica.Electrical.Analog.Sources.SineVoltage sineVoltage(V(displayUnit=
            "mV") = 0.24, freqHz(displayUnit="kHz") = 1500) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-74,-60})));
    Modelica.Electrical.Analog.Basic.Ground ground4
      annotation (Placement(transformation(extent={{-104,-80},{-84,-60}})));
    Modelica.Electrical.Analog.Basic.Inductor inductor(i(fixed=false), L(
          displayUnit="mH") = 0.019)
               annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={54,12})));
  equation
    connect(diode1.p, resistor3.p)
      annotation (Line(points={{-42,80},{-2,80}}, color={0,0,255}));
    connect(diode.n, opAmp.in_p)
      annotation (Line(points={{-42,18},{-22,18}}, color={0,0,255}));
    connect(opAmp.in_p, resistor3.p) annotation (Line(points={{-22,18},{-30,18},
            {-30,80},{-2,80}}, color={0,0,255}));
    connect(resistor1.n, resistor2.p)
      annotation (Line(points={{-38,-60},{-22,-60}}, color={0,0,255}));
    connect(opAmp.in_n, resistor2.p) annotation (Line(points={{-22,6},{-30,6},{
            -30,-60},{-22,-60}}, color={0,0,255}));
    connect(resistor.p, opAmp.out)
      annotation (Line(points={{8,12},{-2,12}}, color={0,0,255}));
    connect(resistor2.n, opAmp.out) annotation (Line(points={{-2,-60},{2,-60},{
            2,12},{-2,12}}, color={0,0,255}));
    connect(capacitor.n, ground.p)
      annotation (Line(points={{70,-24},{70,-52}}, color={0,0,255}));
    connect(diode1.n, diode.p) annotation (Line(points={{-62,80},{-70,80},{-70,
            18},{-62,18}}, color={0,0,255}));
    connect(opAmp.VMin, constantVoltage.p)
      annotation (Line(points={{-12,22},{-12,28}}, color={0,0,255}));
    connect(constantVoltage.n, ground1.p)
      annotation (Line(points={{-12,48},{-12,56}}, color={0,0,255}));
    connect(opAmp.VMax, constantVoltage1.p)
      annotation (Line(points={{-12,2},{-12,-10}}, color={0,0,255}));
    connect(ground2.p, diode.p) annotation (Line(points={{-88,54},{-88,62},{-70,
            62},{-70,18},{-62,18}}, color={0,0,255}));
    connect(constantVoltage1.n, ground3.p)
      annotation (Line(points={{-12,-30},{-12,-34}}, color={0,0,255}));
    connect(sineVoltage.p, resistor1.p)
      annotation (Line(points={{-64,-60},{-58,-60}}, color={0,0,255}));
    connect(sineVoltage.n, ground4.p)
      annotation (Line(points={{-84,-60},{-94,-60}}, color={0,0,255}));
    connect(resistor.n, inductor.p)
      annotation (Line(points={{28,12},{44,12}}, color={0,0,255}));
    connect(resistor3.n, capacitor.p)
      annotation (Line(points={{18,80},{70,80},{70,-4}}, color={0,0,255}));
    connect(inductor.n, capacitor.p)
      annotation (Line(points={{64,12},{70,12},{70,-4}}, color={0,0,255}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=0.05,
        __Dymola_NumberOfIntervals=10000,
        __Dymola_fixedstepsize=1e-06,
        __Dymola_Algorithm="Rkfix2"));
  end DuffingOscillator;

  model DuffingOscillatorFMU
    Modelica.Electrical.Analog.Ideal.IdealDiode diode(Vknee=0.7)
      annotation (Placement(transformation(extent={{-62,8},{-42,28}})));
    Modelica.Electrical.Analog.Ideal.IdealDiode diode1(Vknee=0.7)
      annotation (Placement(transformation(extent={{-42,70},{-62,90}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor3(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-2,70},{18,90}})));
    Modelica.Electrical.Analog.Basic.OpAmp opAmp(Slope=1000000)
      annotation (Placement(transformation(extent={{-22,22},{-2,2}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor1(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-58,-70},{-38,-50}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor2(R(displayUnit="kOhm")=
           10000)
      annotation (Placement(transformation(extent={{-22,-70},{-2,-50}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R=20)
      annotation (Placement(transformation(extent={{8,2},{28,22}})));
    Modelica.Electrical.Analog.Basic.Capacitor capacitor(C(displayUnit="nF")=
        4.7e-7) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={70,-14})));
    Modelica.Electrical.Analog.Basic.Ground ground
      annotation (Placement(transformation(extent={{60,-72},{80,-52}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=2)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-12,38})));
    Modelica.Electrical.Analog.Basic.Ground ground1 annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-12,66})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage1(V=-2)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-12,-20})));
    Modelica.Electrical.Analog.Basic.Ground ground2
      annotation (Placement(transformation(extent={{-98,34},{-78,54}})));
    Modelica.Electrical.Analog.Basic.Ground ground3
      annotation (Placement(transformation(extent={{-22,-54},{-2,-34}})));
    Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation (
        Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=180,
          origin={-78,-60})));
    Modelica.Electrical.Analog.Basic.Ground ground4
      annotation (Placement(transformation(extent={{-110,-98},{-90,-78}})));
    Modelica.Electrical.Analog.Basic.Inductor inductor(L(displayUnit="mH")=
        0.019) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={54,12})));
    Modelica.Blocks.Interfaces.RealInput v1
      "Voltage between pin p and n (= p.v - n.v) as input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  equation
    connect(diode1.p, resistor3.p)
      annotation (Line(points={{-42,80},{-2,80}}, color={0,0,255}));
    connect(diode.n, opAmp.in_p)
      annotation (Line(points={{-42,18},{-22,18}}, color={0,0,255}));
    connect(opAmp.in_p, resistor3.p) annotation (Line(points={{-22,18},{-30,18},
            {-30,80},{-2,80}}, color={0,0,255}));
    connect(resistor1.n, resistor2.p)
      annotation (Line(points={{-38,-60},{-22,-60}}, color={0,0,255}));
    connect(opAmp.in_n, resistor2.p) annotation (Line(points={{-22,6},{-30,6},{
            -30,-60},{-22,-60}}, color={0,0,255}));
    connect(resistor.p, opAmp.out)
      annotation (Line(points={{8,12},{-2,12}}, color={0,0,255}));
    connect(resistor2.n, opAmp.out) annotation (Line(points={{-2,-60},{2,-60},{
            2,12},{-2,12}}, color={0,0,255}));
    connect(capacitor.n, ground.p)
      annotation (Line(points={{70,-24},{70,-52}}, color={0,0,255}));
    connect(diode1.n, diode.p) annotation (Line(points={{-62,80},{-70,80},{-70,
            18},{-62,18}}, color={0,0,255}));
    connect(opAmp.VMin, constantVoltage.p)
      annotation (Line(points={{-12,22},{-12,28}}, color={0,0,255}));
    connect(constantVoltage.n, ground1.p)
      annotation (Line(points={{-12,48},{-12,56}}, color={0,0,255}));
    connect(opAmp.VMax, constantVoltage1.p)
      annotation (Line(points={{-12,2},{-12,-10}}, color={0,0,255}));
    connect(ground2.p, diode.p) annotation (Line(points={{-88,54},{-88,62},{-70,
            62},{-70,18},{-62,18}}, color={0,0,255}));
    connect(constantVoltage1.n, ground3.p)
      annotation (Line(points={{-12,-30},{-12,-34}}, color={0,0,255}));
    connect(signalVoltage.p, resistor1.p)
      annotation (Line(points={{-68,-60},{-58,-60}}, color={0,0,255}));
    connect(signalVoltage.n, ground4.p) annotation (Line(points={{-88,-60},{
            -100,-60},{-100,-78}},
                             color={0,0,255}));
    connect(resistor.n, inductor.p)
      annotation (Line(points={{28,12},{44,12}}, color={0,0,255}));
    connect(resistor3.n, capacitor.p)
      annotation (Line(points={{18,80},{70,80},{70,-4}}, color={0,0,255}));
    connect(inductor.n, capacitor.p)
      annotation (Line(points={{64,12},{70,12},{70,-4}}, color={0,0,255}));
    connect(signalVoltage.v, v1) annotation (Line(points={{-78,-48},{-78,0},{
            -120,0}},         color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
              100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{
              100,100}})),
      experiment(
        StopTime=0.05,
        __Dymola_NumberOfIntervals=10000,
        __Dymola_fixedstepsize=1e-06,
        __Dymola_Algorithm="Rkfix2"));
  end DuffingOscillatorFMU;
  annotation (uses(Modelica(version="3.2.3")));
end DuffingOscillator;
