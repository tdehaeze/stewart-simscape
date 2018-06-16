function [G_cart, G_cart_raw] = getPlantCart()
    %% Default values for opts
    opts = struct('f_low', 1,...
                  'f_high', 10000 ...
    );

    %% Populate opts with input parameters
    if exist('opts_param','var')
        for opt = fieldnames(opts_param)'
            opts.(opt{1}) = opts_param.(opt{1});
        end
    end

    %% Options for Linearized
    options = linearizeOptions;
    options.SampleTime = 0;

    %% Name of the Simulink File
    mdl = 'stewart_simscape';

    %% Centralized control (Cartesian coordinates)
    % Input/Output definition
    io(1) = linio([mdl, '/F_cart'],1,'input');
    io(2) = linio([mdl, '/Stewart_Platform'],1,'output');

    % Run the linearization
    G_cart_raw = linearize(mdl,io, 0);

    G_cart = preprocessIdTf(G_cart_raw, opts.f_low, opts.f_high);

    % Input/Output names
    G_cart.InputName  = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'};
    G_cart.OutputName = {'Dx', 'Dy', 'Dz', 'Rx', 'Ry', 'Rz'};
end

