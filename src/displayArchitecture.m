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
    args.frames logical {mustBeNumericOrLogical} = true
    args.legs logical {mustBeNumericOrLogical} = true
    args.joints logical {mustBeNumericOrLogical} = true
    args.labels logical {mustBeNumericOrLogical} = true
    args.platforms logical {mustBeNumericOrLogical} = true
end

figure;
hold on;

FTa = [eye(3), stewart.FO_A; ...
       zeros(1,3), 1];
ATb = [args.ARB, args.AP; ...
       zeros(1,3), 1];
BTm = [eye(3), -stewart.MO_B; ...
       zeros(1,3), 1];

FTm = FTa*ATb*BTm;

d_unit_vector = stewart.H/4;

d_label = stewart.H/20;

Ff = [0, 0, 0];
if args.frames
  quiver3(Ff(1)*ones(1,3), Ff(2)*ones(1,3), Ff(3)*ones(1,3), ...
          [d_unit_vector 0 0], [0 d_unit_vector 0], [0 0 d_unit_vector], '-', 'Color', [0 0.4470 0.7410])

  if args.labels
    text(Ff(1) + d_label, ...
        Ff(2) + d_label, ...
        Ff(3) + d_label, '$\{F\}$', 'Color', [0 0.4470 0.7410]);
  end
end

Fa = stewart.FO_A;

if args.frames
  quiver3(Fa(1)*ones(1,3), Fa(2)*ones(1,3), Fa(3)*ones(1,3), ...
          [d_unit_vector 0 0], [0 d_unit_vector 0], [0 0 d_unit_vector], '-', 'Color', [0 0.4470 0.7410])

  if args.labels
    text(Fa(1) + d_label, ...
         Fa(2) + d_label, ...
         Fa(3) + d_label, '$\{A\}$', 'Color', [0 0.4470 0.7410]);
  end
end

if args.platforms && isfield(stewart, 'platforms') && isfield(stewart.platforms, 'Fpr')
  theta = [0:0.01:2*pi+0.01]; % Angles [rad]
  v = null([0; 0; 1]'); % Two vectors that are perpendicular to the circle normal
  center = [0; 0; 0]; % Center of the circle
  radius = stewart.platforms.Fpr; % Radius of the circle [m]

  points = center*ones(1, length(theta)) + radius*(v(:,1)*cos(theta) + v(:,2)*sin(theta));

  plot3(points(1,:), ...
        points(2,:), ...
        points(3,:), '-', 'Color', [0 0.4470 0.7410]);
end

if args.joints
  scatter3(stewart.Fa(1,:), ...
           stewart.Fa(2,:), ...
           stewart.Fa(3,:), 'MarkerEdgeColor', [0 0.4470 0.7410]);
  if args.labels
    for i = 1:size(stewart.Fa,2)
      text(stewart.Fa(1,i) + d_label, ...
           stewart.Fa(2,i), ...
           stewart.Fa(3,i), sprintf('$a_{%i}$', i), 'Color', [0 0.4470 0.7410]);
    end
  end
end

Fm = FTm*[0; 0; 0; 1]; % Get the position of frame {M} w.r.t. {F}

if args.frames
  FM_uv = FTm*[d_unit_vector*eye(3); zeros(1,3)]; % Rotated Unit vectors
  quiver3(Fm(1)*ones(1,3), Fm(2)*ones(1,3), Fm(3)*ones(1,3), ...
          FM_uv(1,1:3), FM_uv(2,1:3), FM_uv(3,1:3), '-', 'Color', [0.8500 0.3250 0.0980])

  if args.labels
    text(Fm(1) + d_label, ...
         Fm(2) + d_label, ...
         Fm(3) + d_label, '$\{M\}$', 'Color', [0.8500 0.3250 0.0980]);
  end
end

FB = stewart.FO_A + args.AP;

if args.frames
  FB_uv = FTm*[d_unit_vector*eye(3); zeros(1,3)]; % Rotated Unit vectors
  quiver3(FB(1)*ones(1,3), FB(2)*ones(1,3), FB(3)*ones(1,3), ...
          FB_uv(1,1:3), FB_uv(2,1:3), FB_uv(3,1:3), '-', 'Color', [0.8500 0.3250 0.0980])

  if args.labels
    text(FB(1) - d_label, ...
         FB(2) + d_label, ...
         FB(3) + d_label, '$\{B\}$', 'Color', [0.8500 0.3250 0.0980]);
  end
end

if args.platforms && isfield(stewart, 'platforms') && isfield(stewart.platforms, 'Mpr')
  theta = [0:0.01:2*pi+0.01]; % Angles [rad]
  v = null((FTm(1:3,1:3)*[0;0;1])'); % Two vectors that are perpendicular to the circle normal
  center = Fm(1:3); % Center of the circle
  radius = stewart.platforms.Mpr; % Radius of the circle [m]

  points = center*ones(1, length(theta)) + radius*(v(:,1)*cos(theta) + v(:,2)*sin(theta));

  plot3(points(1,:), ...
        points(2,:), ...
        points(3,:), '-', 'Color', [0.8500 0.3250 0.0980]);
end

if args.joints
  Fb = FTm*[stewart.Mb;ones(1,6)];

  scatter3(Fb(1,:), ...
           Fb(2,:), ...
           Fb(3,:), 'MarkerEdgeColor', [0.8500 0.3250 0.0980]);

  if args.labels
    for i = 1:size(Fb,2)
      text(Fb(1,i) + d_label, ...
           Fb(2,i), ...
           Fb(3,i), sprintf('$b_{%i}$', i), 'Color', [0.8500 0.3250 0.0980]);
    end
  end
end

if args.legs
  for i = 1:6
    plot3([stewart.Fa(1,i), Fb(1,i)], ...
          [stewart.Fa(2,i), Fb(2,i)], ...
          [stewart.Fa(3,i), Fb(3,i)], 'k-');

    if args.labels
      text((stewart.Fa(1,i)+Fb(1,i))/2 + d_label, ...
           (stewart.Fa(2,i)+Fb(2,i))/2, ...
           (stewart.Fa(3,i)+Fb(3,i))/2, sprintf('$%i$', i), 'Color', 'k');
    end
  end
end

view([1 -0.6 0.4]);
axis equal;
axis off;
