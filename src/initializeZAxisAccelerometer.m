function [accelerometer] = initializeZAxisAccelerometer(args)
    arguments
        args.mass (1,1) double {mustBeNumeric, mustBePositive} = 5e-3 % [kg]
        args.freq (1,1) double {mustBeNumeric, mustBePositive} = 5e3  % [Hz]
    end

    %%
    accelerometer.m = args.mass;

    %% The Stiffness is set to have the damping resonance frequency
    accelerometer.k = accelerometer.m * (2*pi*args.freq)^2;

    %% We set the damping value to have critical damping
    accelerometer.c = 2*sqrt(accelerometer.m * accelerometer.k);

    %% Gain correction of the accelerometer to have a unity gain until the resonance
    accelerometer.gain = -accelerometer.k/accelerometer.m;

    %% Save
    save('./mat/accelerometer_z_axis.mat', 'accelerometer');
end
