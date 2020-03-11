function [controller] = initializeController(args)
% initializeController - Initialize the Controller
%
% Syntax: [] = initializeController(args)
%
% Inputs:
%    - args - Can have the following fields:

arguments
  args.type   char   {mustBeMember(args.type, {'open-loop', 'iff', 'dvf', 'hac-iff', 'hac-dvf', 'ref-track-L', 'ref-track-X'})} = 'open-loop'
end

controller = struct();

switch args.type
  case 'open-loop'
    controller.type = 0;
  case 'iff'
    controller.type = 1;
  case 'dvf'
    controller.type = 2;
  case 'hac-iff'
    controller.type = 3;
  case 'hac-dvf'
    controller.type = 4;
  case 'ref-track-L'
    controller.type = 5;
  case 'ref-track-X'
    controller.type = 6;
end
