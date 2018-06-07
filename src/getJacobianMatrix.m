function J  = getJacobianMatrix(RM,M_pos_base)
    % RM: [3x6] unit vector of each leg in the fixed frame
    % M_pos_base: [3x6] vector of the leg connection at the top platform location in the fixed frame
    J = zeros(6);
    J(:, 1:3) = RM';
    J(:, 4:6) = cross(M_pos_base, RM)';
end
