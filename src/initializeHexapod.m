function [stewart] = initializeHexapod(opts_param)
%% Default values for opts
    opts = struct(...
        'height',   90,       ... % Height of the platform [mm]
        'jacobian', 150,      ... % Jacobian offset [mm]
        'density',  8000,     ... % Density of hexapod [mm]
        'name',     'stewart' ... % Name of the file
        );

    %% Populate opts with input parameters
    if exist('opts_param','var')
        for opt = fieldnames(opts_param)'
            opts.(opt{1}) = opts_param.(opt{1});
        end
    end

    %% Stewart Object
    stewart = struct();
    stewart.h        = opts.height;   % Total height of the platform [mm]
    stewart.jacobian = opts.jacobian; % distance from the center of the top platform
                                      % where the jacobian is computed [mm]

    %% Bottom Plate
    BP = struct();

    BP.rad.int   = 0;    % Internal Radius [mm]
    BP.rad.ext   = 150;  % External Radius [mm]
    BP.thickness = 10;   % Thickness [mm]
    BP.leg.rad   = 100;  % Radius where the legs articulations are positionned [mm]
    BP.leg.ang   = 5;    % Angle Offset [deg]
    BP.density   = opts.density; % Density of the material [kg/m3]
    BP.color     = [0.7 0.7 0.7]; % Color [rgb]
    BP.shape     = [BP.rad.int BP.thickness; BP.rad.int 0; BP.rad.ext 0; BP.rad.ext BP.thickness];

    %% Top Plate
    TP = struct();

    TP.rad.int   = 0;    % Internal Radius [mm]
    TP.rad.ext   = 100;  % Internal Radius [mm]
    TP.thickness = 10;   % Thickness [mm]
    TP.leg.rad   = 90;   % Radius where the legs articulations are positionned [mm]
    TP.leg.ang   = 5;    % Angle Offset [deg]
    TP.density   = opts.density; % Density of the material [kg/m3]
    TP.color     = [0.7 0.7 0.7]; % Color [rgb]
    TP.shape     = [TP.rad.int TP.thickness; TP.rad.int 0; TP.rad.ext 0; TP.rad.ext TP.thickness];

    %% Leg
    Leg = struct();

    Leg.stroke     = 80e-6; % Maximum Stroke of each leg [m]
    if strcmp(opts.actuator, 'piezo')
        Leg.k.ax = 1e7; % Stiffness of each leg [N/m]
        Leg.c.ax = 500; % [N/(m/s)]
    elseif strcmp(opts.actuator, 'lorentz')
        Leg.k.ax = 1e4; % Stiffness of each leg [N/m]
        Leg.c.ax = 200; % [N/(m/s)]
    elseif isnumeric(opts.actuator)
        Leg.k.ax = opts.actuator; % Stiffness of each leg [N/m]
        Leg.c.ax = 100;           % [N/(m/s)]
    else
        error('opts.actuator should be piezo or lorentz or numeric value');
    end
    Leg.rad.bottom = 12;   % Radius of the cylinder of the bottom part [mm]
    Leg.rad.top    = 10;   % Radius of the cylinder of the top part [mm]
    Leg.density    = opts.density; % Density of the material [kg/m3]
    Leg.color.bottom  = [0.5 0.5 0.5]; % Color [rgb]
    Leg.color.top     = [0.5 0.5 0.5]; % Color [rgb]

    Leg.sphere.bottom = Leg.rad.bottom; % Size of the sphere at the end of the leg [mm]
    Leg.sphere.top    = Leg.rad.top; % Size of the sphere at the end of the leg [mm]

    %% Sphere
    SP = struct();

    SP.height.bottom  = 15; % [mm]
    SP.height.top     = 15; % [mm]
    SP.density.bottom = opts.density; % [kg/m^3]
    SP.density.top    = opts.density; % [kg/m^3]
    SP.color.bottom   = [0.7 0.7 0.7]; % [rgb]
    SP.color.top      = [0.7 0.7 0.7]; % [rgb]
    SP.k.ax           = 0; % [N*m/deg]
    SP.c.ax           = 0; % [N*m/deg]

    SP.thickness.bottom = SP.height.bottom-Leg.sphere.bottom; % [mm]
    SP.thickness.top    = SP.height.top-Leg.sphere.top; % [mm]
    SP.rad.bottom       = Leg.sphere.bottom; % [mm]
    SP.rad.top          = Leg.sphere.top; % [mm]


    %%
    Leg.support.bottom = [0 SP.thickness.bottom; 0 0; SP.rad.bottom 0; SP.rad.bottom SP.height.bottom];
    Leg.support.top    = [0 SP.thickness.top; 0 0; SP.rad.top 0; SP.rad.top SP.height.top];

    %%
    stewart.BP = BP;
    stewart.TP = TP;
    stewart.Leg = Leg;
    stewart.SP = SP;

    %%
    stewart = initializeParameters(stewart);

    %%
    save('./mat/stewart.mat', 'stewart')

    %% ==============================================================
    %  Additional Functions
    % ===============================================================

    %% Initialize Parameters
    function [stewart] = initializeParameters(stewart)
    %% Connection points on base and top plate w.r.t. World frame at the center of the base plate
        stewart.pos_base = zeros(6, 3);
        stewart.pos_top = zeros(6, 3);

        alpha_b = stewart.BP.leg.ang*pi/180; % angle de décalage par rapport à 120 deg (pour positionner les supports bases)
        alpha_t = stewart.TP.leg.ang*pi/180; % +- offset angle from 120 degree spacing on top

        % Height [m] TODO
        height = (stewart.h-stewart.BP.thickness-stewart.TP.thickness-stewart.Leg.sphere.bottom-stewart.Leg.sphere.top-stewart.SP.thickness.bottom-stewart.SP.thickness.top)*0.001;

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
        % TODO
        stewart.M_pos_base = stewart.pos_base + (height+(stewart.TP.thickness+stewart.Leg.sphere.top+stewart.SP.thickness.top+stewart.jacobian)*1e-3)*[zeros(6, 2),ones(6, 1)];

        %% Compute Jacobian Matrix
        % TODO
        %         aa = stewart.pos_top_tranform + (stewart.jacobian - stewart.TP.thickness - stewart.SP.height.top)*1e-3*[zeros(6, 2),ones(6, 1)];
        bb = stewart.pos_top_tranform - (stewart.TP.thickness + stewart.SP.height.top)*1e-3*[zeros(6, 2),ones(6, 1)];
        bb = bb - stewart.jacobian*1e-3*[zeros(6, 2),ones(6, 1)];
        stewart.J = getJacobianMatrix(leg_vectors', bb');

        stewart.K = stewart.Leg.k.ax*stewart.J'*stewart.J;
    end

    %% Compute the Jacobian Matrix
    function J  = getJacobianMatrix(RM, M_pos_base)
    % RM         - [3x6] unit vector of each leg in the fixed frame
    % M_pos_base - [3x6] vector of the leg connection at the top platform location in the fixed frame
        J = zeros(6);

        J(:, 1:3) = RM';
        J(:, 4:6) = cross(M_pos_base, RM)';
    end
end
