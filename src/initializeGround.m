function [ground] = initializeGround(args)
% initializeGround - Initialize the Ground that can then be used for simulations and analysis
%
% Syntax: [ground] = initializeGround(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - type - 'none', 'solid', 'flexible'
%        - K [3x1] - Translation Stiffness of the Ground [N/m]
%        - C [3x1] - Translation Damping of the Ground [N/(m/s)]
%
% Outputs:
%    - ground - Struture with the following properties:
%        - type - 1 (none), 2 (solid), 3 (flexible)
%        - K [3x1] - Translation Stiffness of the Ground [N/m]
%        - C [3x1] - Translation Damping of the Ground [N/(m/s)]

arguments
  args.type char {mustBeMember(args.type,{'none', 'solid', 'flexible'})} = 'none'
  args.K (3,1) double {mustBeNumeric, mustBeNonnegative} = 1e8*ones(3,1)
  args.C (3,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(3,1)
end

switch args.type
  case 'none'
    ground.type = 1;
  case 'solid'
    ground.type = 2;
  case 'flexible'
    ground.type = 3;
end

ground.K = args.K;
ground.C = args.C;
