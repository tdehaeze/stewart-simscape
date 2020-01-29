function [stewart] = initializeJointDynamics(stewart, args)
% initializeJointDynamics - Add Stiffness and Damping properties for the spherical joints
%
% Syntax: [stewart] = initializeJointDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Kbi [6x1] - Rotational Stiffness for each top spherical joints [N/rad]
%        - Cbi [6x1] - Damping of each top spherical joint [N/(rad/s)]
%        - Kti [6x1] - Rotational Stiffness for each bottom universal joints [N/rad]
%        - Cti [6x1] - Damping of each bottom universal joint [N/(rad/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Kbi [6x1] - Rotational Stiffness for each top spherical joints [N/rad]
%        - Cbi [6x1] - Damping of each top spherical joint [N/(rad/s)]
%        - Kti [6x1] - Rotational Stiffness for each bottom universal joints [N/rad]
%        - Cti [6x1] - Damping of each bottom universal joint [N/(rad/s)]

arguments
    stewart
    args.Kti (6,1) double {mustBeNumeric, mustBeNonnegative} = zeros(6,1)
    args.Cti (6,1) double {mustBeNumeric, mustBeNonnegative} = zeros(6,1)
    args.Kbi (6,1) double {mustBeNumeric, mustBeNonnegative} = zeros(6,1)
    args.Cbi (6,1) double {mustBeNumeric, mustBeNonnegative} = zeros(6,1)
end

stewart.Kti = args.Kti;
stewart.Cti = args.Cti;
stewart.Kbi = args.Kbi;
stewart.Cbi = args.Cbi;
