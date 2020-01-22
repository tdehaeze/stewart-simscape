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
%      - struts [struct] - structure with the following fields:
%        - Fsm [6x1]   - Mass of the Fixed part of the struts [kg]
%        - Fsi [3x3x6] - Moment of Inertia for the Fixed part of the struts [kg*m^2]
%        - Msm [6x1]   - Mass of the Mobile part of the struts [kg]
%        - Msi [3x3x6] - Moment of Inertia for the Mobile part of the struts [kg*m^2]
%        - Fsh [6x1]   - Height of cylinder for the Fixed part of the struts [m]
%        - Fsr [6x1]   - Radius of cylinder for the Fixed part of the struts [m]
%        - Msh [6x1]   - Height of cylinder for the Mobile part of the struts [m]
%        - Msr [6x1]   - Radius of cylinder for the Mobile part of the struts [m]

arguments
    stewart
    args.Fsm (1,1) double {mustBeNumeric, mustBePositive} = 0.1
    args.Fsh (1,1) double {mustBeNumeric, mustBePositive} = 50e-3
    args.Fsr (1,1) double {mustBeNumeric, mustBePositive} = 5e-3
    args.Msm (1,1) double {mustBeNumeric, mustBePositive} = 0.1
    args.Msh (1,1) double {mustBeNumeric, mustBePositive} = 50e-3
    args.Msr (1,1) double {mustBeNumeric, mustBePositive} = 5e-3
end

struts = struct();

struts.Fsm = ones(6,1).*args.Fsm;
struts.Msm = ones(6,1).*args.Msm;

struts.Fsh = ones(6,1).*args.Fsh;
struts.Fsr = ones(6,1).*args.Fsr;
struts.Msh = ones(6,1).*args.Msh;
struts.Msr = ones(6,1).*args.Msr;

struts.Fsi = zeros(3, 3, 6);
struts.Msi = zeros(3, 3, 6);
for i = 1:6
  struts.Fsi(:,:,i) = diag([1/12 * struts.Fsm(i) * (3*struts.Fsr(i)^2 + struts.Fsh(i)^2), ...
                            1/12 * struts.Fsm(i) * (3*struts.Fsr(i)^2 + struts.Fsh(i)^2), ...
                            1/2  * struts.Fsm(i) * struts.Fsr(i)^2]);
  struts.Msi(:,:,i) = diag([1/12 * struts.Msm(i) * (3*struts.Msr(i)^2 + struts.Msh(i)^2), ...
                            1/12 * struts.Msm(i) * (3*struts.Msr(i)^2 + struts.Msh(i)^2), ...
                            1/2  * struts.Msm(i) * struts.Msr(i)^2]);
end

stewart.struts = struts;
