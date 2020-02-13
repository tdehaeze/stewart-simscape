%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Cube's center at the Center of Mass of the mobile platform
% Let's create a Cubic Stewart Platform where the *Center of Mass of the mobile platform is located at the center of the cube*.

% We define the size of the Stewart platform and the position of frames $\{A\}$ and $\{B\}$.

H    = 200e-3; % height of the Stewart platform [m]
MO_B = -10e-3;  % Position {B} with respect to {M} [m]



% Now, we set the cube's parameters such that the center of the cube is coincident with $\{A\}$ and $\{B\}$.

Hc   = 2.5*H;    % Size of the useful part of the cube [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 25e-3, 'MHb', 25e-3);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', 1e6*ones(6,1), 'C', 1e1*ones(6,1));
stewart = initializeJointDynamics(stewart, 'type_F', 'universal', 'type_M', 'spherical');
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);



% Now we set the geometry and mass of the mobile platform such that its center of mass is coincident with $\{A\}$ and $\{B\}$.

stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), ...
                                                  'Mpm', 10, ...
                                                  'Mph', 20e-3, ...
                                                  'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));



% And we set small mass for the struts.

stewart = initializeCylindricalStruts(stewart, 'Fsm', 1e-3, 'Msm', 1e-3);
stewart = initializeInertialSensor(stewart);



% No flexibility below the Stewart platform and no payload.

ground = initializeGround('type', 'none');
payload = initializePayload('type', 'none');



% The obtain geometry is shown in figure [[fig:stewart_cubic_conf_decouple_dynamics]].


displayArchitecture(stewart, 'labels', false, 'view', 'all');



% #+name: fig:stewart_cubic_conf_decouple_dynamics
% #+caption: Geometry used for the simulations - The cube's center, the frames $\{A\}$ and $\{B\}$ and the Center of mass of the mobile platform are coincident ([[./figs/stewart_cubic_conf_decouple_dynamics.png][png]], [[./figs/stewart_cubic_conf_decouple_dynamics.pdf][pdf]])
% [[file:figs/stewart_cubic_conf_decouple_dynamics.png]]

% We now identify the dynamics from forces applied in each strut $\bm{\tau}$ to the displacement of each strut $d \bm{\mathcal{L}}$.

open('stewart_platform_model.slx')

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_platform_model';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Controller'],        1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Stewart Platform'],  1, 'openoutput', [], 'dLm'); io_i = io_i + 1; % Relative Displacement Outputs [m]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Dm1', 'Dm2', 'Dm3', 'Dm4', 'Dm5', 'Dm6'};



% Now, thanks to the Jacobian (Figure [[fig:local_to_cartesian_coordinates]]), we compute the transfer function from $\bm{\mathcal{F}}$ to $\bm{\mathcal{X}}$.

Gc = inv(stewart.kinematics.J)*G*inv(stewart.kinematics.J');
Gc.InputName  = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
Gc.OutputName = {'Dx', 'Dy', 'Dz', 'Rx', 'Ry', 'Rz'};



% The obtain dynamics $\bm{G}_{c}(s) = \bm{J}^{-T} \bm{G}(s) \bm{J}^{-1}$ is shown in Figure [[fig:stewart_cubic_decoupled_dynamics_cartesian]].


freqs = logspace(1, 3, 500);

figure;

ax1 = subplot(2, 2, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(Gc(1, 1), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(2, 2), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(3, 3), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 2, 3);
hold on;
for i = 1:6
  for j = i+1:6
    p4 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(1, 1), freqs, 'Hz'))));
p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(2, 2), freqs, 'Hz'))));
p3 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(3, 3), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2, p3, p4], {'$D_x/F_x$','$D_y/F_y$',  '$D_z/F_z$', '$D_i/F_j$'})

ax2 = subplot(2, 2, 2);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(Gc(4, 4), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(5, 5), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(6, 6), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax4 = subplot(2, 2, 4);
hold on;
for i = 1:6
  for j = i+1:6
    p4 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(4, 4), freqs, 'Hz'))));
p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(5, 5), freqs, 'Hz'))));
p3 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(6, 6), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2, p3, p4], {'$R_x/M_x$','$R_y/M_y$',  '$R_z/M_z$', '$R_i/M_j$'})

