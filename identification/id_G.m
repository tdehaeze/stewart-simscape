%% Script Description
% Script used to identify various transfer functions
% of the Stewart platform

%%
clear; close all; clc;

%%
K_iff = tf(zeros(6));
save('./mat/controllers.mat', 'K_iff', '-append');

%% Initialize System
initializeSample(struct('mass', 50));
initializeHexapod(struct('actuator', 'piezo'));

%% Identification
G = identifyPlant();

%% Save
save('./mat/G.mat', 'G');
