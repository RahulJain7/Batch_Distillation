package Batch_Distill
  model Flash
    parameter Real HVstart[1] = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, Tf, P, XF1, XF2);
    parameter Real HLstart[1] = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    parameter Real Cpstart[1] = Property(Propack, "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    //  parameter Real F = 100;
    parameter Real Tf = 365;
    //  parameter Real Q = 700000;
    //  parameter Real L = 70;
    parameter String Comp1 = "Benzene";
    parameter String Comp2 = "Toluene";
    parameter Real XF1 = 0.5, XF2 = 0.5;
    parameter Real P = 101325;
    parameter String Propack = "NRTL", Prop = "enthalpy", Basis = "Mole", PhasLabel = "Liquid";
    Real Vledata[3];
    Real Vin, Vout;
    Real Lin, Lout;
    Real X11, Y11, HVin, HLin;
    Real X1(start = 0.5);
    Real Y1(start = 0.71);
    Real X2(start = 0.5);
    Real Y2(start = 0.29);
    Real T(start = 350, fixed = true, min = 353, max = 383) annotation(isFinalConstraint = true);
    Real M(start = 10, fixed = true) annotation(isFinalConstraint = true);
    Real HV[1](start = HVstart[1]), HL[1](start = HLstart[1]), Cp[1](start = Cpstart[1]);
    Batch_Distill.Tray_port_Vap_In tray_port_vap_in1 annotation(Placement(visible = true, transformation(origin = {-66, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-66, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Vap_Out tray_port_vap_out1 annotation(Placement(visible = true, transformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-66, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Liq_In tray_port_liq_in1 annotation(Placement(visible = true, transformation(origin = {74, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Liq_Out tray_port_liq_out1 annotation(Placement(visible = true, transformation(origin = {74, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    Vin = tray_port_vap_in1.M;
    Lin = tray_port_liq_in1.M;
    Y11 = tray_port_vap_in1.Comp;
    X11 = tray_port_liq_in1.Comp;
    HVin = tray_port_vap_in1.H;
    HLin = tray_port_liq_in1.H;
    HV = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, T, P, Y1, Y2);
    HL = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    Cp = Property("NRTL", "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    Vledata = PTF("Raoult's Law", P, T, Comp1, Comp2, X1, X2);
    Y1 = Vledata[2];
    M * der(X1) + X1 * der(M) = Vin * Y11 + Lin * X11 - Vout * Y1 - Lout * X1;
    Y2 = 1 - Y1;
    X2 = 1 - X1;
    Vout / M = Vledata[1];
    der(M) = Vin + Lin - Lout - Vout;
    Vin * HVin + Lin * HLin - Vout * HV[1] - Lout * HL[1] = M * Cp[1] * der(T) + HL[1] * der(M);
    Lout = Lin;
  algorithm
    tray_port_liq_out1.M := -Lout;
  equation
    tray_port_vap_out1.M = -Vout;
    tray_port_vap_out1.H = HV[1];
    tray_port_liq_out1.H = HL[1];
    tray_port_vap_out1.Comp = Y1;
    tray_port_liq_out1.Comp = X1;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {-34, 28}, extent = {{-52, -8}, {128, -46}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAAdoAAAA8CAIAAABO7OzTAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAIJSURBVHhe7dRbjuJQDEXRmv8wenQ9C9rCjoTzKEJBu/KxlrYEXPL4O183AC7AHANcgjkGuARzDHAJNcdfXR4C8HG1s4s6NccAw2pnF3VqjgGG1c4u6tQcAwyrnV3UqTkGGFY7u6hTcwwwrHZ2UafmGGBY7eyiTs0xwLDa2UWdmmOAYbWzizo9mmMAxtQO1wcAv8ccA1yCOQa4BHMM8Ptqh+tj5c9fSdJ/qcsRDuZYkmbrcoSDOZak2boc4WCOJWm2Lkc4mGNJmq3LEQ7mWJJm63KEgzmWpNm6HOFgjiVpti5HOJhjSZqtyxEO5liSZutyhIM5lqTZuhzhYI4labYuRziYY0marcsRDuZYkmbrcoSDOZak2boc4WCOJWm2Lkc4mGNJmq3LEQ7mWJJm63KEgzmWpNm6HOFgjiVpti5HOBzMcVjdL0l6v40c4fDwbWX1CEnS+3W1v3fmWJIG62p/747nOKyeIkl6p43a37v+Y2v1LEnSz9qo5V08m+OweqIk6dX21PIuNr93rZ4rSTrfntrcB3tHu1ZPlySdaU+tbXd6jtPqNZKkow7U1G4cjPT3Vq+UJD32rdrZjcM/Qt0KwCfUth549jcAn1CreuzEFQC8ocb0mdPXAfC62tATXrg01RsAOFBz+aIf3gbAZ5ljgEswxwCXYI4BLsEcA1yCOQa4BHMMcAG32z9lLOcbDquHgAAAAABJRU5ErkJggg==")}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {-12, -22}, extent = {{-76, 36}, {102, 6}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAAdoAAAA8CAIAAABO7OzTAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAIJSURBVHhe7dRbjuJQDEXRmv8wenQ9C9rCjoTzKEJBu/KxlrYEXPL4O183AC7AHANcgjkGuARzDHAJNcdfXR4C8HG1s4s6NccAw2pnF3VqjgGG1c4u6tQcAwyrnV3UqTkGGFY7u6hTcwwwrHZ2UafmGGBY7eyiTs0xwLDa2UWdmmOAYbWzizo9mmMAxtQO1wcAv8ccA1yCOQa4BHMM8Ptqh+tj5c9fSdJ/qcsRDuZYkmbrcoSDOZak2boc4WCOJWm2Lkc4mGNJmq3LEQ7mWJJm63KEgzmWpNm6HOFgjiVpti5HOJhjSZqtyxEO5liSZutyhIM5lqTZuhzhYI4labYuRziYY0marcsRDuZYkmbrcoSDOZak2boc4WCOJWm2Lkc4mGNJmq3LEQ7mWJJm63KEgzmWpNm6HOFgjiVpti5HOBzMcVjdL0l6v40c4fDwbWX1CEnS+3W1v3fmWJIG62p/747nOKyeIkl6p43a37v+Y2v1LEnSz9qo5V08m+OweqIk6dX21PIuNr93rZ4rSTrfntrcB3tHu1ZPlySdaU+tbXd6jtPqNZKkow7U1G4cjPT3Vq+UJD32rdrZjcM/Qt0KwCfUth549jcAn1CreuzEFQC8ocb0mdPXAfC62tATXrg01RsAOFBz+aIf3gbAZ5ljgEswxwCXYI4BLsEcA1yCOQa4BHMMcAG32z9lLOcbDquHgAAAAABJRU5ErkJggg==")}));
  end Flash;

  function PTF
    input String Prop;
    input Real P, T;
    input String Comp1, Comp2;
    input Real x1, x2;
    output Real Result[3];
  
    external "C" PTFlash(Prop, P, T, Comp1, Comp2, x1, x2, Result);
    annotation(Include = "#include\"C:/Clients/PTFlash.c\"");
  end PTF;

  function Property
    input String Propack;
    input String Prop;
    input String Basis;
    input String PhasLabel;
    input String Comp1, Comp2;
    input Real T, P;
    input Real x1, x2;
    output Real Result[1];
  
    external "C" Property(Propack, Prop, Basis, PhasLabel, Comp1, Comp2, T, P, x1, x2, Result);
    annotation(Include = "#include\"C:/Clients/Property.c\"");
  end Property;

  partial connector Tray_port
    Real Comp;
    Real H;
    flow Modelica.SIunits.MolarFlowRate M;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Tray_port;

  connector Tray_port_Vap_Out
    extends Tray_port;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {75.43, -75.08}, lineThickness = 0.5, extent = {{-154.75, 141.93}, {1.59, -1.41}})}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {0.18, -0.35}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-96.64, 96.82}, {96.64, -96.82}})}));
  end Tray_port_Vap_Out;

  connector Tray_port_Vap_In
    extends Tray_port;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {76.8104, -81.9643}, fillPattern = FillPattern.Solid, extent = {{-158.779, 155.966}, {5.15, -5.15}})}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {0.23, -0.23}, fillPattern = FillPattern.Solid, extent = {{-99.06, 99.06}, {99.06, -99.06}})}));
  end Tray_port_Vap_In;

  connector Tray_port_Liq_Out
    extends Tray_port;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {75.43, -75.08}, lineThickness = 0.5, extent = {{-154.75, 141.93}, {1.59, -1.41}})}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {0.18, -0.35}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-96.64, 96.82}, {96.64, -96.82}})}));
  end Tray_port_Liq_Out;

  connector Tray_port_Liq_In
    extends Tray_port;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {76.8104, -81.9643}, fillPattern = FillPattern.Solid, extent = {{-158.779, 155.966}, {5.15, -5.15}})}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {0.23, -0.23}, fillPattern = FillPattern.Solid, extent = {{-99.06, 99.06}, {99.06, -99.06}})}));
  end Tray_port_Liq_In;

  model Reboiler
    parameter Real HVstart[1] = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, Tf, P, XF1, XF2);
    parameter Real HLstart[1] = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    parameter Real Cpstart[1] = Property(Propack, "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    //  parameter Real F = 100;
    parameter Real Tf = 355;
    parameter Real Q = 200000;
    //  parameter Real L = 70;
    parameter String Comp1 = "Benzene";
    parameter String Comp2 = "Toluene";
    parameter Real XF1 = 0.5, XF2 = 0.5;
    parameter Real P = 101325;
    parameter String Propack = "NRTL", Prop = "enthalpy", Basis = "Mole", PhasLabel = "Liquid";
    Real Vledata[3];
    Real Vout;
    Real Lin;
    Real X11, HLin;
    Real X1(start = 0.5) annotation(isFinalConstraint = true);
    Real Y1(start = 0.59);
    Real X2(start = 0.5) annotation(isFinalConstraint = true);
    Real Y2(start = 0.41);
    Real T(start = 365.5, fixed = true, min = 353, max = 383) annotation(isFinalConstraint = true);
    Real M(start = 100, fixed = true) annotation(isFinalConstraint = true);
    Real HV[1](start = HVstart[1]), HL[1](start = HLstart[1]), Cp[1](start = Cpstart[1]);
    Batch_Distill.Tray_port_Liq_In tray_port_liq_in1 annotation(Placement(visible = true, transformation(origin = {70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Vap_Out tray_port_vap_out1 annotation(Placement(visible = true, transformation(origin = {-68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-68, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    Lin = tray_port_liq_in1.M;
    X11 = tray_port_liq_in1.Comp;
    HLin = tray_port_liq_in1.H;
    HV = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, T, P, Y1, Y2);
    HL = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    Cp = Property("NRTL", "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    Vledata = PTF("Raoult's Law", P, T, Comp1, Comp2, X1, X2);
    Y1 = Vledata[2];
    M * der(X1) + X1 * der(M) = Lin * X11 - Vout * Y1;
    Y2 = 1 - Y1;
    X2 = 1 - X1;
    Vout / M = Vledata[1];
    der(M) = Lin - Vout;
    Lin * HLin - Vout * HV[1] + Q = M * Cp[1] * der(T) + HL[1] * der(M);
    tray_port_vap_out1.M = -Vout;
    tray_port_vap_out1.H = HV[1];
    tray_port_vap_out1.Comp = Y1;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {95, -24}, extent = {{-189, 40}, {-1, -2}}, imageSource = "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")}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {86, -23}, extent = {{8, -7}, {-172, 41}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAAfsAAACLCAYAAABm3jCnAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAhQSURBVHhe7dtBbttKFETR8G8h0wyz/xVlmGnW4G8FMBDYltRssuSieDyWmo/nCbiWLC8vrz/f/BAgQIAAAQJPK/Df096ZGyNAgAABAgT+Coi9FwIBAgQIEHhyAbF/8gW7PQIECBAgIPZeAwQIECBA4MkFlr2+oLcsy5NTuT0CBAgQIPA4gT2/P78p9gL/uKW7EgECBAicV2Br+KdiL/LnfcG5cwIECBD4OoHZ6K/+m73Qf92SXZkAAQIEzi1wafBMh1fFfuYC516LuydAgAABAvsLrO3x0Mf4o4fOfrywP4MTCRAgQIDAcQX27u4usRf5476gTE6AAAEC3QL3wj/S4Luxv3WRkQt0E5qOAAECBAgcQ2BLj2/+zX7LwcegMyUBAgQIEDiGwK032Pfe/V+NvdAfY/mmJECAAIHzCMwGf9W38S+cPro/z4vKnRIgQIBAn8BMhz+N/bV39TMX6GMyEQECBAgQOLbAtR5f6/fqd/bH5jE9AQIECBA4n8Bw7L2rP9+Lwx0TIECAQK/Ami5/iP29b/T13rbJCBAgQIAAgc86PvTOfs1vD5gJECBAgACBxwiM9nko9o8Z2VUIECBAgACBhIDYJ1SdSYAAAQIEigTEvmgZRiFAgAABAgkBsU+oOpMAAQIECBQJiH3RMoxCgAABAgQSAmKfUHUmAQIECBAoEhD7omUYhQABAgQIJATEPqHqTAIECBAgUCQg9kXLMAoBAgQIEEgIiH1C1ZkECBAgQKBIQOyLlmEUAgQIECCQEBD7hKozCRAgQIBAkYDYFy3DKAQIECBAICEg9glVZxIgQIAAgSIBsS9ahlEIECBAgEBCQOwTqs4kQIAAAQJFAmJftAyjECBAgACBhIDYJ1SdSYAAAQIEigTEvmgZRiFAgAABAgkBsU+oOpMAAQIECBQJiH3RMoxCgAABAgQSAmKfUHUmAQIECBAoEhD7omUYhQABAgQIJATEPqHqTAIECBAgUCQg9kXLMAoBAgQIEEgIiH1C1ZkECBAgQKBIQOyLlmEUAgQIECCQEBD7hKozCRAgQIBAkYDYFy3DKAQIECBAICEg9glVZxIgQIAAgSIBsS9ahlEIECBAgEBCQOwTqs4kQIAAAQJFAmJftAyjECBAgACBhIDYJ1SdSYAAAQIEigTEvmgZRiFAgAABAgkBsU+oOpMAAQIECBQJiH3RMoxCgAABAgQSAmKfUHUmAQIECBAoEhD7omUYhQABAgQIJATEPqHqTAIECBAgUCQg9kXLMAoBAgQIEEgIiH1C1ZkECBAgQKBIQOyLlmEUAgQIECCQEBD7hKozCRAgQIBAkYDYFy3DKAQIECBAICEg9glVZxIgQIAAgSIBsS9ahlEIECBAgEBCQOwTqs4kQIAAAQJFAmJftAyjECBAgACBhIDYJ1SdSYAAAQIEigSWl9eff+dZlqVoPKMQIECAAAECawXepf2bd/ZrBT2eAAECBAiUC7x/4y725QszHgECBAgQ2Cog9lsFPZ8AAQIECJQLiH35goxHgAABAgTWCrz/m/3QF/T+/Pi59joeT4AAAQIECDxA4PvvXx+u4gt6D4B3CQIECBAg0CTgY/ymbZiFAAECBAgEBMQ+gOpIAgQIECDQJCD2TdswCwECBAgQCAiIfQDVkQQIECBAoElA7Ju2YRYCBAgQIBAQEPsAqiMJECBAgECTgNg3bcMsBAgQIEAgICD2AVRHEiBAgACBJgGxb9qGWQgQIECAQEBA7AOojiRAgAABAk0CYt+0DbMQIECAAIGAgNgHUB1JgAABAgSaBMS+aRtmIUCAAAECAQGxD6A6kgABAgQINAmIfdM2zEKAAAECBAICYh9AdSQBAgQIEGgSEPumbZiFAAECBAgEBMQ+gOpIAgQIECDQJCD2TdswCwECBAgQCAiIfQDVkQQIECBAoElA7Ju2YRYCBAgQIBAQEPsAqiMJECBAgECTgNg3bcMsBAgQIEAgICD2AVRHEiBAgACBJgGxb9qGWQgQIECAQEBA7AOojiRAgAABAk0CYt+0DbMQIECAAIGAgNgHUB1JgAABAgSaBMS+aRtmIUCAAAECAQGxD6A6kgABAgQINAmIfdM2zEKAAAECBAICYh9AdSQBAgQIEGgSEPumbZiFAAECBAgEBMQ+gOpIAgQIECDQJCD2TdswCwECBAgQCAiIfQDVkQQIECBAoElA7Ju2YRYCBAgQIBAQEPsAqiMJECBAgECTgNg3bcMsBAgQIEAgIDAU+++/fwUu7UgCBAgQIEBgi8Bonz/E/uXlZct1PZcAAQIECBD4QoHPOj70zv4LZ3ZpAgQIECBAYKPAcOxHPyrYOI+nEyBAgAABAgMCa7r8aeyvfZS/5uCBOT2EAAECBAgQmBC41uNr/R5+Z/82i+BPbMVTCBAgQIDATgIzHb4a+1tf1Ju50E736BgCBAgQIHBagVv9vdXtm+/sBf+0ryc3ToAAAQJlArOhv9zG8hr0m/9rtyzL3dv98+Pn3cd4AAECBAgQILBe4N6n6SP/Mn839n9/IxgI/uVxor9+iZ5BgAABAgQ+E7gX+bfn7Bb7twNHo29tBAgQIECAQFZgJPJvE6z6Nv6ag7O36HQCBAgQIHBegbU9XhX7C+vaC5x3Fe6cAAECBAjsK3Bp8EyHV8f+LfgzF9v3lp1GgAABAgTOI7Clu0Nf0Buh9Pf8ESWPIUCAAAECYwJb4v7+CrvFfmx0jyJAgAABAgQeLTD1Mf6jh3Q9AgQIECBAYF5A7OftPJMAAQIECBxCQOwPsSZDEiBAgACBeQGxn7fzTAIECBAgcAgBsT/EmgxJgAABAgTmBcR+3s4zCRAgQIDAIQT+Byl324gmp6B9AAAAAElFTkSuQmCC")}));
  end Reboiler;

  model Condenser
    //  parameter Real HVstart[1] = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, Tf, P, XF1, XF2);
    //  parameter Real HLstart[1] = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    //  parameter Real Cpstart[1] = Property(Propack, "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, Tf, P, XF1, XF2);
    //  parameter Real F = 100;
    parameter Real Tf = 365;
    //  parameter Real Q = 700000;
    //  parameter Real L = 70;
    parameter String Comp1 = "Benzene";
    parameter String Comp2 = "Toluene";
    parameter Real XF1 = 0.5, XF2 = 0.5;
    parameter Real P = 101325;
    parameter String Propack = "NRTL", Prop = "enthalpy", Basis = "Mole", PhasLabel = "Liquid";
    parameter Real R = 3;
    parameter Real T = 350;
    // parameter Real LoutDis = 2;
    // Real Vledata[3];
    Real Vin;
    Real LoutRef, Q(start = 405859), LoutDis;
    Real Y11, HVin;
    Real X1(start = 0.71);
    //  Real Y1(start = 0.5);
    Real X2(start = 0.29);
    //  Real Y2(start = 0.5);
    Real M(start = 10, fixed = true) annotation(isFinalConstraint = true);
    Real HL[1];
    Batch_Distill.Tray_port_Vap_In tray_port_vap_in1 annotation(Placement(visible = true, transformation(origin = {-72, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-72, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Liq_Out tray_port_liq_out1 annotation(Placement(visible = true, transformation(origin = {72, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Liq_Out tray_port_liq_out2 annotation(Placement(visible = true, transformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    Vin = tray_port_vap_in1.M;
    Y11 = tray_port_vap_in1.Comp;
    HVin = tray_port_vap_in1.H;
    LoutDis = Vin * 0.25;
    LoutRef = LoutDis * R;
    X1 = Y11;
    X2 = 1 - X1;
    // HV = Property(Propack, Prop, Basis, "Vapor", Comp1, Comp2, T, P, Y1, Y2);
    HL = Property(Propack, Prop, Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    // Cp = Property("NRTL", "heatCapacityCp", Basis, "Liquid", Comp1, Comp2, T, P, X1, X2);
    // Vledata = PTF("Raoult's Law", P, T, Comp1, Comp2, X1, X2);
    // Y1 = Vledata[2];
    // Y2 = 1 - Y1;
    //X2 = 1 - X1;
    // Vout / M = Vledata[1];
    der(M) = Vin - LoutDis - LoutRef;
    Vin * HVin - (LoutDis + LoutRef) * HL[1] = Q;
  algorithm
    tray_port_liq_out1.M := -LoutDis;
    tray_port_liq_out2.M := -LoutRef;
    tray_port_liq_out1.H := HL[1];
    tray_port_liq_out2.H := HL[1];
    tray_port_liq_out1.Comp := X1;
    tray_port_liq_out2.Comp := X1;
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {-69, -33}, extent = {{165, 53}, {-29, -7}}, imageSource = "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")}), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(origin = {62, -42}, extent = {{24, 4}, {-144, 58}}, imageSource = "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")}));
  end Condenser;

  model Distillaition
    Batch_Distill.Condenser condenser1 annotation(Placement(visible = true, transformation(origin = {37, 85}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
    Batch_Distill.Reboiler reboiler1 annotation(Placement(visible = true, transformation(origin = {62, -84}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
    Batch_Distill.Flash flash2 annotation(Placement(visible = true, transformation(origin = {-53, 47}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
    Batch_Distill.Flash flash1 annotation(Placement(visible = true, transformation(origin = {-54, 6}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Batch_Distill.Flash flash3 annotation(Placement(visible = true, transformation(origin = {-49, -33}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
    Batch_Distill.StrOut strout1 annotation(Placement(visible = true, transformation(origin = {58, 38}, extent = {{-22, -22}, {22, 22}}, rotation = 90)));
  equation
    connect(strout1.tray_port_liq_in1, condenser1.tray_port_liq_out1) annotation(Line(points = {{58, 55}, {58, 62.5}, {60, 62.5}, {60, 70}}));
    connect(flash3.tray_port_vap_in1, reboiler1.tray_port_vap_out1) annotation(Line(points = {{-64, -39}, {-62, -39}, {-62, -74}, {38, -74}, {38, -74}}));
    connect(flash1.tray_port_vap_in1, flash3.tray_port_vap_out1) annotation(Line(points = {{-69, 0}, {-64, 0}, {-64, -27}}));
    connect(flash3.tray_port_liq_out1, reboiler1.tray_port_liq_in1) annotation(Line(points = {{-32, -39}, {87, -39}, {87, -74}}));
    connect(flash1.tray_port_liq_out1, flash3.tray_port_liq_in1) annotation(Line(points = {{-38, 0}, {-38, -8.5}, {-32, -8.5}, {-32, -27}}));
    connect(flash2.tray_port_vap_in1, flash1.tray_port_vap_out1) annotation(Line(points = {{-67, 42}, {-67, 29}, {-69, 29}, {-69, 12}}));
    connect(flash2.tray_port_liq_out1, flash1.tray_port_liq_in1) annotation(Line(points = {{-37, 42}, {-38, 42}, {-38, 11}}));
    connect(condenser1.tray_port_liq_out2, flash2.tray_port_liq_in1) annotation(Line(points = {{15, 69}, {14, 69}, {14, 52}, {-37, 52}}));
    connect(flash2.tray_port_vap_out1, condenser1.tray_port_vap_in1) annotation(Line(points = {{-67, 52}, {-68, 52}, {-68, 95}, {15, 95}}));
    annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
  end Distillaition;

  model StrOut
    Modelica.Blocks.Interfaces.RealOutput Realout1 annotation(Placement(visible = true, transformation(origin = {-80, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-80, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput RealOut2 annotation(Placement(visible = true, transformation(origin = {-80, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-80, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput RealOut3 annotation(Placement(visible = true, transformation(origin = {-76, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-76, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Batch_Distill.Tray_port_Liq_In tray_port_liq_in1 annotation(Placement(visible = true, transformation(origin = {83, 1}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {74, 6}, extent = {{-14, -24}, {22, 12}}, rotation = 0)));
  equation
    Realout1 = tray_port_liq_in1.M;
    RealOut2 = tray_port_liq_in1.Comp;
    RealOut3 = tray_port_liq_in1.H;
    annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(origin = {3.53, -1.59}, fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-64.31, 63.78}, {64.31, -63.78}}, endAngle = 360)}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(origin = {-7.77, 1.06}, fillColor = {85, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-55.12, 60.78}, {69.26, -63.6}}, endAngle = 360)}));
  end StrOut;
end Batch_Distill;
