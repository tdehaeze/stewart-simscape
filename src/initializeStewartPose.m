function [stewart] = initializeStewartPose(stewart, args)
% initializeStewartPose - Determine the initial stroke in each leg to have the wanted pose
%                         It uses the inverse kinematic
%
% Syntax: [stewart] = initializeStewartPose(stewart, args)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - Aa   [3x6] - The positions ai expressed in {A}
%        - Bb   [3x6] - The positions bi expressed in {B}
%    - args - Can have the following fields:
%        - AP   [3x1] - The wanted position of {B} with respect to {A}
%        - ARB  [3x3] - The rotation matrix that gives the wanted orientation of {B} with respect to {A}
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - actuators.Leq [6x1] - The 6 needed displacement of the struts from the initial position in [m] to have the wanted pose of {B} w.r.t. {A}

arguments
    stewart
    args.AP  (3,1) double {mustBeNumeric} = zeros(3,1)
    args.ARB (3,3) double {mustBeNumeric} = eye(3)
end

[Li, dLi] = inverseKinematics(stewart, 'AP', args.AP, 'ARB', args.ARB);

stewart.actuators.Leq = dLi;
