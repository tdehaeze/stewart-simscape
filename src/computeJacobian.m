function [stewart] = computeJacobian(stewart)
% computeJacobian -
%
% Syntax: [stewart] = computeJacobian(stewart)
%
% Inputs:
%    - stewart - With at least the following fields:
%        - As [3x6] - The 6 unit vectors for each strut expressed in {A}
%        - Ab [3x6] - The 6 position of the joints bi expressed in {A}
%
% Outputs:
%    - stewart - With the 3 added field:
%        - J [6x6] - The Jacobian Matrix
%        - K [6x6] - The Stiffness Matrix
%        - C [6x6] - The Compliance Matrix

stewart.J = [stewart.As' , cross(stewart.Ab, stewart.As)'];

stewart.K = stewart.J'*diag(stewart.Ki)*stewart.J;

stewart.C = inv(stewart.K);
