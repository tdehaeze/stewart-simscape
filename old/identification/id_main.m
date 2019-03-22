%%
clear; close all; clc;

%% Jacobian Study


%% Identification of the system
run id_G.m

%% Plots of the identifications
run id_plot_cart.m
run id_plot_legs.m
run id_plot_iff.m
run id_plot_db.m