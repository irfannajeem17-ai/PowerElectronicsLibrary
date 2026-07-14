within PowerElectronicsLibrary;

model PCB_2D_Conduction
  extends PCB_2D_Base;

  parameter Real T_amb = 298.15 "Ambient temperature [K]";

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTop[N](each T = T_amb);
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedBottom[N](each T = T_amb);
  

   Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedLeft[max(1, M-2)](each T = T_amb) if M >= 2;        
   Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedRight[max(1, M-2)](each T = T_amb) if M >= 2;

equation
  for i in 1:N loop
    connect(topPort[i], fixedTop[i].port);
    connect(bottomPort[i], fixedBottom[i].port);
  end for;

  for j in 2:M-1 loop
    connect(leftPort[j], fixedLeft[j-1].port);
    connect(rightPort[j], fixedRight[j-1].port);
  end for;

annotation(
    Icon(
      graphics={
        Bitmap(
          extent={{-100, -100}, {100, 100}},
          fileName="modelica://PowerElectronicsLibrary/Resources/Icons/66282-200.png"
        )
      }
    ),
    uses(Modelica(version = "4.0.0")));
end PCB_2D_Conduction;
