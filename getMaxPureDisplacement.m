function [max_disp] = getMaxPureDisplacement(Leg, J)
    max_disp = zeros(6, 1);
    max_disp(1) = Leg.stroke/max(abs(J*[1 0 0 0 0 0]'));
    max_disp(2) = Leg.stroke/max(abs(J*[0 1 0 0 0 0]'));
    max_disp(3) = Leg.stroke/max(abs(J*[0 0 1 0 0 0]'));
    max_disp(4) = Leg.stroke/max(abs(J*[0 0 0 1 0 0]'));
    max_disp(5) = Leg.stroke/max(abs(J*[0 0 0 0 1 0]'));
    max_disp(6) = Leg.stroke/max(abs(J*[0 0 0 0 0 1]'));
end
