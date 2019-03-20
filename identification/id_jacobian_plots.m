%% Script Description
% 
%%
clear; close all; clc;

%%
load('./mat/G_jacobian.mat');

%%
freqs = logspace(0, 3, 2000);

%%
bode_opts = bodeoptions;
bode_opts.FreqUnits = 'Hz';
bode_opts.MagUnits = 'abs';
bode_opts.MagScale = 'log';
bode_opts.PhaseVisible = 'off';

%% Compare when the Jac is above Meas. point and CoM
% => 
figure;
bode(G_center.G_cart, G_Jac_offset.G_cart, 2*pi*freqs, bode_opts);

%% Compare when the CoM is bellow the Meas. point and Jac
% => This make the tilt resonance frequency a little bit higher.
figure;
bode(G_center.G_cart, G_CoM_offset.G_cart, 2*pi*freqs, bode_opts);

%% Compare when the measurement point is higher than CoM and Jac
% => 
figure;
bode(G_center.G_cart, G_Meas_offset.G_cart, 2*pi*freqs, bode_opts);

%% Compare direct forces and forces applied by actuators on the same point
% => This should be the same is the support is rigid.
% => Looks like it's close but not equal
figure;
bode(G_center.G_cart, G_center.G_comp, 2*pi*freqs, bode_opts);

%% Compare relative sensor and absolute sensor
% => This should be the same as the support is rigid
figure;
bode(G_center.G_iner, G_center.G_comp, 2*pi*freqs, bode_opts);
