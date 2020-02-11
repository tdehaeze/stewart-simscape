function [stewart] = initializeStrutDynamics(stewart, args)
% initializeStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - K [6x1] - Stiffness of each strut [N/m]
%        - C [6x1] - Damping of each strut [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - actuators.type = 1
%      - actuators.K [6x1] - Stiffness of each strut [N/m]
%      - actuators.C [6x1] - Damping of each strut [N/(m/s)]

arguments
    stewart
    args.K (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e6*ones(6,1)
    args.C (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
end

stewart.actuators.type = 1;

stewart.actuators.K = args.K;
stewart.actuators.C = args.C;
