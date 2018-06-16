function [G_legs, G_legs_raw] = identifyPlantLegs()
    %% Default values for opts
    opts = struct('f_low',  1,    ...
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
    io(1) = linio([mdl, '/F_legs'],          1,'input');
    io(2) = linio([mdl, '/Stewart_Platform'],2,'output');

    % Run the linearization
    G_legs_raw = linearize(mdl,io, 0);

    G_legs = preprocessIdTf(G_legs_raw, opts.f_low, opts.f_high);

    % Input/Output names
    G_legs.InputName  = {'F1', 'F2', 'F3', 'M4', 'M5', 'M6'};
    G_legs.OutputName = {'D1', 'D2', 'D3', 'R4', 'R5', 'R6'};
end

