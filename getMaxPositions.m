function [X, Y, Z] = getMaxPositions(Leg, J)
    theta = linspace(0, 2*pi, 100);
    phi = linspace(-pi/2 , pi/2, 100);
    dmax = zeros(length(theta), length(phi));

    for i = 1:length(theta)
        for j = 1:length(phi)
            L = J*[cos(phi(j))*cos(theta(i)) cos(phi(j))*sin(theta(i)) sin(phi(j)) 0 0 0]';
            dmax(i, j) = Leg.stroke/max(abs(L));
        end
    end

    X = dmax.*cos(repmat(phi,length(theta),1)).*cos(repmat(theta,length(phi),1))';
    Y = dmax.*cos(repmat(phi,length(theta),1)).*sin(repmat(theta,length(phi),1))';
    Z = dmax.*sin(repmat(phi,length(theta),1));
end
