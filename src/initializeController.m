function [controller] = initializeController(args)
% initializeController - Initialize the Controller
%
% Syntax: [] = initializeController(args)
%
% Inputs:
%    - args - Can have the following fields:

arguments
  args.type   char   {mustBeMember(args.type, {'open-loop', 'iff', 'dvf'})} = 'open-loop'
end

controller = struct();

switch args.type
  case 'open-loop'
    controller.type = 0;
  case 'iff'
    controller.type = 1;
  case 'dvf'
    controller.type = 2;
end
