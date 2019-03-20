%%
clear; close all; clc;

%%
sys_0   = initializeHexapod(struct('actuator', 'piezo', 'jacobian', 0));
sys_100 = initializeHexapod(struct('actuator', 'piezo', 'jacobian', 100));
sys_200 = initializeHexapod(struct('actuator', 'piezo', 'jacobian', 1000000));

%%
K_0   = getStiffnessMatrix(sys_0.Leg.k.ax,   sys_0.J  );
K_100 = getStiffnessMatrix(sys_100.Leg.k.ax, sys_100.J);
K_200 = getStiffnessMatrix(sys_200.Leg.k.ax, sys_200.J);

%%
