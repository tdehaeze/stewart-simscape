run Formule_Nass.m

%% Bottom Plate
BP = struct();
BP.rad.int = 105 ; %mm
BP.rad.ext = 152.5 ; %mm
BP.leg.rad = 140 ; %mm
BP.leg.ang = 2.5 ; %deg
BP.density = 1000 ; %kg/m^3
BP.k.ax = 1e7/4; %z
BP.k.rad = 9e9/4; %x
BP.k.rrad = 9e9/4; %y
BP.ksi.ax = 10;
BP.ksi.rad = 10;
BP.ksi.rrad = 10;
BP = updateDamping(BP);


%% Tilt
ry = struct();
ry.m = smiData.Solid(26).mass+smiData.Solid(18).mass+smiData.Solid(10).mass;
ry.k.h = 357e6/4; %y
ry.k.rad = 555e6/4; %x
ry.k.rrad = 238e6/4; %z
ry.k.tilt = 1e4 ; % rz in actuator
ry.ksi.h = 10;
ry.ksi.rad = 10;
ry.ksi.rrad = 10;
ry.ksi.tilt = 10;
ry = updateDamping(ry);


%% Spindle
rz = struct();
rz.m = smiData.Solid(12).mass+6*smiData.Solid(20).mass+smiData.Solid(19).mass;
rz.k.ax = 2e9; %x
rz.k.rad = 7e8; %z
rz.k.rrad = 7e8; %y
rz.k.tilt = 1e5;
rz.k.rot = 1e5;
rz.ksi.ax = 10;
rz.ksi.rad = 10;
rz.ksi.rrad = 10;
rz.ksi.tilt = 1;
rz.ksi.rot = 1;
rz = updateDamping(rz);

%% Hexapod Symétrie
hexapod = struct();
hexapod.m = smiData.Solid(16).mass;
hexapod.k.ax = (138e6/6)*1.2; %z
hexapod.ksi.ax = 10;
hexapod = updateDamping(hexapod);

%% Axis Corrector
axisc = struct();
axisc.m = smiData.Solid(30).mass;
axisc.k.ax = 1; % (N*m/deg))
axisc.ksi.ax = 1;
axisc = updateDamping(axisc);

%% NASS
nass = struct();
nass.m = smiData.Solid(27).mass;
nass.k.ax = 5e7; %z
nass.ksi.ax = 10;
nass = updateDamping(nass);

%% Wobble
wob = struct();
wob.m = smiData.Solid(5).mass;
wob.k.ax = 1e10;
wob.ksi.ax = 10;
wob = updateDamping(wob);

%%
function element = updateDamping(element)
    field = fieldnames(element.k);
    for i = 1:length(field)
        element.c.(field{i}) = 1/element.ksi.(field{i})*sqrt(element.k.(field{i})/element.m);
    end
end

