function [payload] = initializePayload(args)
% initializePayload - Initialize the Payload that can then be used for simulations and analysis
%
% Syntax: [payload] = initializePayload(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - type - 'none', 'rigid', 'flexible', 'cartesian'
%        - h [1x1] - Height of the CoM of the payload w.r.t {M} [m]
%                    This also the position where K and C are defined
%        - K [6x1] - Stiffness of the Payload [N/m, N/rad]
%        - C [6x1] - Damping of the Payload [N/(m/s), N/(rad/s)]
%        - m [1x1] - Mass of the Payload [kg]
%        - I [3x3] - Inertia matrix for the Payload [kg*m2]
%
% Outputs:
%    - payload - Struture with the following properties:
%        - type - 1 (none), 2 (rigid), 3 (flexible)
%        - h [1x1] - Height of the CoM of the payload w.r.t {M} [m]
%        - K [6x1] - Stiffness of the Payload [N/m, N/rad]
%        - C [6x1] - Stiffness of the Payload [N/(m/s), N/(rad/s)]
%        - m [1x1] - Mass of the Payload [kg]
%        - I [3x3] - Inertia matrix for the Payload [kg*m2]

arguments
  args.type char {mustBeMember(args.type,{'none', 'rigid', 'flexible', 'cartesian'})} = 'none'
  args.K (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e8*ones(6,1)
  args.C (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
  args.h (1,1) double {mustBeNumeric, mustBeNonnegative} = 100e-3
  args.m (1,1) double {mustBeNumeric, mustBeNonnegative} = 10
  args.I (3,3) double {mustBeNumeric, mustBeNonnegative} = 1*eye(3)
end

switch args.type
  case 'none'
    payload.type = 1;
  case 'rigid'
    payload.type = 2;
  case 'flexible'
    payload.type = 3;
  case 'cartesian'
    payload.type = 4;
end

payload.K = args.K;
payload.C = args.C;
payload.m = args.m;
payload.I = args.I;

payload.h = args.h;
