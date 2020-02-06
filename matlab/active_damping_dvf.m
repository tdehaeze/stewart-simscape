%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('./');

open('simulink/stewart_active_damping.slx')

% Identification of the Dynamics with perfect Joints
% We first initialize the Stewart platform without joint stiffness.

stewart = initializeFramesPositions('H', 90e-3, 'MO_B', 45e-3);
stewart = generateGeneralConfiguration(stewart);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart);
stewart = initializeJointDynamics(stewart, 'disable', true);
stewart = initializeCylindricalPlatforms(stewart);
stewart = initializeCylindricalStruts(stewart);
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);



% And we identify the dynamics from force actuators to force sensors.

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_active_damping';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/F'],   1, 'openinput'); io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Dm'], 1, 'openoutput'); io_i = io_i + 1; % Relative Displacement Outputs [N]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Dm1', 'Dm2', 'Dm3', 'Dm4', 'Dm5', 'Dm6'};



% The transfer function from actuator forces to relative motion sensors is shown in Figure [[fig:dvf_plant_coupling]].

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  plot(freqs, abs(squeeze(freqresp(G(['Dm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G('Dm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(['Dm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G('Dm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$D_{m,i}/F_i$', '$D_{m,j}/F_i$'})

linkaxes([ax1,ax2],'x');

% Effect of the Flexible Joint stiffness on the Dynamics
% We add some stiffness and damping in the flexible joints and we re-identify the dynamics.

stewart = initializeJointDynamics(stewart);
Gf = linearize(mdl, io, options);
Gf.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
Gf.OutputName = {'Dm1', 'Dm2', 'Dm3', 'Dm4', 'Dm5', 'Dm6'};



% The new dynamics from force actuator to relative motion sensor is shown in Figure [[fig:dvf_plant_flexible_joint_decentralized]].

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
plot(freqs, abs(squeeze(freqresp(G( 'Dm1', 'F1'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gf('Dm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G( 'Dm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Perfect Joints');
plot(freqs, 180/pi*angle(squeeze(freqresp(Gf('Dm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Flexible Joints');
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend('location', 'northeast');

linkaxes([ax1,ax2],'x');

% Obtained Damping
% The control is a performed in a decentralized manner.
% The $6 \times 6$ control is a diagonal matrix with pure derivative action on the diagonal:
% \[ K(s) = g
%   \begin{bmatrix}
%     s & & \\
%     & \ddots & \\
%     & & s
%   \end{bmatrix} \]

% The root locus is shown in figure [[fig:root_locus_dvf_rot_stiffness]] and the obtained pole damping function of the control gain is shown in figure [[fig:pole_damping_gain_dvf_rot_stiffness]].

gains = logspace(0, 5, 1000);

figure;
hold on;
plot(real(pole(G)),  imag(pole(G)),  'x');
plot(real(pole(Gf)), imag(pole(Gf)), 'x');
set(gca,'ColorOrderIndex',1);
plot(real(tzero(G)),  imag(tzero(G)),  'o');
plot(real(tzero(Gf)), imag(tzero(Gf)), 'o');
for i = 1:length(gains)
  cl_poles = pole(feedback(G, (gains(i)*s)*eye(6)));
  set(gca,'ColorOrderIndex',1);
  plot(real(cl_poles), imag(cl_poles), '.');
  cl_poles = pole(feedback(Gf, (gains(i)*s)*eye(6)));
  set(gca,'ColorOrderIndex',2);
  plot(real(cl_poles), imag(cl_poles), '.');
end
ylim([0,inf]);
xlim([-3000,0]);
xlabel('Real Part')
ylabel('Imaginary Part')
axis square



% #+name: fig:root_locus_dvf_rot_stiffness
% #+caption: Root Locus plot with Direct Velocity Feedback when considering the Stiffness of flexible joints ([[./figs/root_locus_dvf_rot_stiffness.png][png]], [[./figs/root_locus_dvf_rot_stiffness.pdf][pdf]])
% [[file:figs/root_locus_dvf_rot_stiffness.png]]


gains = logspace(0, 5, 1000);

figure;
hold on;
for i = 1:length(gains)
  set(gca,'ColorOrderIndex',1);
  cl_poles = pole(feedback(G, (gains(i)*s)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');
  set(gca,'ColorOrderIndex',2);
  cl_poles = pole(feedback(Gf, (gains(i)*s)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');
end
xlabel('Control Gain');
ylabel('Damping of the Poles');
set(gca, 'XScale', 'log');
ylim([0,pi/2]);
