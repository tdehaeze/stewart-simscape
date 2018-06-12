%% Script Description
% Script used to identify the transfer functions of the 
% Stewart platform (from actuator to displacement)

%%
clear;
close all;
clc

%% Define options for bode plots
bode_opts = bodeoptions;

bode_opts.Title.FontSize  = 12;
bode_opts.XLabel.FontSize = 12;
bode_opts.YLabel.FontSize = 12;
bode_opts.FreqUnits       = 'Hz';
bode_opts.MagUnits        = 'abs';
bode_opts.MagScale        = 'log';
bode_opts.PhaseWrapping   = 'on';
bode_opts.PhaseVisible    = 'on';

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_simscape';

%% Centralized control (Cartesian coordinates)
% Input/Output definition
io(1) = linio([mdl, '/F_cart'],1,'input');
io(2) = linio([mdl, '/Stewart_Platform'],1,'output');

% Run the linearization
G_cart = linearize(mdl,io, 0);

% Input/Output names
G_cart.InputName  = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
G_cart.OutputName = {'Dx', 'Dy', 'Dz', 'Rx', 'Ry', 'Rz'};

% Bode Plot of the linearized function
freqs = logspace(2, 4, 1000);

bodeFig({G_cart(1, 1), G_cart(2, 2), G_cart(3, 3)}, freqs, struct('phase', true))
legend({'$F_x \rightarrow D_x$', '$F_y \rightarrow D_y$', '$F_z \rightarrow D_z$'})
exportFig('hexapod_cart_trans', 'normal-normal')

bodeFig({G_cart(4, 4), G_cart(5, 5), G_cart(6, 6)}, freqs, struct('phase', true))
legend({'$M_x \rightarrow R_x$', '$M_y \rightarrow R_y$', '$M_z \rightarrow R_z$'})
exportFig('hexapod_cart_rot', 'normal-normal')

bodeFig({G_cart(1, 1), G_cart(2, 1), G_cart(3, 1)}, freqs, struct('phase', true))
legend({'$F_x \rightarrow D_x$', '$F_x \rightarrow D_y$', '$F_x \rightarrow D_z$'})
exportFig('hexapod_cart_coupling', 'normal-normal')

%% Centralized control (Cartesian coordinates)
% Input/Output definition
io(1) = linio([mdl, '/F_legs'],1,'input');
io(2) = linio([mdl, '/Stewart_Platform'],2,'output');

% Run the linearization
G_legs = linearize(mdl,io, 0);

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
