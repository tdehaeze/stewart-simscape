function [stewart] = initializeFramesPositions(stewart, args)
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
%        - geometry.H      [1x1] - Total Height of the Stewart Platform [m]
%        - geometry.FO_M   [3x1] - Position of {M} with respect to {F} [m]
%        - platform_M.MO_B [3x1] - Position of {B} with respect to {M} [m]
%        - platform_F.FO_A [3x1] - Position of {A} with respect to {F} [m]

arguments
    stewart
    args.H    (1,1) double {mustBeNumeric, mustBePositive} = 90e-3
    args.MO_B (1,1) double {mustBeNumeric} = 50e-3
end

H = args.H; % Total Height of the Stewart Platform [m]

FO_M = [0; 0; H]; % Position of {M} with respect to {F} [m]

MO_B = [0; 0; args.MO_B]; % Position of {B} with respect to {M} [m]

FO_A = MO_B + FO_M; % Position of {A} with respect to {F} [m]

stewart.geometry.H      = H;
stewart.geometry.FO_M   = FO_M;
stewart.platform_M.MO_B = MO_B;
stewart.platform_F.FO_A = FO_A;
