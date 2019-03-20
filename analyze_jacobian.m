%% Script Description
%

%%
figure;
plot(d_meas.Time, d.Data-d_meas.Data)

%%
figure;
plot(error.Time, error.Data)
legend({'x', 'y', 'z', 'theta_x', 'theta_y', 'theta_z'})

%%
J = jacobian.Data(:, :, 1);

% Norm of the jacobian with time
J_change = (jacobian.Data - J)./J;

figure;
hold on;
plot(jacobian.Time, squeeze(J_change(1, 1, :)));
plot(jacobian.Time, squeeze(J_change(2, 2, :)));
plot(jacobian.Time, squeeze(J_change(3, 3, :)));
plot(jacobian.Time, squeeze(J_change(4, 4, :)));
plot(jacobian.Time, squeeze(J_change(5, 5, :)));
plot(jacobian.Time, squeeze(J_change(6, 6, :)));
legend({'Jxx', 'Jyy', 'Jzz', 'Jmx', 'Jmy', 'Jmz'})
hold off;

%% K change
K_init = J'*J;
K = zeros(size(jacobian.Data));

for i=1:length(jacobian.Time)
    K(:, :, i) = jacobian.Data(:, :, i)'*jacobian.Data(:, :, i);
end

K_change = (permute(K, [2, 1, 3]) - K_init)./K_init;

figure;
hold on;
plot(jacobian.Time, squeeze(K_change(1, 1, :)));
plot(jacobian.Time, squeeze(K_change(2, 2, :)));
plot(jacobian.Time, squeeze(K_change(3, 3, :)));
plot(jacobian.Time, squeeze(K_change(4, 4, :)));
plot(jacobian.Time, squeeze(K_change(5, 5, :)));
plot(jacobian.Time, squeeze(K_change(6, 6, :)));
legend({'Kxx', 'Kyy', 'Kzz', 'Kmx', 'Kmy', 'Kmz'})
hold off;
