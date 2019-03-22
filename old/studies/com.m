clear; close all; clc;

%% System - center of mass in the plane of joints
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 150, 'density', 0.1));
initializeSample(struct('mass', 50, 'height', 300, 'measheight', 150));

%% Identification
G_aligned = identifyPlant();

%%
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 160, 'density', 0.1));
initializeSample(struct('mass', 50, 'height', 300, 'measheight', 160));

%% Identification
G_com = identifyPlant();

%%
freqs = logspace(0, 3, 2000);

%%
bode_opts = bodeoptions;
bode_opts.FreqUnits = 'Hz';
bode_opts.MagUnits = 'abs';
bode_opts.MagScale = 'log';
bode_opts.PhaseVisible = 'off';

%%
figure;
bode(G_aligned.G_cart, G_com.G_cart, 2*pi*freqs, bode_opts);

exportFig('G_com', 'wide-tall', struct('path', 'studies'));


%%
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 150, 'density', 0.1));
initializeSample(struct('mass', 1, 'height', 300, 'measheight', 150));

%% Identification
G_massless = identifyPlant();


%%
figure;
bode(G_aligned.G_cart, G_massless.G_cart, 2*pi*freqs, bode_opts);
