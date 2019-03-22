%%
clear; close all; clc;

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%% Load controllers
load('./mat/K_iff_sisotool.mat', ...
    'K_iff_light_vc', 'K_iff_light_pz', ...
    'K_iff_heavy_vc', 'K_iff_heavy_pz');

%%
initializeSample(struct('mass', 1));

initializeHexapod(struct('actuator', 'lorentz'));
K_iff = K_iff_light_vc; %#ok
save('./mat/controllers.mat', 'K_iff', '-append');

G_light_vc_iff = identifyPlant();

initializeHexapod(struct('actuator', 'piezo'));
K_iff = K_iff_light_pz; %#ok
save('./mat/controllers.mat', 'K_iff', '-append');

G_light_pz_iff = identifyPlant();

%%
initializeSample(struct('mass', 50));

initializeHexapod(struct('actuator', 'lorentz'));
K_iff = K_iff_heavy_vc; %#ok
save('./mat/controllers.mat', 'K_iff', '-append');

G_heavy_vc_iff = identifyPlant();

initializeHexapod(struct('actuator', 'piezo'));
K_iff = K_iff_heavy_pz;
save('./mat/controllers.mat', 'K_iff', '-append');

G_heavy_pz_iff = identifyPlant();

%% Save the obtained transfer functions
save('./mat/G_iff.mat', ...
    'G_light_vc_iff', 'G_light_pz_iff', ...
    'G_heavy_vc_iff', 'G_heavy_pz_iff');
