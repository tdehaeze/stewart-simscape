function [geophone] = initializeZAxisGeophone(args)
    arguments
        args.mass (1,1) double {mustBeNumeric, mustBePositive} = 1e-3 % [kg]
        args.freq (1,1) double {mustBeNumeric, mustBePositive} = 1    % [Hz]
    end

    %%
    geophone.m = args.mass;

    %% The Stiffness is set to have the damping resonance frequency
    geophone.k = geophone.m * (2*pi*args.freq)^2;

    %% We set the damping value to have critical damping
    geophone.c = 2*sqrt(geophone.m * geophone.k);

    %% Save
    save('./mat/geophone_z_axis.mat', 'geophone');
end
