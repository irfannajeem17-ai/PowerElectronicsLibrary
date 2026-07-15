within PowerElectronicsLibrary;
model PCB_2D_Convection
  extends PCB_2D_Base;

  // Convection parameters
  parameter Boolean topEdge_open    = true;
  parameter Boolean bottomEdge_open = true;
  parameter Boolean leftEdge_open   = true;
  parameter Boolean rightEdge_open  = true;

  // h as time varying signal — one per node
  Modelica.Blocks.Interfaces.RealInput h_input "Convection coefficient [W/m2.K]";

  // Convection components
  Modelica.Thermal.HeatTransfer.Components.Convection conv[N, M];
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature ambient[N, M](
    each T = 298.15);

  // Convection area per node
  parameter Real A_conv[N, M] = array(
    dx * dy
    + (if i == 1 and leftEdge_open   then dy * t else 0)
    + (if i == N and rightEdge_open  then dy * t else 0)
    + (if j == 1 and topEdge_open    then dx * t else 0)
    + (if j == M and bottomEdge_open then dx * t else 0)
    for j in 1:M, i in 1:N);

equation
  for i in 1:N loop
    for j in 1:M loop
      conv[i,j].Gc = h_input * A_conv[i,j];
      connect(node[i,j].port, conv[i,j].solid);
      connect(conv[i,j].fluid, ambient[i,j].port);
    end for;
  end for;

annotation(
    uses(Modelica(version = "4.0.0")));
end PCB_2D_Convection;
