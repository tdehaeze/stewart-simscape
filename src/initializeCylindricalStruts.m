function [stewart] = initializeCylindricalStruts(stewart, args)
% initializeCylindricalStruts - Define the mass and moment of inertia of cylindrical struts
%
% Syntax: [stewart] = initializeCylindricalStruts(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Fsm [1x1] - Mass of the Fixed part of the struts [kg]
%        - Fsh [1x1] - Height of cylinder for the Fixed part of the struts [m]
%        - Fsr [1x1] - Radius of cylinder for the Fixed part of the struts [m]
%        - Msm [1x1] - Mass of the Mobile part of the struts [kg]
%        - Msh [1x1] - Height of cylinder for the Mobile part of the struts [m]
%        - Msr [1x1] - Radius of cylinder for the Mobile part of the struts [m]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - struts_F [struct] - structure with the following fields:
%        - M [6x1]   - Mass of the Fixed part of the struts [kg]
%        - I [3x3x6] - Moment of Inertia for the Fixed part of the struts [kg*m^2]
%        - H [6x1]   - Height of cylinder for the Fixed part of the struts [m]
%        - R [6x1]   - Radius of cylinder for the Fixed part of the struts [m]
%      - struts_M [struct] - structure with the following fields:
%        - M [6x1]   - Mass of the Mobile part of the struts [kg]
%        - I [3x3x6] - Moment of Inertia for the Mobile part of the struts [kg*m^2]
%        - H [6x1]   - Height of cylinder for the Mobile part of the struts [m]
%        - R [6x1]   - Radius of cylinder for the Mobile part of the struts [m]

arguments
    stewart
    args.type_F    char   {mustBeMember(args.type_F,{'cylindrical', 'none'})} = 'cylindrical'
    args.type_M    char   {mustBeMember(args.type_M,{'cylindrical', 'none'})} = 'cylindrical'
    args.Fsm (1,1) double {mustBeNumeric, mustBePositive} = 0.1
    args.Fsh (1,1) double {mustBeNumeric, mustBePositive} = 50e-3
    args.Fsr (1,1) double {mustBeNumeric, mustBePositive} = 5e-3
    args.Msm (1,1) double {mustBeNumeric, mustBePositive} = 0.1
    args.Msh (1,1) double {mustBeNumeric, mustBePositive} = 50e-3
    args.Msr (1,1) double {mustBeNumeric, mustBePositive} = 5e-3
end

Fsm = ones(6,1).*args.Fsm;
Fsh = ones(6,1).*args.Fsh;
Fsr = ones(6,1).*args.Fsr;

Msm = ones(6,1).*args.Msm;
Msh = ones(6,1).*args.Msh;
Msr = ones(6,1).*args.Msr;

I_F = zeros(3, 3, 6); % Inertia of the "fixed" part of the strut
I_M = zeros(3, 3, 6); % Inertia of the "mobile" part of the strut

for i = 1:6
  I_F(:,:,i) = diag([1/12 * Fsm(i) * (3*Fsr(i)^2 + Fsh(i)^2), ...
                     1/12 * Fsm(i) * (3*Fsr(i)^2 + Fsh(i)^2), ...
                     1/2  * Fsm(i) * Fsr(i)^2]);

  I_M(:,:,i) = diag([1/12 * Msm(i) * (3*Msr(i)^2 + Msh(i)^2), ...
                     1/12 * Msm(i) * (3*Msr(i)^2 + Msh(i)^2), ...
                     1/2  * Msm(i) * Msr(i)^2]);
end

switch args.type_M
  case 'cylindrical'
    stewart.struts_M.type = 1;
  case 'none'
    stewart.struts_M.type = 2;
end

stewart.struts_M.I = I_M;
stewart.struts_M.M = Msm;
stewart.struts_M.R = Msr;
stewart.struts_M.H = Msh;

switch args.type_F
  case 'cylindrical'
    stewart.struts_F.type = 1;
  case 'none'
    stewart.struts_F.type = 2;
end

stewart.struts_F.I = I_F;
stewart.struts_F.M = Fsm;
stewart.struts_F.R = Fsr;
stewart.struts_F.H = Fsh;
