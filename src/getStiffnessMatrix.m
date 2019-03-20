function [K] = getStiffnessMatrix(k, J)
    % k - leg stiffness
    % J - Jacobian matrix
    K = k*(J'*J);
end
