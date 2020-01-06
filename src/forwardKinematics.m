function [P, R] = forwardKinematics(stewart, args)
% forwardKinematics - Computed the pose of {B} with respect to {A} from the length of each strut
%
% Syntax: [in_data] = forwardKinematics(stewart)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - J  [6x6] - The Jacobian Matrix
%    - args - Can have the following fields:
%        - L  [6x1] - Length of each strut [m]
%
% Outputs:
%    - P  [3x1] - The estimated position of {B} with respect to {A}
%    - R  [3x3] - The estimated rotation matrix that gives the orientation of {B} with respect to {A}

arguments
    stewart
    args.L (6,1) double {mustBeNumeric} = zeros(6,1)
end

X = stewart.J\args.L;

P = X(1:3);

theta = norm(X(4:6));
s = X(4:6)/theta;

R = [s(1)^2*(1-cos(theta)) + cos(theta) ,        s(1)*s(2)*(1-cos(theta)) - s(3)*sin(theta), s(1)*s(3)*(1-cos(theta)) + s(2)*sin(theta);
     s(2)*s(1)*(1-cos(theta)) + s(3)*sin(theta), s(2)^2*(1-cos(theta)) + cos(theta),         s(2)*s(3)*(1-cos(theta)) - s(1)*sin(theta);
     s(3)*s(1)*(1-cos(theta)) - s(2)*sin(theta), s(3)*s(2)*(1-cos(theta)) + s(1)*sin(theta), s(3)^2*(1-cos(theta)) + cos(theta)];
