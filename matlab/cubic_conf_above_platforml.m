%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Having Cube's center above the top platform
% Let's say we want to have a diagonal stiffness matrix when $\{A\}$ and $\{B\}$ are located above the top platform.
% Thus, we want the cube's center to be located above the top center.

% Let's fix the Height of the Stewart platform and the position of frames $\{A\}$ and $\{B\}$:

H    = 100e-3; % height of the Stewart platform [m]
MO_B = 20e-3;  % Position {B} with respect to {M} [m]



% We find the several Cubic configuration for the Stewart platform where the center of the cube is located at frame $\{A\}$.
% The differences between the configuration are the cube's size:
% - Small Cube Size in Figure [[fig:stewart_cubic_conf_type_1]]
% - Medium Cube Size in Figure [[fig:stewart_cubic_conf_type_2]]
% - Large Cube Size in Figure [[fig:stewart_cubic_conf_type_3]]

% For each of the configuration, the Stiffness matrix is diagonal with $k_x = k_y = k_y = 2k$ with $k$ is the stiffness of each strut.
% However, the rotational stiffnesses are increasing with the cube's size but the required size of the platform is also increasing, so there is a trade-off here.


Hc   = 0.4*H;    % Size of the useful part of the cube [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), 'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));
displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');



% #+name: tab:stewart_cubic_conf_type_1
% #+caption: Stiffness Matrix
% #+RESULTS:
% |        2 |        0 | -2.8e-16 |        0 |  2.4e-17 |       0 |
% |        0 |        2 |        0 | -2.3e-17 |        0 |       0 |
% | -2.8e-16 |        0 |        2 | -2.1e-19 |        0 |       0 |
% |        0 | -2.3e-17 | -2.1e-19 |   0.0024 | -5.4e-20 | 6.5e-19 |
% |  2.4e-17 |        0 |  4.9e-19 | -2.3e-20 |   0.0024 |       0 |
% | -1.2e-18 |  1.1e-18 |        0 |  6.2e-19 |        0 |  0.0096 |


Hc   = 1.5*H;    % Size of the useful part of the cube [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), 'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));
displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');



% #+name: tab:stewart_cubic_conf_type_2
% #+caption: Stiffness Matrix
% #+RESULTS:
% |        2 |        0 | -1.9e-16 |        0 | 5.6e-17 |       0 |
% |        0 |        2 |        0 | -7.6e-17 |       0 |       0 |
% | -1.9e-16 |        0 |        2 |  2.5e-18 | 2.8e-17 |       0 |
% |        0 | -7.6e-17 |  2.5e-18 |    0.034 | 8.7e-19 | 8.7e-18 |
% |  5.7e-17 |        0 |  3.2e-17 |  2.9e-19 |   0.034 |       0 |
% |   -1e-18 | -1.3e-17 |  5.6e-17 |  8.4e-18 |       0 |    0.14 |


Hc   = 2.5*H;    % Size of the useful part of the cube [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), 'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));
displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');
