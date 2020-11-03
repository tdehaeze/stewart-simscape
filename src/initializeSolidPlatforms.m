function [stewart] = initializeSolidPlatforms(stewart, args)
% initializeSolidPlatforms - Initialize the geometry of the Fixed and Mobile Platforms
%
% Syntax: [stewart] = initializeSolidPlatforms(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - density [1x1] - Density of the platforms [kg]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - platform_F [struct] - structure with the following fields:
%        - type = 2
%        - M [1x1] - Fixed Platform Density [kg/m^3]
%      - platform_M [struct] - structure with the following fields:
%        - type = 2
%        - M [1x1] - Mobile Platform Density [kg/m^3]

arguments
    stewart
    args.density (1,1) double {mustBeNumeric, mustBePositive} = 7800
end

stewart.platform_F.type = 2;

stewart.platform_F.density = args.density;

stewart.platform_M.type = 2;

stewart.platform_M.density = args.density;
