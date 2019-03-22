function [stewart] = initializeHexapod(opts_param)

opts = struct(...
    'height',  90,    ... % Height of the platform [mm]
    'density', 8000,  ... % Density of the material used for the hexapod [kg/m3]
    'k_ax',    1e8,   ... % Stiffness of each actuator [N/m]
    'c_ax',    100,   ... % Damping of each actuator [N/(m/s)]
    'stroke',  50e-6, ... % Maximum stroke of each actuator [m]
    'name',    'stewart' ... % Name of the file
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

stewart = struct();

stewart.H = opts.height; % [mm]

BP = struct();

BP.Rint = 0;   % Internal Radius [mm]
BP.Rext = 150; % External Radius [mm]

BP.H = 10; % Thickness of the Bottom Plate [mm]

BP.Rleg  = 100; % Radius where the legs articulations are positionned [mm]
BP.alpha = 10;  % Angle Offset [deg]

BP.density = opts.density; % Density of the material [kg/m3]

BP.color = [0.7 0.7 0.7]; % Color [RGB]

BP.shape = [BP.Rint BP.H; BP.Rint 0; BP.Rext 0; BP.Rext BP.H]; % [mm]

stewart.BP = BP;

TP = struct();

TP.Rint = 0;   % [mm]
TP.Rext = 100; % [mm]

TP.H = 10; % [mm]

TP.Rleg   = 100; % Radius where the legs articulations are positionned [mm]
TP.alpha  = 20; % Angle [deg]
TP.dalpha = 0; % Angle Offset from 0 position [deg]

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

stewart.Leg = Leg;

SP = struct();

SP.k = 0; % [N*m/deg]
SP.c = 0; % [N*m/deg]

SP.H = 15; % [mm]

SP.R = Leg.R; % [mm]

SP.section = [0    SP.H-SP.R;
              0    0;
              SP.R 0;
              SP.R SP.H];

SP.density = opts.density; % [kg/m^3]

SP.color = [0.7 0.7 0.7]; % [RGB]

stewart.SP  = SP;

stewart = initializeParameters(stewart);

save('./mat/stewart.mat', 'stewart')

function [stewart] = initializeParameters(stewart)

stewart.Aa = zeros(6, 3); % [mm]
stewart.Ab = zeros(6, 3); % [mm]
stewart.Bb = zeros(6, 3); % [mm]

for i = 1:3
    stewart.Aa(2*i-1,:) = [stewart.BP.Rleg*cos( pi/180*(120*(i-1) - stewart.BP.alpha) ), ...
                           stewart.BP.Rleg*sin( pi/180*(120*(i-1) - stewart.BP.alpha) ), ...
                           stewart.BP.H+stewart.SP.H];
    stewart.Aa(2*i,:)   = [stewart.BP.Rleg*cos( pi/180*(120*(i-1) + stewart.BP.alpha) ), ...
                           stewart.BP.Rleg*sin( pi/180*(120*(i-1) + stewart.BP.alpha) ), ...
                           stewart.BP.H+stewart.SP.H];

    stewart.Ab(2*i-1,:) = [stewart.TP.Rleg*cos( pi/180*(120*(i-1) + stewart.TP.dalpha - stewart.TP.alpha) ), ...
                           stewart.TP.Rleg*sin( pi/180*(120*(i-1) + stewart.TP.dalpha - stewart.TP.alpha) ), ...
                           stewart.H - stewart.TP.H - stewart.SP.H];
    stewart.Ab(2*i,:)   = [stewart.TP.Rleg*cos( pi/180*(120*(i-1) + stewart.TP.dalpha + stewart.TP.alpha) ), ...
                           stewart.TP.Rleg*sin( pi/180*(120*(i-1) + stewart.TP.dalpha + stewart.TP.alpha) ), ...
                           stewart.H - stewart.TP.H - stewart.SP.H];
end

stewart.Bb = stewart.Ab - stewart.H*[0,0,1];

leg_length = zeros(6, 1); % [mm]
leg_vectors = zeros(6, 3);

legs = stewart.Ab - stewart.Aa;

for i = 1:6
    leg_length(i) = norm(legs(i,:));
    leg_vectors(i,:) = legs(i,:) / leg_length(i);
end

stewart.Leg.lenght = leg_length(1)/1.5;
stewart.Leg.shape.bot = ...
    [0                0; ...
     stewart.Leg.Rbot 0; ...
     stewart.Leg.Rbot stewart.Leg.lenght; ...
     stewart.Leg.Rtop stewart.Leg.lenght; ...
     stewart.Leg.Rtop 0.2*stewart.Leg.lenght; ...
     0                0.2*stewart.Leg.lenght];

stewart.Rm = struct('R', eye(3));

for i = 1:6
  sx = cross(leg_vectors(i,:), [1 0 0]);
  sx = sx/norm(sx);

  sy = -cross(sx, leg_vectors(i,:));
  sy = sy/norm(sy);

  sz = leg_vectors(i,:);
  sz = sz/norm(sz);

  stewart.Rm(i).R = [sx', sy', sz'];
end

J = zeros(6);

for i = 1:6
  J(i, 1:3) = leg_vectors(i, :);
  J(i, 4:6) = cross(0.001*stewart.Bb(i, :), leg_vectors(i, :));
end

stewart.J = J;

stewart.K = stewart.Leg.k_ax*stewart.J'*stewart.J;

end
end
