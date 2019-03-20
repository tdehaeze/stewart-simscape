%%
clear; close all; clc;

%%
run stewart_parameters.m

%% Study the effect of the radius of the top platform position of the legs
leg_radius = 50:1:120;
max_disp   = zeros(length(leg_radius), 6);
stiffness  = zeros(length(leg_radius), 6, 6);

for i_leg = 1:length(leg_radius)
    TP.leg.rad = leg_radius(i_leg);
    run stewart_init.m;
    max_disp(i_leg, :) = getMaxPureDisplacement(Leg, J)';
    stiffness(i_leg, :, :) = getStiffnessMatrix(Leg, J);
end

%% Plot everything
figure;
hold on;
plot(leg_radius, max_disp(:, 1))
plot(leg_radius, max_disp(:, 2))
plot(leg_radius, max_disp(:, 3))
hold off;
legend({'tx', 'ty', 'tz'})
xlabel('Leg Radius at the platform'); ylabel('Maximum translation (m)');

figure;
hold on;
plot(leg_radius, max_disp(:, 4))
plot(leg_radius, max_disp(:, 5))
plot(leg_radius, max_disp(:, 6))
hold off;
legend({'rx', 'ry', 'rz'})
xlabel('Leg Radius at the platform'); ylabel('Maximum rotations (rad)');

figure;
hold on;
plot(leg_radius, stiffness(:, 1, 1))
plot(leg_radius, stiffness(:, 2, 2))
plot(leg_radius, stiffness(:, 3, 3))
hold off;
legend({'kx', 'ky', 'kz'})
xlabel('Leg Radius at the platform'); ylabel('Stiffness in translation (N/m)');

figure;
hold on;
plot(leg_radius, stiffness(:, 4, 4))
plot(leg_radius, stiffness(:, 5, 5))
plot(leg_radius, stiffness(:, 6, 6))
hold off;
legend({'mx', 'my', 'mz'})
xlabel('Leg Radius at the platform'); ylabel('Stiffness in rotations (N/(m/rad))');

