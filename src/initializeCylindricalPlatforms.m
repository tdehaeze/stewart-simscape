function [stewart] = initializeCylindricalPlatforms(stewart, args)
% initializeCylindricalPlatforms - Initialize the geometry of the Fixed and Mobile Platforms
%
% Syntax: [stewart] = initializeCylindricalPlatforms(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Fpm [1x1] - Fixed Platform Mass [kg]
%        - Fph [1x1] - Fixed Platform Height [m]
%        - Fpr [1x1] - Fixed Platform Radius [m]
%        - Mpm [1x1] - Mobile Platform Mass [kg]
%        - Mph [1x1] - Mobile Platform Height [m]
%        - Mpr [1x1] - Mobile Platform Radius [m]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - platform_F [struct] - structure with the following fields:
%        - type = 1
%        - M [1x1] - Fixed Platform Mass [kg]
%        - I [3x3] - Fixed Platform Inertia matrix [kg*m^2]
%        - H [1x1] - Fixed Platform Height [m]
%        - R [1x1] - Fixed Platform Radius [m]
%      - platform_M [struct] - structure with the following fields:
%        - M [1x1] - Mobile Platform Mass [kg]
%        - I [3x3] - Mobile Platform Inertia matrix [kg*m^2]
%        - H [1x1] - Mobile Platform Height [m]
%        - R [1x1] - Mobile Platform Radius [m]

arguments
    stewart
    args.Fpm (1,1) double {mustBeNumeric, mustBePositive} = 1
    args.Fph (1,1) double {mustBeNumeric, mustBePositive} = 10e-3
    args.Fpr (1,1) double {mustBeNumeric, mustBePositive} = 125e-3
    args.Mpm (1,1) double {mustBeNumeric, mustBePositive} = 1
    args.Mph (1,1) double {mustBeNumeric, mustBePositive} = 10e-3
    args.Mpr (1,1) double {mustBeNumeric, mustBePositive} = 100e-3
end

I_F = diag([1/12*args.Fpm * (3*args.Fpr^2 + args.Fph^2), ...
            1/12*args.Fpm * (3*args.Fpr^2 + args.Fph^2), ...
            1/2 *args.Fpm * args.Fpr^2]);

I_M = diag([1/12*args.Mpm * (3*args.Mpr^2 + args.Mph^2), ...
            1/12*args.Mpm * (3*args.Mpr^2 + args.Mph^2), ...
            1/2 *args.Mpm * args.Mpr^2]);

stewart.platform_F.type = 1;

stewart.platform_F.I = I_F;
stewart.platform_F.M = args.Fpm;
stewart.platform_F.R = args.Fpr;
stewart.platform_F.H = args.Fph;

stewart.platform_M.type = 1;

stewart.platform_M.I = I_M;
stewart.platform_M.M = args.Mpm;
stewart.platform_M.R = args.Mpr;
stewart.platform_M.H = args.Mph;
