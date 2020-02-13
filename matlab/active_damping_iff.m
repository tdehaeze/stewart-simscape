%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('../');

open('stewart_platform_model.slx')

% Identification of the Dynamics with perfect Joints
% We first initialize the Stewart platform without joint stiffness.

stewart = initializeStewartPlatform();
stewart = initializeFramesPositions(stewart, 'H', 90e-3, 'MO_B', 45e-3);
stewart = generateGeneralConfiguration(stewart);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart);
stewart = initializeJointDynamics(stewart, 'type_F', 'universal_p', 'type_M', 'spherical_p');
stewart = initializeCylindricalPlatforms(stewart);
stewart = initializeCylindricalStruts(stewart);
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);
stewart = initializeInertialSensor(stewart, 'type', 'none');

ground = initializeGround('type', 'none');
payload = initializePayload('type', 'none');



% And we identify the dynamics from force actuators to force sensors.

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_platform_model';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Controller'],        1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Stewart Platform'],  1, 'openoutput', [], 'Taum'); io_i = io_i + 1; % Force Sensor Outputs [N]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Fm1', 'Fm2', 'Fm3', 'Fm4', 'Fm5', 'Fm6'};



% The transfer function from actuator forces to force sensors is shown in Figure [[fig:iff_plant_coupling]].

freqs = logspace(1, 4, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  plot(freqs, abs(squeeze(freqresp(G(['Fm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G('Fm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [N/N]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(['Fm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G('Fm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$F_{m,i}/F_i$', '$F_{m,j}/F_i$'})

linkaxes([ax1,ax2],'x');

% Effect of the Flexible Joint stiffness and Actuator amplification on the Dynamics
% We add some stiffness and damping in the flexible joints and we re-identify the dynamics.

stewart = initializeJointDynamics(stewart, 'type_F', 'universal', 'type_M', 'spherical');
Gf = linearize(mdl, io, options);
Gf.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
Gf.OutputName = {'Fm1', 'Fm2', 'Fm3', 'Fm4', 'Fm5', 'Fm6'};



% We now use the amplified actuators and re-identify the dynamics

stewart = initializeAmplifiedStrutDynamics(stewart);
Ga = linearize(mdl, io, options);
Ga.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
Ga.OutputName = {'Fm1', 'Fm2', 'Fm3', 'Fm4', 'Fm5', 'Fm6'};



% The new dynamics from force actuator to force sensor is shown in Figure [[fig:iff_plant_flexible_joint_decentralized]].

freqs = logspace(1, 4, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
plot(freqs, abs(squeeze(freqresp(G( 'Fm1', 'F1'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gf('Fm1', 'F1'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Ga('Fm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [N/N]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G( 'Fm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Perfect Joints');
plot(freqs, 180/pi*angle(squeeze(freqresp(Gf('Fm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Flexible Joints');
plot(freqs, 180/pi*angle(squeeze(freqresp(Ga('Fm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Amplified Actuators');
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend('location', 'southwest')

linkaxes([ax1,ax2],'x');

% Obtained Damping
% The control is a performed in a decentralized manner.
% The $6 \times 6$ control is a diagonal matrix with pure integration action on the diagonal:
% \[ K(s) = g
%   \begin{bmatrix}
%     \frac{1}{s} & & 0 \\
%     & \ddots & \\
%     0 & & \frac{1}{s}
%   \end{bmatrix} \]

% The root locus is shown in figure [[fig:root_locus_iff_rot_stiffness]] and the obtained pole damping function of the control gain is shown in figure [[fig:pole_damping_gain_iff_rot_stiffness]].

gains = logspace(0, 5, 1000);

figure;
hold on;
plot(real(pole(G)),  imag(pole(G)),  'x');
plot(real(pole(Gf)), imag(pole(Gf)), 'x');
plot(real(pole(Ga)), imag(pole(Ga)), 'x');
set(gca,'ColorOrderIndex',1);
plot(real(tzero(G)),  imag(tzero(G)),  'o');
plot(real(tzero(Gf)), imag(tzero(Gf)), 'o');
plot(real(tzero(Ga)), imag(tzero(Ga)), 'o');
for i = 1:length(gains)
  cl_poles = pole(feedback(G, (gains(i)/s)*eye(6)));
  set(gca,'ColorOrderIndex',1);
  p1 = plot(real(cl_poles), imag(cl_poles), '.');

  cl_poles = pole(feedback(Gf, (gains(i)/s)*eye(6)));
  set(gca,'ColorOrderIndex',2);
  p2 = plot(real(cl_poles), imag(cl_poles), '.');

  cl_poles = pole(feedback(Ga, (gains(i)/s)*eye(6)));
  set(gca,'ColorOrderIndex',3);
  p3 = plot(real(cl_poles), imag(cl_poles), '.');
end
ylim([0, 1.1*max(imag(pole(G)))]);
xlim([-1.1*max(imag(pole(G))),0]);
xlabel('Real Part')
ylabel('Imaginary Part')
axis square
legend([p1, p2, p3], {'Perfect Joints', 'Flexible Joints', 'Amplified Actuator'}, 'location', 'northwest');



% #+name: fig:root_locus_iff_rot_stiffness
% #+caption: Root Locus plot with Decentralized Integral Force Feedback when considering the stiffness of flexible joints ([[./figs/root_locus_iff_rot_stiffness.png][png]], [[./figs/root_locus_iff_rot_stiffness.pdf][pdf]])
% [[file:figs/root_locus_iff_rot_stiffness.png]]


gains = logspace(0, 5, 1000);

figure;
hold on;
for i = 1:length(gains)
  set(gca,'ColorOrderIndex',1);
  cl_poles = pole(feedback(G, (gains(i)/s)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  p1 = plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');

  set(gca,'ColorOrderIndex',2);
  cl_poles = pole(feedback(Gf, (gains(i)/s)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  p2 = plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');

  set(gca,'ColorOrderIndex',3);
  cl_poles = pole(feedback(Ga, (gains(i)/s)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  p3 = plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');
end
xlabel('Control Gain');
ylabel('Damping of the Poles');
set(gca, 'XScale', 'log');
ylim([0,pi/2]);
legend([p1, p2, p3], {'Perfect Joints', 'Flexible Joints', 'Amplified Actuator'}, 'location', 'northwest');
