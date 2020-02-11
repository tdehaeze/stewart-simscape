function [Li, dLi] = inverseKinematics(stewart, args)
% inverseKinematics - Compute the needed length of each strut to have the wanted position and orientation of {B} with respect to {A}
%
% Syntax: [stewart] = inverseKinematics(stewart)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - geometry.Aa   [3x6] - The positions ai expressed in {A}
%        - geometry.Bb   [3x6] - The positions bi expressed in {B}
%        - geometry.l    [6x1] - Length of each strut
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

assert(isfield(stewart.geometry, 'Aa'),   'stewart.geometry should have attribute Aa')
Aa = stewart.geometry.Aa;

assert(isfield(stewart.geometry, 'Bb'),   'stewart.geometry should have attribute Bb')
Bb = stewart.geometry.Bb;

assert(isfield(stewart.geometry, 'l'),   'stewart.geometry should have attribute l')
l = stewart.geometry.l;

Li = sqrt(args.AP'*args.AP + diag(Bb'*Bb) + diag(Aa'*Aa) - (2*args.AP'*Aa)' + (2*args.AP'*(args.ARB*Bb))' - diag(2*(args.ARB*Bb)'*Aa));

dLi = Li-l;
