%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Stewart architecture definition
% Let's first define the Stewart platform architecture that we want to study.

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', 90e-3, 'MO_B', 45e-3);
stewart = generateGeneralConfiguration(stewart);
stewart = computeJointsPose(stewart);
stewart = initializeStewartPose(stewart);
stewart = initializeCylindricalPlatforms(stewart);
stewart = initializeCylindricalStruts(stewart);
stewart = initializeStrutDynamics(stewart);
stewart = initializeJointDynamics(stewart);
stewart = computeJacobian(stewart);

% Wanted translations and rotations
% Let's now define the wanted extreme translations and rotations.

Tx_max = 50e-6; % Translation [m]
Ty_max = 50e-6; % Translation [m]
Tz_max = 50e-6; % Translation [m]
Rx_max = 30e-6; % Rotation [rad]
Ry_max = 30e-6; % Rotation [rad]
Rz_max = 0;     % Rotation [rad]

% Needed stroke for "pure" rotations or translations
% As a first estimation, we estimate the needed actuator stroke for "pure" rotations and translation.
% We do that using either the Inverse Kinematic solution or the Jacobian matrix as an approximation.


LTx = stewart.kinematics.J*[Tx_max 0 0 0 0 0]';
LTy = stewart.kinematics.J*[0 Ty_max 0 0 0 0]';
LTz = stewart.kinematics.J*[0 0 Tz_max 0 0 0]';
LRx = stewart.kinematics.J*[0 0 0 Rx_max 0 0]';
LRy = stewart.kinematics.J*[0 0 0 0 Ry_max 0]';
LRz = stewart.kinematics.J*[0 0 0 0 0 Rz_max]';



% The obtain required stroke is:

ans = sprintf('From %.2g[m] to %.2g[m]: Total stroke = %.1f[um]', min(min([LTx,LTy,LTz,LRx,LRy])), max(max([LTx,LTy,LTz,LRx,LRy])), 1e6*(max(max([LTx,LTy,LTz,LRx,LRy]))-min(min([LTx,LTy,LTz,LRx,LRy]))))

% Needed stroke for "combined" rotations or translations
% We know would like to have a more precise estimation.

% To do so, we may estimate the required actuator stroke for all possible combination of translation and rotation.

% Let's first generate all the possible combination of maximum translation and rotations.

Ps = [2*(dec2bin(0:5^2-1,5)-'0')-1, zeros(5^2, 1)].*[Tx_max Ty_max Tz_max Rx_max Ry_max Rz_max];



% #+RESULTS:
% | *Tx [m]* | *Ty [m]* | *Tz [m]* | *Rx [rad]* | *Ry [rad]* | *Rz [rad]* |
% |----------+----------+----------+------------+------------+------------|
% | -5.0e-05 | -5.0e-05 | -5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 | -5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 | -5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 | -5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 |  5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 |  5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 |  5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 | -5.0e-05 |  5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 | -5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 | -5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 | -5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 | -5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 |  5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 |  5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 |  5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% | -5.0e-05 |  5.0e-05 |  5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 | -5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 | -5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 | -5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 | -5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 |  5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 |  5.0e-05 |   -3.0e-05 |    3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 |  5.0e-05 |    3.0e-05 |   -3.0e-05 |    0.0e+00 |
% |  5.0e-05 | -5.0e-05 |  5.0e-05 |    3.0e-05 |    3.0e-05 |    0.0e+00 |
% |  5.0e-05 |  5.0e-05 | -5.0e-05 |   -3.0e-05 |   -3.0e-05 |    0.0e+00 |

% For all possible combination, we compute the required actuator stroke using the inverse kinematic solution.

L_min = 0;
L_max = 0;

for i = 1:size(Ps,1)
  Rx = [1 0        0;
        0 cos(Ps(i, 4)) -sin(Ps(i, 4));
        0 sin(Ps(i, 4))  cos(Ps(i, 4))];

  Ry = [ cos(Ps(i, 5)) 0 sin(Ps(i, 5));
        0        1 0;
        -sin(Ps(i, 5)) 0 cos(Ps(i, 5))];

  Rz = [cos(Ps(i, 6)) -sin(Ps(i, 6)) 0;
        sin(Ps(i, 6))  cos(Ps(i, 6)) 0;
        0        0       1];

  ARB = Rz*Ry*Rx;
  [~, Ls] = inverseKinematics(stewart, 'AP', Ps(i, 1:3)', 'ARB', ARB);

  if min(Ls) < L_min
    L_min = min(Ls)
  end
  if max(Ls) > L_max
    L_max = max(Ls)
  end
end



% We obtain the required actuator stroke:

ans = sprintf('From %.2g[m] to %.2g[m]: Total stroke = %.1f[um]', L_min, L_max, 1e6*(L_max-L_min))