linkaxes([ax1,ax2,ax3,ax4],'x');

% Cube's center not coincident with the Mass of the Mobile platform
% Let's create a Stewart platform with a cubic architecture where the cube's center is at the center of the Stewart platform.

H    = 200e-3; % height of the Stewart platform [m]
MO_B = -100e-3;  % Position {B} with respect to {M} [m]



% Now, we set the cube's parameters such that the center of the cube is coincident with $\{A\}$ and $\{B\}$.

Hc   = 2.5*H;    % Size of the useful part of the cube [m]
FOc  = H + MO_B; % Center of the cube with respect to {F}

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateCubicConfiguration(stewart, 'Hc', Hc, 'FOc', FOc, 'FHa', 25e-3, 'MHb', 25e-3);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', 1e6*ones(6,1), 'C', 1e1*ones(6,1));
stewart = initializeJointDynamics(stewart, 'type_F', 'universal', 'type_M', 'spherical');
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);



% However, the Center of Mass of the mobile platform is *not* located at the cube's center.

stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), ...
                                                  'Mpm', 10, ...
                                                  'Mph', 20e-3, ...
                                                  'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));



% And we set small mass for the struts.

stewart = initializeCylindricalStruts(stewart, 'Fsm', 1e-3, 'Msm', 1e-3);
stewart = initializeInertialSensor(stewart);



% No flexibility below the Stewart platform and no payload.

ground = initializeGround('type', 'none');
payload = initializePayload('type', 'none');



% The obtain geometry is shown in figure [[fig:stewart_cubic_conf_mass_above]].

displayArchitecture(stewart, 'labels', false, 'view', 'all');



% #+name: fig:stewart_cubic_conf_mass_above
% #+caption: Geometry used for the simulations - The cube's center is coincident with the frames $\{A\}$ and $\{B\}$ but not with the Center of mass of the mobile platform ([[./figs/stewart_cubic_conf_mass_above.png][png]], [[./figs/stewart_cubic_conf_mass_above.pdf][pdf]])
% [[file:figs/stewart_cubic_conf_mass_above.png]]

% We now identify the dynamics from forces applied in each strut $\bm{\tau}$ to the displacement of each strut $d \bm{\mathcal{L}}$.

open('stewart_platform_model.slx')

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_platform_model';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Controller'],        1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Stewart Platform'],  1, 'openoutput', [], 'dLm'); io_i = io_i + 1; % Relative Displacement Outputs [m]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Dm1', 'Dm2', 'Dm3', 'Dm4', 'Dm5', 'Dm6'};



% And we use the Jacobian to compute the transfer function from $\bm{\mathcal{F}}$ to $\bm{\mathcal{X}}$.

Gc = inv(stewart.kinematics.J)*G*inv(stewart.kinematics.J');
Gc.InputName  = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
Gc.OutputName = {'Dx', 'Dy', 'Dz', 'Rx', 'Ry', 'Rz'};



% The obtain dynamics $\bm{G}_{c}(s) = \bm{J}^{-T} \bm{G}(s) \bm{J}^{-1}$ is shown in Figure [[fig:stewart_conf_coupling_mass_matrix]].


freqs = logspace(1, 3, 500);

figure;

ax1 = subplot(2, 2, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(Gc(1, 1), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(2, 2), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(3, 3), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 2, 3);
hold on;
for i = 1:6
  for j = i+1:6
    p4 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(1, 1), freqs, 'Hz'))));
p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(2, 2), freqs, 'Hz'))));
p3 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(3, 3), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2, p3, p4], {'$D_x/F_x$','$D_y/F_y$',  '$D_z/F_z$', '$D_i/F_j$'})

ax2 = subplot(2, 2, 2);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(Gc(4, 4), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(5, 5), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gc(6, 6), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax4 = subplot(2, 2, 4);
hold on;
for i = 1:6
  for j = i+1:6
    p4 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(4, 4), freqs, 'Hz'))));
p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(5, 5), freqs, 'Hz'))));
p3 = plot(freqs, 180/pi*angle(squeeze(freqresp(Gc(6, 6), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2, p3, p4], {'$R_x/M_x$','$R_y/M_y$',  '$R_z/M_z$', '$R_i/M_j$'})

linkaxes([ax1,ax2,ax3,ax4],'x');
