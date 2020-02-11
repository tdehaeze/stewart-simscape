function [] = displayArchitecture(stewart, args)
% displayArchitecture - 3D plot of the Stewart platform architecture
%
% Syntax: [] = displayArchitecture(args)
%
% Inputs:
%    - stewart
%    - args - Structure with the following fields:
%        - AP   [3x1] - The wanted position of {B} with respect to {A}
%        - ARB  [3x3] - The rotation matrix that gives the wanted orientation of {B} with respect to {A}
%        - ARB  [3x3] - The rotation matrix that gives the wanted orientation of {B} with respect to {A}
%        - F_color [color] - Color used for the Fixed elements
%        - M_color [color] - Color used for the Mobile elements
%        - L_color [color] - Color used for the Legs elements
%        - frames    [true/false] - Display the Frames
%        - legs      [true/false] - Display the Legs
%        - joints    [true/false] - Display the Joints
%        - labels    [true/false] - Display the Labels
%        - platforms [true/false] - Display the Platforms
%
% Outputs:

arguments
    stewart
    args.AP  (3,1) double {mustBeNumeric} = zeros(3,1)
    args.ARB (3,3) double {mustBeNumeric} = eye(3)
    args.F_color = [0 0.4470 0.7410]
    args.M_color = [0.8500 0.3250 0.0980]
    args.L_color = [0 0 0]
    args.frames    logical {mustBeNumericOrLogical} = true
    args.legs      logical {mustBeNumericOrLogical} = true
    args.joints    logical {mustBeNumericOrLogical} = true
    args.labels    logical {mustBeNumericOrLogical} = true
    args.platforms logical {mustBeNumericOrLogical} = true
end

assert(isfield(stewart.platform_F, 'FO_A'), 'stewart.platform_F should have attribute FO_A')
FO_A = stewart.platform_F.FO_A;

assert(isfield(stewart.platform_M, 'MO_B'), 'stewart.platform_M should have attribute MO_B')
MO_B = stewart.platform_M.MO_B;

assert(isfield(stewart.geometry, 'H'),   'stewart.geometry should have attribute H')
H = stewart.geometry.H;

assert(isfield(stewart.platform_F, 'Fa'),   'stewart.platform_F should have attribute Fa')
Fa = stewart.platform_F.Fa;

assert(isfield(stewart.platform_M, 'Mb'),   'stewart.platform_M should have attribute Mb')
Mb = stewart.platform_M.Mb;

figure;
hold on;

FTa = [eye(3), FO_A; ...
       zeros(1,3), 1];
ATb = [args.ARB, args.AP; ...
       zeros(1,3), 1];
BTm = [eye(3), -MO_B; ...
       zeros(1,3), 1];

FTm = FTa*ATb*BTm;

d_unit_vector = H/4;

d_label = H/20;

Ff = [0, 0, 0];
if args.frames
  quiver3(Ff(1)*ones(1,3), Ff(2)*ones(1,3), Ff(3)*ones(1,3), ...
          [d_unit_vector 0 0], [0 d_unit_vector 0], [0 0 d_unit_vector], '-', 'Color', args.F_color)

  if args.labels
    text(Ff(1) + d_label, ...
        Ff(2) + d_label, ...
        Ff(3) + d_label, '$\{F\}$', 'Color', args.F_color);
  end
end

if args.frames
  quiver3(FO_A(1)*ones(1,3), FO_A(2)*ones(1,3), FO_A(3)*ones(1,3), ...
          [d_unit_vector 0 0], [0 d_unit_vector 0], [0 0 d_unit_vector], '-', 'Color', args.F_color)

  if args.labels
    text(FO_A(1) + d_label, ...
         FO_A(2) + d_label, ...
         FO_A(3) + d_label, '$\{A\}$', 'Color', args.F_color);
  end
end

