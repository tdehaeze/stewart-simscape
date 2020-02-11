function [stewart] = initializeStewartPlatform()
% initializeStewartPlatform - Initialize the stewart structure
%
% Syntax: [stewart] = initializeStewartPlatform(args)
%
% Outputs:
%    - stewart - A structure with the following sub-structures:
%      - platform_F -
%      - platform_M -
%      - joints_F   -
%      - joints_M   -
%      - struts_F   -
%      - struts_M   -
%      - actuators  -
%      - geometry   -
%      - properties -

stewart = struct();
stewart.platform_F = struct();
stewart.platform_M = struct();
stewart.joints_F   = struct();
stewart.joints_M   = struct();
stewart.struts_F   = struct();
stewart.struts_M   = struct();
stewart.actuators  = struct();
stewart.sensors    = struct();
stewart.sensors.inertial = struct();
stewart.sensors.force    = struct();
stewart.sensors.relative = struct();
stewart.geometry   = struct();
stewart.kinematics = struct();
