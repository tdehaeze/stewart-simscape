function [] = initializeSample(opts_param)
    %% Default values for opts
    sample = struct('radius', 100,...
                    'height', 300,...
                    'mass',   50,...
                    'offset', 0,...
                    'color',  [0.9 0.1 0.1] ...
    );

    %% Populate opts with input parameters
    if exist('opts_param','var')
        for opt = fieldnames(opts_param)'
            sample.(opt{1}) = opts_param.(opt{1});
        end
    end

    %% Save
    save('./mat/sample.mat', 'sample');
end
