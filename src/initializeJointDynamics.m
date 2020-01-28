function [stewart] = initializeJointDynamics(stewart, args)
% initializeJointDynamics - Add Stiffness and Damping properties for the spherical joints
%
% Syntax: [stewart] = initializeJointDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Kri [6x1] - Rotational Stiffness for each spherical joints [N/rad]
%        - Cri [6x1] - Damping of each spherical joint [N/(rad/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Kri [6x1] - Rotational Stiffness for each spherical joints [N/rad]
%        - Cri [6x1] - Damping of each spherical joint [N/(rad/s)]

arguments
    stewart
    args.Kri (6,1) double {mustBeNumeric, mustBePositive} = zeros(6,1)
    args.Cri (6,1) double {mustBeNumeric, mustBePositive} = zeros(6,1)
end

stewart.Kri = args.Kri;
stewart.Cri = args.Cri;
