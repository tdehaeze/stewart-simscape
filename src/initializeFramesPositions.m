function [stewart] = initializeFramesPositions(args)
% initializeFramesPositions - Initialize the positions of frames {A}, {B}, {F} and {M}
%
% Syntax: [stewart] = initializeFramesPositions(args)
%
% Inputs:
%    - args - Can have the following fields:
%        - H    [1x1] - Total Height of the Stewart Platform (height from {F} to {M}) [m]
%        - MO_B [1x1] - Height of the frame {B} with respect to {M} [m]
%
% Outputs:
%    - stewart - A structure with the following fields:
%        - H    [1x1] - Total Height of the Stewart Platform [m]
%        - FO_M [3x1] - Position of {M} with respect to {F} [m]
%        - MO_B [3x1] - Position of {B} with respect to {M} [m]
%        - FO_A [3x1] - Position of {A} with respect to {F} [m]

arguments
    args.H    (1,1) double {mustBeNumeric, mustBePositive} = 90e-3
    args.MO_B (1,1) double {mustBeNumeric} = 50e-3
end

stewart = struct();

stewart.H = args.H; % Total Height of the Stewart Platform [m]

stewart.FO_M = [0; 0; stewart.H]; % Position of {M} with respect to {F} [m]

stewart.MO_B = [0; 0; args.MO_B]; % Position of {B} with respect to {M} [m]

stewart.FO_A = stewart.MO_B + stewart.FO_M; % Position of {A} with respect to {F} [m]
