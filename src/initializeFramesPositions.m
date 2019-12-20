function [stewart] = initializeFramesPositions(opts_param)
% initializeFramesPositions - Initialize the positions of frames {A}, {B}, {F} and {M}
%
% Syntax: [stewart] = initializeFramesPositions(H, MO_B)
%
% Inputs:
%    - opts_param - Structure with the following fields:
%        - H    [1x1] - Total Height of the Stewart Platform [m]
%        - MO_B [1x1] - Height of the frame {B} with respect to {M} [m]
%
% Outputs:
%    - stewart - A structure with the following fields:
%        - H    [1x1] - Total Height of the Stewart Platform [m]
%        - FO_M [3x1] - Position of {M} with respect to {F} [m]
%        - MO_B [3x1] - Position of {B} with respect to {M} [m]
%        - FO_A [3x1] - Position of {A} with respect to {F} [m]

opts = struct(   ...
  'H',    90e-3, ... % [m]
  'MO_B', 50e-3  ... % [m]
  );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

stewart = struct();

stewart.H = opts.H; % Total Height of the Stewart Platform [m]

stewart.FO_M = [0; 0; stewart.H]; % Position of {M} with respect to {F} [m]

stewart.MO_B = [0; 0; opts.MO_B]; % Position of {B} with respect to {M} [m]

stewart.FO_A = stewart.MO_B + stewart.FO_M; % Position of {A} with respect to {F} [m]
