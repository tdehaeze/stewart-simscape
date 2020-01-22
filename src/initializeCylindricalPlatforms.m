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
%      - platforms [struct] - structure with the following fields:
%        - Fpm [1x1] - Fixed Platform Mass [kg]
%        - Msi [3x3] - Mobile Platform Inertia matrix [kg*m^2]
%        - Fph [1x1] - Fixed Platform Height [m]
%        - Fpr [1x1] - Fixed Platform Radius [m]
%        - Mpm [1x1] - Mobile Platform Mass [kg]
%        - Fsi [3x3] - Fixed Platform Inertia matrix [kg*m^2]
%        - Mph [1x1] - Mobile Platform Height [m]
%        - Mpr [1x1] - Mobile Platform Radius [m]

arguments
    stewart
    args.Fpm (1,1) double {mustBeNumeric, mustBePositive} = 1
    args.Fph (1,1) double {mustBeNumeric, mustBePositive} = 10e-3
    args.Fpr (1,1) double {mustBeNumeric, mustBePositive} = 125e-3
    args.Mpm (1,1) double {mustBeNumeric, mustBePositive} = 1
    args.Mph (1,1) double {mustBeNumeric, mustBePositive} = 10e-3
    args.Mpr (1,1) double {mustBeNumeric, mustBePositive} = 100e-3
end

platforms = struct();

platforms.Fpm = args.Fpm;
platforms.Fph = args.Fph;
platforms.Fpr = args.Fpr;
platforms.Fpi = diag([1/12 * platforms.Fpm * (3*platforms.Fpr^2 + platforms.Fph^2), ...
                      1/12 * platforms.Fpm * (3*platforms.Fpr^2 + platforms.Fph^2), ...
                      1/2  * platforms.Fpm * platforms.Fpr^2]);

platforms.Mpm = args.Mpm;
platforms.Mph = args.Mph;
platforms.Mpr = args.Mpr;
platforms.Mpi = diag([1/12 * platforms.Mpm * (3*platforms.Mpr^2 + platforms.Mph^2), ...
                      1/12 * platforms.Mpm * (3*platforms.Mpr^2 + platforms.Mph^2), ...
                      1/2  * platforms.Mpm * platforms.Mpr^2]);

stewart.platforms = platforms;
