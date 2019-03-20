%%
clear; close all; clc;

%%
K_iff = tf(zeros(6));
save('./mat/controllers.mat', 'K_iff', '-append');

%% Initialize System
hexapod = initializeHexapod(struct('actuator', 'piezo', 'jacobian', 150));
initializeSample(struct('mass', 50, 'height', 300, 'measheight', 150));

%% Identify transfer functions
G = identifyPlant();

%% Run to obtain the computed Jacobian
sim stewart_identification

%% Compare the two Jacobian matrices
J_rel = (J.data(:, :, 1)-hexapod.J)./hexapod.J;

%% Compute the Stiffness Matrix
K = hexapod.Leg.k.ax*hexapod.J'*hexapod.J;
K_id = pinv(freqresp(G.G_cart, 0));

K_rel = (K-K_id)./K;

