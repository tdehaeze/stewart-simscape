function [stewart] = initializeAmplifiedStrutDynamics(stewart, args)
% initializeAmplifiedStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeAmplifiedStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Ka [6x1] - Vertical stiffness contribution of the piezoelectric stack [N/m]
%        - Ca [6x1] - Vertical damping contribution of the piezoelectric stack [N/(m/s)]
%        - Kr [6x1] - Vertical (residual) stiffness when the piezoelectric stack is removed [N/m]
%        - Cr [6x1] - Vertical (residual) damping when the piezoelectric stack is removed [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - actuators.type = 2
%      - actuators.K   [6x1] - Total Stiffness of each strut [N/m]
%      - actuators.C   [6x1] - Total Damping of each strut [N/(m/s)]
%      - actuators.Ka [6x1] - Vertical stiffness contribution of the piezoelectric stack [N/m]
%      - actuators.Ca [6x1] - Vertical damping contribution of the piezoelectric stack [N/(m/s)]
%      - actuators.Kr [6x1] - Vertical stiffness when the piezoelectric stack is removed [N/m]
%      - actuators.Cr [6x1] - Vertical damping when the piezoelectric stack is removed [N/(m/s)]

arguments
    stewart
    args.Kr (6,1) double {mustBeNumeric, mustBeNonnegative} = 5e6*ones(6,1)
    args.Cr (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
    args.Ka (6,1) double {mustBeNumeric, mustBeNonnegative} = 15e6*ones(6,1)
    args.Ca (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
end

K = args.Ka + args.Kr;
C = args.Ca + args.Cr;

stewart.actuators.type = 2;

stewart.actuators.Ka = args.Ka;
stewart.actuators.Ca = args.Ca;

stewart.actuators.Kr = args.Kr;
stewart.actuators.Cr = args.Cr;

stewart.actuators.K = K;
stewart.actuators.C = K;
