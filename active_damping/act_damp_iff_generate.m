%%
clear; close all; clc;

%% Load the transfer functions
load('./mat/G.mat', 'G_light_vc', 'G_light_pz', 'G_heavy_vc', 'G_heavy_pz');

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%%
s = tf('s');

%% Light Voice Coil
%sisotool(-G_light_vc.G_iff('Fm1', 'F1')/s);

K_iff_light_vc = 105/s*tf(eye(6));

%% Light Piezo
%sisotool(-G_light_pz.G_iff('Fm1', 'F1')/s);

K_iff_light_pz = 3300/s*tf(eye(6));

%% Heavy Voice Coil
%sisotool(-G_heavy_vc.G_iff('Fm1', 'F1')/s);

K_iff_heavy_vc = 22.7/s*tf(eye(6));

%% Heavy Piezo
%sisotool(-G_heavy_pz.G_iff('Fm1', 'F1')/s);

K_iff_heavy_pz = 720/s*tf(eye(6));

%% Save Controllers
save('./mat/K_iff_sisotool.mat', ...
    'K_iff_light_vc', 'K_iff_light_pz', ...
    'K_iff_heavy_vc', 'K_iff_heavy_pz');
