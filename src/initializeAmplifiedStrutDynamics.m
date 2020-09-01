function [stewart] = initializeAmplifiedStrutDynamics(stewart, args)
% initializeAmplifiedStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeAmplifiedStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Ka [6x1] - Stiffness of the actuator [N/m]
%        - Ke [6x1] - Stiffness used to adjust the pole of the isolator [N/m]
%        - K1 [6x1] - Stiffness of the metallic suspension when the stack is removed [N/m]
%        - C1 [6x1] - Added viscous damping [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - actuators.type = 2
%      - actuators.K   [6x1] - Total Stiffness of each strut [N/m]
%      - actuators.C   [6x1] - Total Damping of each strut [N/(m/s)]
%      - actuators.Ka [6x1] - Stiffness of the actuator [N/m]
%      - actuators.Ke [6x1] - Stiffness used to adjust the pole of the isolator [N/m]
%      - actuators.K1 [6x1] - Stiffness of the metallic suspension when the stack is removed [N/m]
%      - actuators.C1 [6x1] - Added viscous damping [N/(m/s)]

arguments
    stewart
    args.Ke (6,1) double {mustBeNumeric, mustBeNonnegative} = 1.5e6*ones(6,1)
    args.Ka (6,1) double {mustBeNumeric, mustBeNonnegative} = 43e6*ones(6,1)
    args.K1 (6,1) double {mustBeNumeric, mustBeNonnegative} = 0.4e6*ones(6,1)
    args.C1 (6,1) double {mustBeNumeric, mustBeNonnegative} = 10*ones(6,1)
end

K = args.K1 + args.Ka.*args.Ke./(args.Ka + args.Ke);
C = args.C1;

stewart.actuators.type = 2;

stewart.actuators.Ka = args.Ka;
stewart.actuators.Ke = args.Ke;
stewart.actuators.K1 = args.K1;
stewart.actuators.C1 = args.C1;

stewart.actuators.K = K;
stewart.actuators.C = C;
