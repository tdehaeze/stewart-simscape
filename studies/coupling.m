clear; close all; clc;

%% System - center of mass in the plane of joints
initializeHexapod(struct('actuator', 'piezo', 'jacobian', -25, 'density', 0.1));
initializeSample(struct('mass', 50, 'height', 1, 'measheight', -25, 'offset', [0, 0, -25.5]));

%% Identification
G_aligned = identifyPlant();

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
bode(G_aligned.G_legs, 2*pi*freqs, bode_opts);


%% Change height of stewart platform
for height = [50, 70, 90, 110, 130]
    initializeHexapod(struct('actuator', 'piezo', 'jacobian', -25, 'density', 0.1, 'height', height));
    G.(['h_' num2str(height)]) = identifyPlant();
end

%%
figure;
bode( ...
    G.h_50.G_legs, ...
    G.h_70.G_legs, ...
    G.h_90.G_legs, ...
    G.h_110.G_legs, ...
    G.h_130.G_legs, ...
    2*pi*freqs, bode_opts);
% legend({'60', '80', '100', '120', '140'})

