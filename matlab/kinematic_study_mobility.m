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



% Let's now define the actuator stroke.

L_min = -50e-6; % [m]
L_max =  50e-6; % [m]

% Pure translations
% Let's first estimate the mobility in translation when the orientation of the Stewart platform stays the same.

% As shown previously, for such small stroke, we can use the approximate Forward Dynamics solution using the Jacobian matrix:
% \begin{equation*}
%   \delta\bm{\mathcal{L}} = \bm{J} \delta\bm{\mathcal{X}}
% \end{equation*}

% To obtain the mobility "volume" attainable by the Stewart platform when it's orientation is set to zero, we use the spherical coordinate $(r, \theta, \phi)$.

% For each possible value of $(\theta, \phi)$, we compute the maximum radius $r$ attainable with the constraint that the stroke of each actuator should be between =L_min= and =L_max=.

thetas = linspace(0, pi, 50);
phis = linspace(0, 2*pi, 50);
rs = zeros(length(thetas), length(phis));

for i = 1:length(thetas)
  for j = 1:length(phis)
    Tx = sin(thetas(i))*cos(phis(j));
    Ty = sin(thetas(i))*sin(phis(j));
    Tz = cos(thetas(i));

    dL = stewart.kinematics.J*[Tx; Ty; Tz; 0; 0; 0;]; % dL required for 1m displacement in theta/phi direction

    rs(i, j) = max([dL(dL<0)*L_min; dL(dL>0)*L_max]);
  end
end



% #+RESULTS:
% | =L_min= [$\mu m$] | =L_max= [$\mu m$] | =R= [$\mu m$] |
% |-------------------+-------------------+---------------|
% |             -50.0 |              50.0 |          31.5 |


figure;
plot3(reshape(rs.*(sin(thetas)'*cos(phis)), [1, length(thetas)*length(phis)]), ...
      reshape(rs.*(sin(thetas)'*sin(phis)), [1, length(thetas)*length(phis)]), ...
      reshape(rs.*(cos(thetas)'*ones(1, length(phis))), [1, length(thetas)*length(phis)]))
xlabel('X Translation [m]');
ylabel('Y Translation [m]');
zlabel('Z Translation [m]');
