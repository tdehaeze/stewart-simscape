function [] = initializeSample(opts_param)

sample = struct( ...
    'radius',     100, ... % radius of the cylinder [mm]
    'height',     100, ... % height of the cylinder [mm]
    'mass',       10,  ... % mass of the cylinder [kg]
    'measheight', 50, ... % measurement point z-offset [mm]
    'offset',     [0, 0, 0],   ... % offset position of the sample [mm]
    'color',      [0.9 0.1 0.1] ...
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        sample.(opt{1}) = opts_param.(opt{1});
    end
end

save('./mat/sample.mat', 'sample');

end
