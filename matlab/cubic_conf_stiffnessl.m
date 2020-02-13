%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Cubic Stewart platform centered with the cube center - Jacobian estimated at the cube center
% We create a cubic Stewart platform (figure [[fig:cubic_conf_centered_J_center]]) in such a way that the center of the cube (black star) is located at the center of the Stewart platform (blue dot).
% The Jacobian matrix is estimated at the location of the center of the cube.


H = 100e-3;     % height of the Stewart platform [m]
MO_B = -H/2;     % Position {B} with respect to {M} [m]
Hc = H;         % Size of the useful part of the cube [m]
FOc = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 175e-3, 'Mpr', 150e-3);

displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');

% Cubic Stewart platform centered with the cube center - Jacobian not estimated at the cube center
% We create a cubic Stewart platform with center of the cube located at the center of the Stewart platform (figure [[fig:cubic_conf_centered_J_not_center]]).
% The Jacobian matrix is not estimated at the location of the center of the cube.


H    = 100e-3; % height of the Stewart platform [m]
MO_B = 20e-3;  % Position {B} with respect to {M} [m]
Hc   = H;      % Size of the useful part of the cube [m]
FOc  = H/2;    % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 175e-3, 'Mpr', 150e-3);

displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');

% Cubic Stewart platform not centered with the cube center - Jacobian estimated at the cube center
% Here, the "center" of the Stewart platform is not at the cube center (figure [[fig:cubic_conf_not_centered_J_center]]).
% The Jacobian is estimated at the cube center.


H    = 80e-3; % height of the Stewart platform [m]
MO_B = -30e-3;  % Position {B} with respect to {M} [m]
Hc   = 100e-3;      % Size of the useful part of the cube [m]
FOc  = H + MO_B;    % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 175e-3, 'Mpr', 150e-3);

displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');

% Cubic Stewart platform not centered with the cube center - Jacobian estimated at the Stewart platform center
% Here, the "center" of the Stewart platform is not at the cube center.
% The Jacobian is estimated at the center of the Stewart platform.

% The center of the cube is at $z = 110$.
% The Stewart platform is from $z = H_0 = 75$ to $z = H_0 + H_{tot} = 175$.
% The center height of the Stewart platform is then at $z = \frac{175-75}{2} = 50$.
% The center of the cube from the top platform is at $z = 110 - 175 = -65$.


H    = 100e-3; % height of the Stewart platform [m]
MO_B = -H/2;  % Position {B} with respect to {M} [m]
Hc   = 1.5*H;      % Size of the useful part of the cube [m]
FOc  = H/2 + 10e-3;    % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 0, 'MHb', 0);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', ones(6,1));
stewart = computeJacobian(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 215e-3, 'Mpr', 195e-3);

displayArchitecture(stewart, 'labels', false);
scatter3(0, 0, FOc, 200, 'kh');
