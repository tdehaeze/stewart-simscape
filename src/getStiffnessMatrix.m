function [K] = getStiffnessMatrix(leg, J)
    K = leg.k.ax*(J'*J);
end
