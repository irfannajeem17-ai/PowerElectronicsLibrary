within PowerElectronicsLibrary;
partial model PCB_2D_Base

  // Grid parameters
  parameter Integer N = 3 "Number of nodes in x direction";
  parameter Integer M = 3 "Number of nodes in y direction";

  // Geometry
  parameter Real L = 0.1  "PCB length in x [m]";
  parameter Real W = 0.1  "PCB width in y [m]";
  parameter Real t = 0.0016 "PCB thickness [m]";

  // Material
  parameter Real rho = 1900 "Density [kg/m3]";
  parameter Real cp = 1000  "Specific heat [J/kg.K]";
  parameter Real k = 20    "Thermal conductivity [W/m.K]";

  // Heat load table
  parameter Real Q[N, M] = zeros(N, M) "Heat input per node [W]";

  // Derived
  parameter Real dx = L / N;
  parameter Real dy = W / M;
  parameter Real m_node = rho * dx * dy * t;
  parameter Real Rx = dx / (k * dy * t);
  parameter Real Ry_val = dy / (k * dx * t);

  // Internal components
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor node[N, M](
    each C = m_node * cp,
    each T(start = 298.15, fixed = true));

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rx_comp[N-1, M](
    each R = Rx);

  Modelica.Thermal.HeatTransfer.Components.ThermalResistor Ry_comp[N, M-1](
    each R = Ry_val);

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatSource[N, M];

  // Edge ports
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a topPort[N];
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a bottomPort[N];
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a leftPort[M];
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a rightPort[M];

equation
  // Heat loads
  for i in 1:N loop
    for j in 1:M loop
      heatSource[i,j].Q_flow = Q[i,j];
      connect(heatSource[i,j].port, node[i,j].port);
    end for;
  end for;

  // Horizontal resistors (x direction)
  for i in 1:N-1 loop
    for j in 1:M loop
      connect(node[i,j].port, Rx_comp[i,j].port_a);
      connect(Rx_comp[i,j].port_b, node[i+1,j].port);
    end for;
  end for;

  // Vertical resistors (y direction)
  for i in 1:N loop
    for j in 1:M-1 loop
      connect(node[i,j].port, Ry_comp[i,j].port_a);
      connect(Ry_comp[i,j].port_b, node[i,j+1].port);
    end for;
  end for;

  // Edge port connections
  for i in 1:N loop
    connect(node[i,1].port, topPort[i]);
    connect(node[i,M].port, bottomPort[i]);
  end for;

  for j in 1:M loop
    connect(node[1,j].port, leftPort[j]);
    connect(node[N,j].port, rightPort[j]);
  end for;

annotation(
    uses(Modelica(version = "4.0.0")));
end PCB_2D_Base;
