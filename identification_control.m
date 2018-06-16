%% Script Description
% Script used to identify the transfer functions of the
% Stewart platform (from actuator to displacement)

%%
clear; close all; clc;

%%
initializeNanoHexapod();

%%
initializeSample(struct('mass', 0));

G_cart_0 = getPlantCart();

%%
initializeSample(struct('mass', 10));

G_cart_10 = getPlantCart();

%%
initializeSample(struct('mass', 50));

G_cart_50 = getPlantCart();

%%
freqs = logspace(1, 4, 1000);

bodeFig({G_cart_0(1, 1), G_cart_10(1, 1), G_cart_50(1, 1)}, freqs, struct('phase', true))
legend({'$F_x \rightarrow D_x$ - $M = 0Kg$', '$F_x \rightarrow D_x$ - $M = 10Kg$', '$F_x \rightarrow D_x$ - $M = 50Kg$'})
legend('location', 'southwest')
exportFig('hexapod_cart_mass_x', 'normal-tall')

bodeFig({G_cart_0(3, 3), G_cart_10(3, 3), G_cart_50(3, 3)}, freqs, struct('phase', true))
legend({'$F_z \rightarrow D_z$ - $M = 0Kg$', '$F_z \rightarrow D_z$ - $M = 10Kg$', '$F_z \rightarrow D_z$ - $M = 50Kg$'})
legend('location', 'southwest')
exportFig('hexapod_cart_mass_z', 'normal-tall')

%%
% Bode Plot of the linearized function
freqs = logspace(2, 4, 1000);

bodeFig({G_cart_0(1, 1), G_cart_0(2, 2), G_cart_0(3, 3)}, freqs, struct('phase', true))
legend({'$F_x \rightarrow D_x$', '$F_y \rightarrow D_y$', '$F_z \rightarrow D_z$'})
exportFig('hexapod_cart_trans', 'normal-normal')

bodeFig({G_cart_0(4, 4), G_cart_0(5, 5), G_cart_0(6, 6)}, freqs, struct('phase', true))
legend({'$M_x \rightarrow R_x$', '$M_y \rightarrow R_y$', '$M_z \rightarrow R_z$'})
exportFig('hexapod_cart_rot', 'normal-normal')

bodeFig({G_cart_0(1, 1), G_cart_0(2, 1), G_cart_0(3, 1)}, freqs, struct('phase', true))
legend({'$F_x \rightarrow D_x$', '$F_x \rightarrow D_y$', '$F_x \rightarrow D_z$'})
exportFig('hexapod_cart_coupling', 'normal-normal')

%% Save identify transfer functions
save('./mat/G_cart.mat', 'G_cart_0', 'G_cart_10', 'G_cart_50');

%% Centralized control (Cartesian coordinates)
% Input/Output definition
io(1) = linio([mdl, '/F_legs'],1,'input');
io(2) = linio([mdl, '/Stewart_Platform'],2,'output');

% Run the linearization
G_legs_raw = linearize(mdl,io, 0);

G_legs = preprocessIdTf(G_legs_raw, 10, 10000);

% Input/Output names
G_legs.InputName  = {'F1', 'F2', 'F3', 'M4', 'M5', 'M6'};
G_legs.OutputName = {'D1', 'D2', 'D3', 'R4', 'R5', 'R6'};

% Bode Plot of the linearized function
freqs = logspace(2, 4, 1000);

bodeFig({G_legs(1, 1)}, freqs, struct('phase', true))
legend({'$F_i \rightarrow D_i$'})
exportFig('hexapod_legs', 'normal-normal')

bodeFig({G_legs(1, 1), G_legs(2, 1)}, freqs, struct('phase', true))
legend({'$F_i \rightarrow D_i$', '$F_i \rightarrow D_j$'})
exportFig('hexapod_legs_coupling', 'normal-normal')

save('mat/G_legs.mat', 'G_legs');
