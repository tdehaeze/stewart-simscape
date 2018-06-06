%%
clear; close all; clc;

%% Stewart Object
stewart = struct();
stewart.h        = 350; % Total height of the platform [mm]
stewart.jacobian = 435; % Point where the Jacobian is computed => Center of rotation [mm]

%% Bottom Plate
BP = struct();

BP.rad.int   = 110;   % Internal Radius [mm]
BP.rad.ext   = 207.5; % External Radius [mm]
BP.thickness = 26;    % Thickness [mm]
BP.leg.rad   = 175.5; % Radius where the legs articulations are positionned [mm]
BP.leg.ang   = 9.5;   % Angle Offset [deg]
BP.density   = 8000;  % Density of the material [kg/m^3]
BP.color     = [0.6 0.6 0.6]; % Color [rgb]
BP.shape     = [BP.rad.int BP.thickness; BP.rad.int 0; BP.rad.ext 0; BP.rad.ext BP.thickness];

%% Top Plate
TP = struct();

TP.rad.int   = 82;   % Internal Radius [mm]
TP.rad.ext   = 150;  % Internal Radius [mm]
TP.thickness = 26;   % Thickness [mm]
TP.leg.rad   = 118;  % Radius where the legs articulations are positionned [mm]
TP.leg.ang   = 12.1; % Angle Offset [deg]
TP.density   = 8000; % Density of the material [kg/m^3]
TP.color     = [0.6 0.6 0.6]; % Color [rgb]
TP.shape     = [TP.rad.int TP.thickness; TP.rad.int 0; TP.rad.ext 0; TP.rad.ext TP.thickness];

%% Leg
Leg = struct(); 

Leg.stroke     = 10e-3; % Maximum Stroke of each leg [m]
Leg.k.ax       = 5e7; % Stiffness of each leg [N/m]
Leg.ksi.ax     = 10; % Maximum amplification at resonance []
Leg.rad.bottom = 25; % Radius of the cylinder of the bottom part [mm]
Leg.rad.top    = 17; % Radius of the cylinder of the top part [mm]
Leg.density    = 8000; % Density of the material [kg/m^3]
Leg.color.bottom  = [0.5 0.5 0.5]; % Color [rgb]
Leg.color.top     = [0.5 0.5 0.5]; % Color [rgb]

Leg.sphere.bottom = Leg.rad.bottom; % Size of the sphere at the end of the leg [mm]
Leg.sphere.top    = Leg.rad.top; % Size of the sphere at the end of the leg [mm]
Leg.m             = TP.density*((pi*(TP.rad.ext/1000)^2)*(TP.thickness/1000)-(pi*(TP.rad.int/1000^2))*(TP.thickness/1000))/6; % TODO [kg]
Leg = updateDamping(Leg);


%% Sphere
SP = struct();

SP.height.bottom  = 27; % [mm]
SP.height.top     = 27; % [mm]
SP.density.bottom = 8000; % [kg/m^3]
SP.density.top    = 8000; % [kg/m^3]
SP.color.bottom   = [0.6 0.6 0.6]; % [rgb]
SP.color.top      = [0.6 0.6 0.6]; % [rgb]
SP.k.ax           = 0; % [N*m/deg]
SP.ksi.ax         = 10;

SP.thickness.bottom = SP.height.bottom-Leg.sphere.bottom; % [mm]
SP.thickness.top    = SP.height.top-Leg.sphere.top; % [mm]
SP.rad.bottom       = Leg.sphere.bottom; % [mm]
SP.rad.top          = Leg.sphere.top; % [mm]
SP.m                = SP.density.bottom*2*pi*((SP.rad.bottom*1e-3)^2)*(SP.height.bottom*1e-3); % TODO [kg]

SP = updateDamping(SP);

%%
Leg.support.bottom = [0 SP.thickness.bottom; 0 0; SP.rad.bottom 0; SP.rad.bottom SP.height.bottom];
Leg.support.top    = [0 SP.thickness.top; 0 0; SP.rad.top 0; SP.rad.top SP.height.top];

%%
stewart.BP = BP;
stewart.TP = TP;
stewart.Leg = Leg;
stewart.SP = SP;

%%
stewart = initializeParameters(stewart);

%%
clear BP TP Leg SP;

%%
function element = updateDamping(element)
    field = fieldnames(element.k);
    for i = 1:length(field)
        element.c.(field{i}) = 1/element.ksi.(field{i})*sqrt(element.k.(field{i})/element.m);
    end
end
