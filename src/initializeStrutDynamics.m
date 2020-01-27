function [stewart] = initializeStrutDynamics(stewart, args)
% initializeStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Ki [6x1] - Stiffness of each strut [N/m]
%        - Ci [6x1] - Damping of each strut [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Ki [6x1] - Stiffness of each strut [N/m]
%        - Ci [6x1] - Damping of each strut [N/(m/s)]

arguments
    stewart
    args.Ki (6,1) double {mustBeNumeric, mustBePositive} = 1e6*ones(6,1)
    args.Ci (6,1) double {mustBeNumeric, mustBePositive} = 1e1*ones(6,1)
end

stewart.Ki = args.Ki;
stewart.Ci = args.Ci;
