lmax = 80e-6;

[X, Y, Z] = getMaxPositions(lmax, J);

figure;
hold on;
mesh(X, Y, Z);
colorbar;
hold off;

