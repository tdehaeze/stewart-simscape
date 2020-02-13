%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

% Coupling between the actuators and sensors - Cubic Architecture
% Let's generate a Cubic architecture where the cube's center and the frames $\{A\}$ and $\{B\}$ are coincident.


H    = 200e-3; % height of the Stewart platform [m]
MO_B = -10e-3;  % Position {B} with respect to {M} [m]
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
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), ...
                                                  'Mpm', 10, ...
                                                  'Mph', 20e-3, ...
                                                  'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));
stewart = initializeCylindricalStruts(stewart, 'Fsm', 1e-3, 'Msm', 1e-3);
stewart = initializeInertialSensor(stewart);



% No flexibility below the Stewart platform and no payload.

ground = initializeGround('type', 'none');
payload = initializePayload('type', 'none');

displayArchitecture(stewart, 'labels', false, 'view', 'all');



% #+name: fig:stewart_architecture_coupling_struts_cubic
% #+caption: Geometry of the generated Stewart platform ([[./figs/stewart_architecture_coupling_struts_cubic.png][png]], [[./figs/stewart_architecture_coupling_struts_cubic.pdf][pdf]])
% [[file:figs/stewart_architecture_coupling_struts_cubic.png]]

% And we identify the dynamics from the actuator forces $\tau_{i}$ to the relative motion sensors $\delta \mathcal{L}_{i}$ (Figure [[fig:coupling_struts_relative_sensor_cubic]]) and to the force sensors $\tau_{m,i}$ (Figure [[fig:coupling_struts_force_sensor_cubic]]).


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

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 1, 2);
hold on;
for i = 1:6
  for j = i+1:6
    p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$L_i/\tau_i$', '$L_i/\tau_j$'})

linkaxes([ax1,ax2],'x');



% #+name: fig:coupling_struts_relative_sensor_cubic
% #+caption: Dynamics from the force actuators to the relative motion sensors ([[./figs/coupling_struts_relative_sensor_cubic.png][png]], [[./figs/coupling_struts_relative_sensor_cubic.pdf][pdf]])
% [[file:figs/coupling_struts_relative_sensor_cubic.png]]


%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Controller'],        1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Stewart Platform'],  1, 'openoutput', [], 'Taum'); io_i = io_i + 1; % Force Sensor Outputs [N]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Fm1', 'Fm2', 'Fm3', 'Fm4', 'Fm5', 'Fm6'};

freqs = logspace(1, 3, 500);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [N/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 1, 2);
hold on;
for i = 1:6
  for j = i+1:6
    p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$F_{m,i}/\tau_i$', '$F_{m,i}/\tau_j$'})

linkaxes([ax1,ax2],'x');

% Coupling between the actuators and sensors - Non-Cubic Architecture
% Now we generate a Stewart platform which is not cubic but with approximately the same size as the previous cubic architecture.


H    = 200e-3; % height of the Stewart platform [m]
MO_B = -10e-3;  % Position {B} with respect to {M} [m]

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', H, 'MO_B', MO_B);
stewart = generateGeneralConfiguration(stewart, 'FR', 250e-3, 'MR', 150e-3);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart, 'K', 1e6*ones(6,1), 'C', 1e1*ones(6,1));
stewart = initializeJointDynamics(stewart, 'type_F', 'universal', 'type_M', 'spherical');
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);
stewart = initializeCylindricalPlatforms(stewart, 'Fpr', 1.2*max(vecnorm(stewart.platform_F.Fa)), ...
                                                  'Mpm', 10, ...
                                                  'Mph', 20e-3, ...
                                                  'Mpr', 1.2*max(vecnorm(stewart.platform_M.Mb)));
stewart = initializeCylindricalStruts(stewart, 'Fsm', 1e-3, 'Msm', 1e-3);
stewart = initializeInertialSensor(stewart);



% No flexibility below the Stewart platform and no payload.

ground = initializeGround('type', 'none');
payload = initializePayload('type', 'none');

displayArchitecture(stewart, 'labels', false, 'view', 'all');



% #+name: fig:stewart_architecture_coupling_struts_non_cubic
% #+caption: Geometry of the generated Stewart platform ([[./figs/stewart_architecture_coupling_struts_non_cubic.png][png]], [[./figs/stewart_architecture_coupling_struts_non_cubic.pdf][pdf]])
% [[file:figs/stewart_architecture_coupling_struts_non_cubic.png]]

% And we identify the dynamics from the actuator forces $\tau_{i}$ to the relative motion sensors $\delta \mathcal{L}_{i}$ (Figure [[fig:coupling_struts_relative_sensor_non_cubic]]) and to the force sensors $\tau_{m,i}$ (Figure [[fig:coupling_struts_force_sensor_non_cubic]]).


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

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 1, 2);
hold on;
for i = 1:6
  for j = i+1:6
    p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$L_i/\tau_i$', '$L_i/\tau_j$'})

linkaxes([ax1,ax2],'x');



% #+name: fig:coupling_struts_relative_sensor_non_cubic
% #+caption: Dynamics from the force actuators to the relative motion sensors ([[./figs/coupling_struts_relative_sensor_non_cubic.png][png]], [[./figs/coupling_struts_relative_sensor_non_cubic.pdf][pdf]])
% [[file:figs/coupling_struts_relative_sensor_non_cubic.png]]


%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Controller'],        1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Stewart Platform'],  1, 'openoutput', [], 'Taum'); io_i = io_i + 1; % Force Sensor Outputs [N]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Fm1', 'Fm2', 'Fm3', 'Fm4', 'Fm5', 'Fm6'};

freqs = logspace(1, 3, 500);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 1:6
  for j = i+1:6
    plot(freqs, abs(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [N/N]'); set(gca, 'XTickLabel',[]);

ax3 = subplot(2, 1, 2);
hold on;
for i = 1:6
  for j = i+1:6
    p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(i, j), freqs, 'Hz'))), 'k-');
  end
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(1, 1), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$F_{m,i}/\tau_i$', '$F_{m,i}/\tau_j$'})

linkaxes([ax1,ax2],'x');
