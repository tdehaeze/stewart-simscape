%% Script Description
% 

%%
clear; close all; clc;

%%
init_simulink;

%%
[X, Y, Z] = getMaxPositions(stewart);

%%
figure;
hold on;
mesh(X, Y, Z);
grid on;
colorbar;
hold off;
