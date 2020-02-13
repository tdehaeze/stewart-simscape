%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Analysis
% We initialize the wanted cube's size.

Hcs = 1e-3*[250:20:350]; % Heights for the Cube [m]
Ks = zeros(6, 6, length(Hcs));



% The height of the Stewart platform is fixed:

H    = 100e-3; % height of the Stewart platform [m]



% The frames $\{A\}$ and $\{B\}$ are positioned at the Stewart platform center as well as the cube's center:

MO_B = -50e-3;  % Position {B} with respect to {M} [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
for i = 1:length(Hcs)
  Hc = Hcs(i);
  stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
  stewart = computeJointsPose(stewart);
  stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
  stewart = computeJacobian(stewart);
  Ks(:,:,i) = stewart.kinematics.K;
end



% We find that for all the cube's size, $k_x = k_y = k_z = k$ where $k$ is the strut stiffness.
% We also find that $k_{\theta_x} = k_{\theta_y}$ and $k_{\theta_z}$ are varying with the cube's size (figure [[fig:stiffness_cube_size]]).


figure;
hold on;
plot(Hcs, squeeze(Ks(4, 4, :)), 'DisplayName', '$k_{\theta_x} = k_{\theta_y}$');
plot(Hcs, squeeze(Ks(6, 6, :)), 'DisplayName', '$k_{\theta_z}$');
hold off;
legend('location', 'northwest');
xlabel('Cube Size [m]'); ylabel('Rotational stiffnes [normalized]');
