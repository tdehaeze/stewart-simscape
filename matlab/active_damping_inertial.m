%% Clear Workspace and Close figures
clear; close all; clc;

%% Intialize Laplace variable
s = zpk('s');

simulinkproject('./');

open('simulink/stewart_active_damping.slx')

% Identification of the Dynamics

stewart = initializeFramesPositions('H', 90e-3, 'MO_B', 45e-3);
stewart = generateGeneralConfiguration(stewart);
stewart = computeJointsPose(stewart);
stewart = initializeStrutDynamics(stewart);
stewart = initializeJointDynamics(stewart, 'disable', true);
stewart = initializeCylindricalPlatforms(stewart);
stewart = initializeCylindricalStruts(stewart);
stewart = computeJacobian(stewart);
stewart = initializeStewartPose(stewart);

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_active_damping';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/F'],   1, 'openinput');  io_i = io_i + 1; % Actuator Force Inputs [N]
io(io_i) = linio([mdl, '/Vm'],  1, 'openoutput'); io_i = io_i + 1; % Absolute velocity of each leg [m/s]

%% Run the linearization
G = linearize(mdl, io, options);
G.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
G.OutputName = {'Vm1', 'Vm2', 'Vm3', 'Vm4', 'Vm5', 'Vm6'};



% The transfer function from actuator forces to force sensors is shown in Figure [[fig:inertial_plant_coupling]].

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  plot(freqs, abs(squeeze(freqresp(G(['Vm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G('Vm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [$\frac{m/s}{N}$]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
for i = 2:6
  set(gca,'ColorOrderIndex',2);
  p2 = plot(freqs, 180/pi*angle(squeeze(freqresp(G(['Vm', num2str(i)], 'F1'), freqs, 'Hz'))));
end
set(gca,'ColorOrderIndex',1);
p1 = plot(freqs, 180/pi*angle(squeeze(freqresp(G('Vm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend([p1, p2], {'$F_{m,i}/F_i$', '$F_{m,j}/F_i$'})

linkaxes([ax1,ax2],'x');

% Effect of the Flexible Joint stiffness on the Dynamics
% We add some stiffness and damping in the flexible joints and we re-identify the dynamics.

stewart = initializeJointDynamics(stewart);
Gf = linearize(mdl, io, options);
Gf.InputName  = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'};
Gf.OutputName = {'Vm1', 'Vm2', 'Vm3', 'Vm4', 'Vm5', 'Vm6'};



% The new dynamics from force actuator to force sensor is shown in Figure [[fig:inertial_plant_flexible_joint_decentralized]].

freqs = logspace(1, 3, 1000);

figure;

ax1 = subplot(2, 1, 1);
hold on;
plot(freqs, abs(squeeze(freqresp(G( 'Vm1', 'F1'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(Gf('Vm1', 'F1'), freqs, 'Hz'))));
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [$\frac{m/s}{N}$]'); set(gca, 'XTickLabel',[]);

ax2 = subplot(2, 1, 2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G( 'Vm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Perfect Joints');
plot(freqs, 180/pi*angle(squeeze(freqresp(Gf('Vm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'Flexible Joints');
hold off;
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'lin');
ylabel('Phase [deg]'); xlabel('Frequency [Hz]');
ylim([-180, 180]);
yticks([-180, -90, 0, 90, 180]);
legend('location', 'southwest')

linkaxes([ax1,ax2],'x');

% Obtained Damping
% The control is a performed in a decentralized manner.
% The $6 \times 6$ control is a diagonal matrix with pure proportional action on the diagonal:
% \[ K(s) = g
%   \begin{bmatrix}
%     1 & & 0 \\
%     & \ddots & \\
%     0 & & 1
%   \end{bmatrix} \]

% The root locus is shown in figure [[fig:root_locus_inertial_rot_stiffness]] and the obtained pole damping function of the control gain is shown in figure [[fig:pole_damping_gain_inertial_rot_stiffness]].

gains = logspace(0, 5, 1000);

figure;
hold on;
plot(real(pole(G)),  imag(pole(G)),  'x');
plot(real(pole(Gf)), imag(pole(Gf)), 'x');
set(gca,'ColorOrderIndex',1);
plot(real(tzero(G)),  imag(tzero(G)),  'o');
plot(real(tzero(Gf)), imag(tzero(Gf)), 'o');
for i = 1:length(gains)
  cl_poles = pole(feedback(G, gains(i)*eye(6)));
  set(gca,'ColorOrderIndex',1);
  plot(real(cl_poles), imag(cl_poles), '.');
  cl_poles = pole(feedback(Gf, gains(i)*eye(6)));
  set(gca,'ColorOrderIndex',2);
  plot(real(cl_poles), imag(cl_poles), '.');
end
ylim([0,2000]);
xlim([-2000,0]);
xlabel('Real Part')
ylabel('Imaginary Part')
axis square



% #+name: fig:root_locus_inertial_rot_stiffness
% #+caption: Root Locus plot with Decentralized Inertial Control when considering the stiffness of flexible joints ([[./figs/root_locus_inertial_rot_stiffness.png][png]], [[./figs/root_locus_inertial_rot_stiffness.pdf][pdf]])
% [[file:figs/root_locus_inertial_rot_stiffness.png]]


gains = logspace(0, 5, 1000);

figure;
hold on;
for i = 1:length(gains)
  set(gca,'ColorOrderIndex',1);
  cl_poles = pole(feedback(G, gains(i)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');
  set(gca,'ColorOrderIndex',2);
  cl_poles = pole(feedback(Gf, gains(i)*eye(6)));
  poles_damp = phase(cl_poles(imag(cl_poles)>0)) - pi/2;
  plot(gains(i)*ones(size(poles_damp)), poles_damp, '.');
end
xlabel('Control Gain');
ylabel('Damping of the Poles');
set(gca, 'XScale', 'log');
ylim([0,pi/2]);
