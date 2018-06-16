%% Script Description
% Script used to identify the transfer functions of the
% Stewart platform (from actuator to displacement)

%%
clear; close all; clc;

%%
initializeNanoHexapod();

%%
initializeSample(struct('mass', 0));

G_legs_0 = identifyPlantLegs();

%%
initializeSample(struct('mass', 10));

G_legs_10 = identifyPlantLegs();

%%
initializeSample(struct('mass', 50));

G_legs_50 = identifyPlantLegs();

%%
freqs = logspace(1, 4, 1000);

bodeFig({G_legs_0(1, 1), G_legs_10(1, 1), G_legs_50(1, 1)}, freqs, struct('phase', true))
legend({'$F_i \rightarrow D_i$ - $M = 0Kg$', '$F_i \rightarrow D_i$ - $M = 10Kg$', '$F_i \rightarrow D_i$ - $M = 50Kg$'})
legend('location', 'southwest')

exportFig('hexapod_legs_mass', 'normal-tall')

%%
freqs = logspace(1, 4, 1000);

bodeFig({G_legs_0(1, 2), G_legs_10(1, 2), G_legs_50(1, 2)}, freqs, struct('phase', true))
legend({'$F_i \rightarrow D_j$ - $M = 0Kg$', '$F_i \rightarrow D_j$ - $M = 10Kg$', '$F_i \rightarrow D_j$ - $M = 50Kg$'})
legend('location', 'southwest')

exportFig('hexapod_legs_coupling_mass', 'normal-tall')

%% Save identify transfer functions
save('./mat/G_legs.mat', 'G_legs_0', 'G_legs_10', 'G_legs_50');
