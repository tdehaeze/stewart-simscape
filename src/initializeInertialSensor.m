function [stewart] = initializeInertialSensor(stewart, args)
% initializeInertialSensor - Initialize the inertial sensor in each strut
%
% Syntax: [stewart] = initializeInertialSensor(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - type       - 'geophone', 'accelerometer', 'none'
%        - mass [1x1] - Weight of the inertial mass [kg]
%        - freq [1x1] - Cutoff frequency [Hz]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - stewart.sensors.inertial
%        - type    - 1 (geophone), 2 (accelerometer), 3 (none)
%        - K [1x1] - Stiffness [N/m]
%        - C [1x1] - Damping [N/(m/s)]
%        - M [1x1] - Inertial Mass [kg]
%        - G [1x1] - Gain

arguments
    stewart
    args.type       char   {mustBeMember(args.type,{'geophone', 'accelerometer', 'none'})} = 'none'
    args.mass (1,1) double {mustBeNumeric, mustBeNonnegative} = 1e-2
    args.freq (1,1) double {mustBeNumeric, mustBeNonnegative} = 1e3
end

sensor = struct();

switch args.type
  case 'geophone'
    sensor.type = 1;

    sensor.M = args.mass;
    sensor.K = sensor.M * (2*pi*args.freq)^2;
    sensor.C = 2*sqrt(sensor.M * sensor.K);
  case 'accelerometer'
    sensor.type = 2;

    sensor.M = args.mass;
    sensor.K = sensor.M * (2*pi*args.freq)^2;
    sensor.C = 2*sqrt(sensor.M * sensor.K);
    sensor.G = -sensor.K/sensor.M;
  case 'none'
    sensor.type = 3;
end

stewart.sensors.inertial = sensor;
