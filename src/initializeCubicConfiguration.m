function [stewart] = initializeCubicConfiguration(opts_param)

opts = struct(...
    'H_tot', 90,  ... % Total height of the Hexapod [mm]
    'L',     110, ... % Size of the Cube [mm]
    'H',     40,  ... % Height between base joints and platform joints [mm]
    'H0',    75   ... % Height between the corner of the cube and the plane containing the base joints [mm]
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

points = [0, 0, 0; ...
          0, 0, 1; ...
          0, 1, 0; ...
          0, 1, 1; ...
          1, 0, 0; ...
          1, 0, 1; ...
          1, 1, 0; ...
          1, 1, 1];
points = opts.L*points;

sx = cross([1, 1, 1], [1 0 0]);
sx = sx/norm(sx);

sy = -cross(sx, [1, 1, 1]);
sy = sy/norm(sy);

sz = [1, 1, 1];
sz = sz/norm(sz);

R = [sx', sy', sz']';

cube = zeros(size(points));
for i = 1:size(points, 1)
  cube(i, :) = R * points(i, :)';
end

leg_indices = [3, 4; ...
               2, 4; ...
               2, 6; ...
               5, 6; ...
               5, 7; ...
               3, 7];

legs = zeros(6, 3);
legs_start = zeros(6, 3);

for i = 1:6
  legs(i, :) = cube(leg_indices(i, 2), :) - cube(leg_indices(i, 1), :);
  legs_start(i, :) = cube(leg_indices(i, 1), :);
end

Hmax = cube(4, 3) - cube(2, 3);
if opts.H0 < cube(2, 3)
  error(sprintf('H0 is not high enought. Minimum H0 = %.1f', cube(2, 3)));
else if opts.H0 + opts.H > cube(4, 3)
  error(sprintf('H0+H is too high. Maximum H0+H = %.1f', cube(4, 3)));
  error('H0+H is too high');
end

Aa = zeros(6, 3);
for i = 1:6
  t = (opts.H0-legs_start(i, 3))/(legs(i, 3));
  Aa(i, :) = legs_start(i, :) + t*legs(i, :);
end

Ab = zeros(6, 3);
for i = 1:6
  t = (opts.H0+opts.H-legs_start(i, 3))/(legs(i, 3));
  Ab(i, :) = legs_start(i, :) + t*legs(i, :);
end

Bb = zeros(6, 3);
Bb = Ab - (opts.H0 + opts.H_tot/2 + opts.H/2)*[0, 0, 1];

h = opts.H0 + opts.H/2 - opts.H_tot/2;
Aa = Aa - h*[0, 0, 1];
Ab = Ab - h*[0, 0, 1];

stewart = struct();
  stewart.Aa = Aa;
  stewart.Ab = Ab;
  stewart.Bb = Bb;
  stewart.H_tot = opts.H_tot;
end
