function [ground] = initializeGround(args)
% initializeGround - Initialize the Ground that can then be used for simulations and analysis
%
% Syntax: [ground] = initializeGround(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - type - 'none', 'solid', 'flexible'
%        - rot_point [3x1] - Rotation point for the ground motion [m]
%        - K [3x1] - Translation Stiffness of the Ground [N/m]
%        - C [3x1] - Translation Damping of the Ground [N/(m/s)]
%
% Outputs:
%    - ground - Struture with the following properties:
%        - type - 1 (none), 2 (rigid), 3 (flexible)
%        - K [3x1] - Translation Stiffness of the Ground [N/m]
%        - C [3x1] - Translation Damping of the Ground [N/(m/s)]

arguments
  args.type char {mustBeMember(args.type,{'none', 'rigid', 'flexible'})} = 'none'
  args.rot_point (3,1) double {mustBeNumeric} = zeros(3,1)
  args.K (3,1) double {mustBeNumeric, mustBeNonnegative} = 1e8*ones(3,1)
  args.C (3,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(3,1)
end

switch args.type
  case 'none'
    ground.type = 1;
  case 'rigid'
    ground.type = 2;
  case 'flexible'
    ground.type = 3;
end

ground.K = args.K;
ground.C = args.C;

ground.rot_point = args.rot_point;