if args.platforms && stewart.platform_F.type == 1
  theta = [0:0.01:2*pi+0.01]; % Angles [rad]
  v = null([0; 0; 1]'); % Two vectors that are perpendicular to the circle normal
  center = [0; 0; 0]; % Center of the circle
  radius = stewart.platform_F.R; % Radius of the circle [m]

  points = center*ones(1, length(theta)) + radius*(v(:,1)*cos(theta) + v(:,2)*sin(theta));

  plot3(points(1,:), ...
        points(2,:), ...
        points(3,:), '-', 'Color', args.F_color);
end

if args.joints
  scatter3(Fa(1,:), ...
           Fa(2,:), ...
           Fa(3,:), 'MarkerEdgeColor', args.F_color);
  if args.labels
    for i = 1:size(Fa,2)
      text(Fa(1,i) + d_label, ...
           Fa(2,i), ...
           Fa(3,i), sprintf('$a_{%i}$', i), 'Color', args.F_color);
    end
  end
end

Fm = FTm*[0; 0; 0; 1]; % Get the position of frame {M} w.r.t. {F}

if args.frames
  FM_uv = FTm*[d_unit_vector*eye(3); zeros(1,3)]; % Rotated Unit vectors
  quiver3(Fm(1)*ones(1,3), Fm(2)*ones(1,3), Fm(3)*ones(1,3), ...
          FM_uv(1,1:3), FM_uv(2,1:3), FM_uv(3,1:3), '-', 'Color', args.M_color)

  if args.labels
    text(Fm(1) + d_label, ...
         Fm(2) + d_label, ...
         Fm(3) + d_label, '$\{M\}$', 'Color', args.M_color);
  end
end

FB = FO_A + args.AP;

if args.frames
  FB_uv = FTm*[d_unit_vector*eye(3); zeros(1,3)]; % Rotated Unit vectors
  quiver3(FB(1)*ones(1,3), FB(2)*ones(1,3), FB(3)*ones(1,3), ...
          FB_uv(1,1:3), FB_uv(2,1:3), FB_uv(3,1:3), '-', 'Color', args.M_color)

  if args.labels
    text(FB(1) - d_label, ...
         FB(2) + d_label, ...
         FB(3) + d_label, '$\{B\}$', 'Color', args.M_color);
  end
end

if args.platforms && stewart.platform_M.type == 1
  theta = [0:0.01:2*pi+0.01]; % Angles [rad]
  v = null((FTm(1:3,1:3)*[0;0;1])'); % Two vectors that are perpendicular to the circle normal
  center = Fm(1:3); % Center of the circle
  radius = stewart.platform_M.R; % Radius of the circle [m]

  points = center*ones(1, length(theta)) + radius*(v(:,1)*cos(theta) + v(:,2)*sin(theta));

  plot3(points(1,:), ...
        points(2,:), ...
        points(3,:), '-', 'Color', args.M_color);
end

if args.joints
  Fb = FTm*[Mb;ones(1,6)];

  scatter3(Fb(1,:), ...
           Fb(2,:), ...
           Fb(3,:), 'MarkerEdgeColor', args.M_color);

  if args.labels
    for i = 1:size(Fb,2)
      text(Fb(1,i) + d_label, ...
           Fb(2,i), ...
           Fb(3,i), sprintf('$b_{%i}$', i), 'Color', args.M_color);
    end
  end
end

if args.legs
  for i = 1:6
    plot3([Fa(1,i), Fb(1,i)], ...
          [Fa(2,i), Fb(2,i)], ...
          [Fa(3,i), Fb(3,i)], '-', 'Color', args.L_color);

    if args.labels
      text((Fa(1,i)+Fb(1,i))/2 + d_label, ...
           (Fa(2,i)+Fb(2,i))/2, ...
           (Fa(3,i)+Fb(3,i))/2, sprintf('$%i$', i), 'Color', args.L_color);
    end
  end
end

view([1 -0.6 0.4]);
axis equal;
axis off;
