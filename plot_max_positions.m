%%
run stewart_parameters.m
run stewart_init.m

%%
[X, Y, Z] = getMaxPositions(Leg, J);

figure;
hold on;
mesh(X, Y, Z);
colorbar;
hold off;
