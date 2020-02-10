function [stewart] = initializeAmplifiedStrutDynamics(stewart, args)
% initializeAmplifiedStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeAmplifiedStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - Ksi [6x1] - Vertical stiffness contribution of the piezoelectric stack [N/m]
%        - Csi [6x1] - Vertical damping contribution of the piezoelectric stack [N/(m/s)]
%        - Kdi [6x1] - Vertical stiffness when the piezoelectric stack is removed [N/m]
%        - Cdi [6x1] - Vertical damping when the piezoelectric stack is removed [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Ki  [6x1] - Total Stiffness of each strut [N/m]
%        - Ci  [6x1] - Total Damping of each strut [N/(m/s)]
%        - Ksi [6x1] - Vertical stiffness contribution of the piezoelectric stack [N/m]
%        - Csi [6x1] - Vertical damping contribution of the piezoelectric stack [N/(m/s)]
%        - Kdi [6x1] - Vertical stiffness when the piezoelectric stack is removed [N/m]
%        - Cdi [6x1] - Vertical damping when the piezoelectric stack is removed [N/(m/s)]

arguments
    stewart
    args.Kdi (6,1) double {mustBeNumeric, mustBeNonnegative} = 5e6*ones(6,1)
    args.Cdi (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
    args.Ksi (6,1) double {mustBeNumeric, mustBeNonnegative} = 15e6*ones(6,1)
    args.Csi (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e1*ones(6,1)
end

stewart.Ksi = args.Ksi;
stewart.Csi = args.Csi;

stewart.Kdi = args.Kdi;
stewart.Cdi = args.Cdi;

stewart.Ki = args.Ksi + args.Kdi;
stewart.Ci = args.Csi + args.Cdi;

stewart.actuator_type = 2;
