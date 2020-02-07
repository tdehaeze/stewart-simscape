function [stewart] = initializeJointDynamics(stewart, args)
% initializeJointDynamics - Add Stiffness and Damping properties for the spherical joints
%
% Syntax: [stewart] = initializeJointDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Ksbi [6x1] - Bending (Rx, Ry) Stiffness for each top Spherical joints [(N.m)/rad]
%        - Csbi [6x1] - Bending (Rx, Ry) Damping of each top Spherical joint [(N.m)/(rad/s)]
%        - Ksti [6x1] - Torsion (Rz) Stiffness for each top Spherical joints [(N.m)/rad]
%        - Csti [6x1] - Torsion (Rz) Damping of each top Spherical joint [(N.m)/(rad/s)]
%        - Kubi [6x1] - Bending (Rx, Ry) Stiffness for each bottom Universal joints [(N.m)/rad]
%        - Cubi [6x1] - Bending (Rx, Ry) Damping of each bottom Universal joint [(N.m)/(rad/s)]
%        - disable [boolean] - Sets all the stiffness/damping to zero
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Ksbi [6x1] - Bending (Rx, Ry) Stiffness for each top Spherical joints [(N.m)/rad]
%        - Csbi [6x1] - Bending (Rx, Ry) Damping of each top Spherical joint [(N.m)/(rad/s)]
%        - Ksti [6x1] - Torsion (Rz) Stiffness for each top Spherical joints [(N.m)/rad]
%        - Csti [6x1] - Torsion (Rz) Damping of each top Spherical joint [(N.m)/(rad/s)]
%        - Kubi [6x1] - Bending (Rx, Ry) Stiffness for each bottom Universal joints [(N.m)/rad]
%        - Cubi [6x1] - Bending (Rx, Ry) Damping of each bottom Universal joint [(N.m)/(rad/s)]

arguments
    stewart
    args.Ksbi (6,1) double {mustBeNumeric, mustBeNonnegative} = 15*ones(6,1)
    args.Csbi (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-4*ones(6,1)
    args.Ksti (6,1) double {mustBeNumeric, mustBeNonnegative} = 20*ones(6,1)
    args.Csti (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-3*ones(6,1)
    args.Kubi (6,1) double {mustBeNumeric, mustBeNonnegative} = 15*ones(6,1)
    args.Cubi (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-4*ones(6,1)
    args.disable logical {mustBeNumericOrLogical} = false
end

if args.disable
  stewart.Ksbi = zeros(6,1);
  stewart.Csbi = zeros(6,1);
  stewart.Ksti = zeros(6,1);
  stewart.Csti = zeros(6,1);
  stewart.Kubi = zeros(6,1);
  stewart.Cubi = zeros(6,1);
else
  stewart.Ksbi = args.Ksbi;
  stewart.Csbi = args.Csbi;
  stewart.Ksti = args.Ksti;
  stewart.Csti = args.Csti;
  stewart.Kubi = args.Kubi;
  stewart.Cubi = args.Cubi;
end
