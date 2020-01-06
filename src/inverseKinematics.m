function [Li, dLi] = inverseKinematics(stewart, args)
% inverseKinematics - Compute the needed length of each strut to have the wanted position and orientation of {B} with respect to {A}
%
% Syntax: [stewart] = inverseKinematics(stewart)
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
%    - Li   [6x1] - The 6 needed length of the struts in [m] to have the wanted pose of {B} w.r.t. {A}
%    - dLi  [6x1] - The 6 needed displacement of the struts from the initial position in [m] to have the wanted pose of {B} w.r.t. {A}

arguments
    stewart
    args.AP  (3,1) double {mustBeNumeric} = zeros(3,1)
    args.ARB (3,3) double {mustBeNumeric} = eye(3)
end

Li = sqrt(args.AP'*args.AP + diag(stewart.Bb'*stewart.Bb) + diag(stewart.Aa'*stewart.Aa) - (2*args.AP'*stewart.Aa)' + (2*args.AP'*(args.ARB*stewart.Bb))' - diag(2*(args.ARB*stewart.Bb)'*stewart.Aa));

dLi = Li-stewart.l;
