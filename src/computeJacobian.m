function [stewart] = computeJacobian(stewart)
% computeJacobian -
%
% Syntax: [stewart] = computeJacobian(stewart)
%
% Inputs:
%    - stewart - With at least the following fields:
%      - geometry.As [3x6] - The 6 unit vectors for each strut expressed in {A}
%      - geometry.Ab [3x6] - The 6 position of the joints bi expressed in {A}
%      - actuators.K [6x1] - Total stiffness of the actuators
%
% Outputs:
%    - stewart - With the 3 added field:
%        - kinematics.J [6x6] - The Jacobian Matrix
%        - kinematics.K [6x6] - The Stiffness Matrix
%        - kinematics.C [6x6] - The Compliance Matrix

assert(isfield(stewart.geometry, 'As'),   'stewart.geometry should have attribute As')
As = stewart.geometry.As;

assert(isfield(stewart.geometry, 'Ab'),   'stewart.geometry should have attribute Ab')
Ab = stewart.geometry.Ab;

assert(isfield(stewart.actuators, 'K'),   'stewart.actuators should have attribute K')
Ki = stewart.actuators.K;

J = [As' , cross(Ab, As)'];

K = J'*diag(Ki)*J;

C = inv(K);

stewart.kinematics.J = J;
stewart.kinematics.K = K;
stewart.kinematics.C = C;
