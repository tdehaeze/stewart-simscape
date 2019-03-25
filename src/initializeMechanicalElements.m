function [stewart] = initializeMechanicalElements(stewart, opts_param)

opts = struct(...
    'thickness', 10, ... % Thickness of the base and platform [mm]
    'density',   1000, ... % Density of the material used for the hexapod [kg/m3]
    'k_ax',      1e8, ... % Stiffness of each actuator [N/m]
    'c_ax',      1000, ... % Damping of each actuator [N/(m/s)]
    'stroke',    50e-6  ... % Maximum stroke of each actuator [m]
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

BP = struct();

BP.Rint = 0;   % Internal Radius [mm]
BP.Rext = 150; % External Radius [mm]

BP.H = opts.thickness; % Thickness of the Bottom Plate [mm]

BP.density = opts.density; % Density of the material [kg/m3]

BP.color = [0.7 0.7 0.7]; % Color [RGB]

BP.shape = [BP.Rint BP.H; BP.Rint 0; BP.Rext 0; BP.Rext BP.H]; % [mm]

stewart.BP = BP;

TP = struct();

TP.Rint = 0;   % [mm]
TP.Rext = 100; % [mm]

TP.H = 10; % [mm]

TP.density = opts.density; % Density of the material [kg/m3]

TP.color = [0.7 0.7 0.7]; % Color [RGB]

TP.shape = [TP.Rint TP.H; TP.Rint 0; TP.Rext 0; TP.Rext TP.H];

stewart.TP  = TP;

Leg = struct();

Leg.stroke = opts.stroke; % [m]

Leg.k_ax = opts.k_ax; % Stiffness of each leg [N/m]
Leg.c_ax = opts.c_ax; % Damping of each leg [N/(m/s)]

Leg.Rtop = 10; % Radius of the cylinder of the top part of the leg[mm]
Leg.Rbot = 12; % Radius of the cylinder of the bottom part of the leg [mm]

Leg.density = opts.density; % Density of the material used for the legs [kg/m3]

Leg.color = [0.5 0.5 0.5]; % Color of the top part of the leg [RGB]

Leg.R = 1.3*Leg.Rbot; % Size of the sphere at the extremity of the leg [mm]

legs = stewart.Ab - stewart.Aa;
Leg.lenght = norm(legs(1,:))/1.5;

Leg.shape.bot = ...
    [0        0; ...
     Leg.Rbot 0; ...
     Leg.Rbot Leg.lenght; ...
     Leg.Rtop Leg.lenght; ...
     Leg.Rtop 0.2*Leg.lenght; ...
     0        0.2*Leg.lenght];

stewart.Leg = Leg;

SP = struct();

SP.k = 0; % [N*m/deg]
SP.c = 0; % [N*m/deg]

SP.H = stewart.Aa(1, 3) - BP.H; % [mm]

SP.R = Leg.R; % [mm]

SP.section = [0    SP.H-SP.R;
              0    0;
              SP.R 0;
              SP.R SP.H];

SP.density = opts.density; % [kg/m^3]

SP.color = [0.7 0.7 0.7]; % [RGB]

stewart.SP  = SP;
