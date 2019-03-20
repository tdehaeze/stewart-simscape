%% Script Description
%%
clear; close all; clc;

%%
K_iff = tf(zeros(6));
save('./mat/controllers.mat', 'K_iff', '-append');

%% System - perfectly aligned
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 1, 'density', 0.1));
initializeSample(struct('mass', 50, 'height', 1, 'measheight', 1, 'offset', [0, 0, -25.5]));

% Identification
G_center = identifyPlant();

%% System - Jacobian is too high
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 160));
initializeSample(struct('mass', 50, 'height', 300, 'measheight', 150));

% Identification
G_Jac_offset = identifyPlant();

%% System - CoM is too low
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 150));
initializeSample(struct('mass', 50, 'height', 280, 'measheight', 150));

% Identification
G_CoM_offset = identifyPlant();

%% System - Meas point is too high
initializeHexapod(struct('actuator', 'piezo', 'jacobian', 150));
initializeSample(struct('mass', 50, 'height', 300, 'measheight', 160));

% Identification
G_Meas_offset = identifyPlant();

%% Save
save('./mat/G_jacobian.mat', 'G_center', 'G_Jac_offset', 'G_CoM_offset', 'G_Meas_offset');
