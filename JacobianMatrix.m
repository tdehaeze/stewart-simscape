%% Position Matrix
M_pos_base = pos_base + (height+(TP.thickness+Leg.sphere.top+SP.thickness.top+Nass.jacobian)*1e-3)*[zeros(6, 2),ones(6, 1)];

%% Rotation Matrix
RM = leg_vectors;

%%
J  = computeJacobian(RM, M_pos_base);

 %% Jacobian Matrix
 function J  = computeJacobian(RM,M_pos_base)
     J = zeros(6);
     J(:, 1:3) = RM;
     for i = 1:6
         J(i, 4:6) = -RM(i, :)*getCrossProductMatrix(M_pos_base(i, :));
     end

     function M = getCrossProductMatrix(v)
         M = zeros(3);
         M(1, 2) = -v(3);
         M(1, 3) =  v(2);
         M(2, 3) = -v(1);
         M(2, 1) = -M(1, 2);
         M(3, 1) = -M(1, 3);
         M(3, 2) = -M(2, 3);
     end
 end