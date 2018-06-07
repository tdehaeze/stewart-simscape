function [stewart] = initializeParameters(stewart)
    %% Connection points on base and top plate w.r.t. World frame at the center of the base plate
    stewart.pos_base = zeros(6, 3);
    stewart.pos_top = zeros(6, 3);

    alpha_b = stewart.BP.leg.ang*pi/180; % angle de décalage par rapport à 120 deg (pour positionner les supports bases)
    alpha_t = stewart.TP.leg.ang*pi/180; % +- offset angle from 120 degree spacing on top

    height = (stewart.h-stewart.BP.thickness-stewart.TP.thickness-stewart.Leg.sphere.bottom-stewart.Leg.sphere.top-stewart.SP.thickness.bottom-stewart.SP.thickness.top)*0.001; % TODO

    radius_b = stewart.BP.leg.rad*0.001; % rayon emplacement support base
    radius_t = stewart.TP.leg.rad*0.001; % top radius in meters

    for i = 1:3
      % base points
      angle_m_b = (2*pi/3)* (i-1) - alpha_b;
      angle_p_b = (2*pi/3)* (i-1) + alpha_b;
      stewart.pos_base(2*i-1,:) =  [radius_b*cos(angle_m_b), radius_b*sin(angle_m_b), 0.0];
      stewart.pos_base(2*i,:) = [radius_b*cos(angle_p_b), radius_b*sin(angle_p_b), 0.0];

      % top points
      % Top points are 60 degrees offset
      angle_m_t = (2*pi/3)* (i-1) - alpha_t + 2*pi/6;
      angle_p_t = (2*pi/3)* (i-1) + alpha_t + 2*pi/6;
      stewart.pos_top(2*i-1,:) = [radius_t*cos(angle_m_t), radius_t*sin(angle_m_t), height];
      stewart.pos_top(2*i,:) = [radius_t*cos(angle_p_t), radius_t*sin(angle_p_t), height];
    end

    % permute pos_top points so that legs are end points of base and top points
    stewart.pos_top = [stewart.pos_top(6,:); stewart.pos_top(1:5,:)]; %6th point on top connects to 1st on bottom
    stewart.pos_top_tranform = stewart.pos_top - height*[zeros(6, 2),ones(6, 1)];

    %% leg vectors
    legs = stewart.pos_top - stewart.pos_base;
    leg_length = zeros(6, 1);
    leg_vectors = zeros(6, 3);
    for i = 1:6
      leg_length(i) = norm(legs(i,:));
      leg_vectors(i,:)  = legs(i,:) / leg_length(i);
    end

    stewart.Leg.lenght = 1000*leg_length(1)/1.5;
    stewart.Leg.shape.bot = [0 0; ...
                             stewart.Leg.rad.bottom 0; ...
                             stewart.Leg.rad.bottom stewart.Leg.lenght; ...
                             stewart.Leg.rad.top stewart.Leg.lenght; ...
                             stewart.Leg.rad.top 0.2*stewart.Leg.lenght; ...
                             0 0.2*stewart.Leg.lenght];

    %% Calculate revolute and cylindrical axes
    rev1 = zeros(6, 3);
    rev2 = zeros(6, 3);
    cyl1 = zeros(6, 3);
    for i = 1:6
      rev1(i,:) = cross(leg_vectors(i,:), [0 0 1]);
      rev1(i,:) = rev1(i,:) / norm(rev1(i,:));

      rev2(i,:) = - cross(rev1(i,:), leg_vectors(i,:));
      rev2(i,:) = rev2(i,:) / norm(rev2(i,:));

      cyl1(i,:) = leg_vectors(i,:);
    end


    %% Coordinate systems
    stewart.lower_leg = struct('rotation', eye(3));
    stewart.upper_leg = struct('rotation', eye(3));

    for i = 1:6
      stewart.lower_leg(i).rotation = [rev1(i,:)', rev2(i,:)', cyl1(i,:)'];
      stewart.upper_leg(i).rotation = [rev1(i,:)', rev2(i,:)', cyl1(i,:)'];
    end

    %% Position Matrix
    stewart.M_pos_base = stewart.pos_base + (height+(stewart.TP.thickness+stewart.Leg.sphere.top+stewart.SP.thickness.top+stewart.jacobian)*1e-3)*[zeros(6, 2),ones(6, 1)];

    %% Compute Jacobian Matrix
    aa = stewart.pos_top_tranform + (stewart.jacobian - stewart.TP.thickness - stewart.SP.height.top)*1e-3*[zeros(6, 2),ones(6, 1)];
    stewart.J  = getJacobianMatrix(leg_vectors', aa');
end
