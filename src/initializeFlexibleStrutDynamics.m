function [stewart] = initializeFlexibleStrutDynamics(stewart, args)
% initializeFlexibleStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeFlexibleStrutDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - K [nxn] - Vertical stiffness contribution of the piezoelectric stack [N/m]
%        - M [nxn] - Vertical damping contribution of the piezoelectric stack [N/(m/s)]
%        - xi        [1x1] - Vertical (residual) stiffness when the piezoelectric stack is removed [N/m]
%        - step_file [6x1] - Vertical (residual) damping when the piezoelectric stack is removed [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:

arguments
    stewart
    args.K        double {mustBeNumeric} = zeros(6,6)
    args.M        double {mustBeNumeric} = zeros(6,6)
    args.H        double {mustBeNumeric} = 0
    args.n_xyz    double {mustBeNumeric} = zeros(2,3)
    args.xi       double {mustBeNumeric} = 0.1
    args.step_file char {} = ''
end

stewart.actuators.ax_off = (stewart.geometry.l(1) - args.H)/2; % Axial Offset at the ends of the actuator

stewart.actuators.type = 3;

stewart.actuators.Km = args.K;
stewart.actuators.Mm = args.M;

stewart.actuators.n_xyz = args.n_xyz;
stewart.actuators.xi = args.xi;

stewart.actuators.step_file = args.step_file;

stewart.actuators.K = args.K(3,3); % Axial Stiffness
