%% Nass height
Nass = struct();
Nass.h = 90; %mm
Nass.jacobian = 174.5; %mm

%% Bottom Plate
BP = struct();
BP.rad.int = 105 ; %mm
BP.rad.ext = 152.5 ; %mm
BP.thickness = 8; % mm
BP.leg.rad = 142 ; %mm
BP.leg.ang = 5 ; %deg
BP.density = 8000 ; %kg/m^3
BP.color = [0.5 0.5 0.5] ; %rgb

%% TOP Plate
TP = struct();
TP.rad.int = 0 ;%mm
TP.rad.ext = 120 ; %mm
TP.thickness = 8; % mm
TP.leg.rad = 100 ; %mm
TP.leg.ang = 5 ; %deg
TP.density = 8000 ; %kg/m^3
TP.color = [0.5 0.5 0.5] ; %rgb

%% Leg
Leg = struct();
Leg.rad.bottom = 8 ; %mm
Leg.rad.top = 5 ; %mm
Leg.sphere.bottom = 10 ; % mm
Leg.sphere.top = 8 ; % mm
Leg.density = 8000 ; %kg/m^3
Leg.lenght = Nass.h; % mm (approximate)
Leg.m = Leg.density*2*pi*((Leg.rad.bottom*1e-3)^2)*(Leg.lenght*1e-3); %kg
Leg.color.bottom = [0.5 0.5 0.5] ; %rgb
Leg.color.top = [0.5 0.5 0.5] ; %rgb
Leg.k.ax = 5e7; % N/m
Leg.ksi.ax = 10 ;
Leg = updateDamping(Leg);


%% Sphere
SP = struct();
SP.thickness.bottom = 1 ; %mm
SP.thickness.top = 1 ; %mm
SP.rad.bottom = Leg.sphere.bottom ; %mm
SP.rad.top = Leg.sphere.top ; %mm
SP.height.bottom = 5 ; %mm
SP.height.top = 5 ; %mm
SP.density.bottom = 8000 ; %kg/m^3
SP.density.top = 8000 ; %kg/m^3
SP.m = SP.density.bottom*2*pi*((SP.rad.bottom*1e-3)^2)*(SP.height.bottom*1e-3); %kg
SP.color.bottom = [0.5 0.5 0.5] ; %rgb
SP.color.top = [0.5 0.5 0.5] ; %rgb
SP.k.ax = 0 ; % N*m/deg
SP.ksi.ax = 1 ;
SP = updateDamping(SP);

%%
function element = updateDamping(element)
    field = fieldnames(element.k);
    for i = 1:length(field)
        element.c.(field{i}) = 1/element.ksi.(field{i})*sqrt(element.k.(field{i})/element.m);
    end
end
