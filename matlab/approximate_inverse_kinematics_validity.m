

simulinkproject('./');

% Stewart architecture definition
% We first define some general Stewart architecture.

stewart = initializeFramesPositions('H', 90e-3, 'MO_B', 45e-3);
stewart = generateGeneralConfiguration(stewart);
stewart = computeJointsPose(stewart);
stewart = initializeStewartPose(stewart);
stewart = initializeCylindricalPlatforms(stewart);
stewart = initializeCylindricalStruts(stewart);
stewart = initializeStrutDynamics(stewart);
stewart = initializeJointDynamics(stewart);
stewart = computeJacobian(stewart);

% Comparison for "pure" translations
% Let's first compare the perfect and approximate solution of the inverse for pure $x$ translations.

% We compute the approximate and exact required strut stroke to have the wanted mobile platform $x$ displacement.
% The estimate required strut stroke for both the approximate and exact solutions are shown in Figure [[fig:inverse_kinematics_approx_validity_x_translation]].
% The relative strut length displacement is shown in Figure [[fig:inverse_kinematics_approx_validity_x_translation_relative]].

Xrs = logspace(-6, -1, 100); % Wanted X translation of the mobile platform [m]

Ls_approx = zeros(6, length(Xrs));
Ls_exact = zeros(6, length(Xrs));

for i = 1:length(Xrs)
  Xr = Xrs(i);
  L_approx(:, i) = stewart.J*[Xr; 0; 0; 0; 0; 0;];
  [~, L_exact(:, i)] = inverseKinematics(stewart, 'AP', [Xr; 0; 0]);
end

figure;
hold on;
for i = 1:6
  set(gca,'ColorOrderIndex',i);
  plot(Xrs, abs(L_approx(i, :)));
  set(gca,'ColorOrderIndex',i);
  plot(Xrs, abs(L_exact(i, :)), '--');
end
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Wanted $x$ displacement [m]');
ylabel('Estimated required stroke');



% #+NAME: fig:inverse_kinematics_approx_validity_x_translation
% #+CAPTION: Comparison of the Approximate solution and True solution for the Inverse kinematic problem ([[./figs/inverse_kinematics_approx_validity_x_translation.png][png]], [[./figs/inverse_kinematics_approx_validity_x_translation.pdf][pdf]])
% [[file:figs/inverse_kinematics_approx_validity_x_translation.png]]


figure;
hold on;
for i = 1:6
  plot(Xrs, abs(L_approx(i, :) - L_exact(i, :))./abs(L_approx(i, :) + L_exact(i, :)), 'k-');
end
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Wanted $x$ displacement [m]');
ylabel('Relative Stroke Error');
