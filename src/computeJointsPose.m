function [stewart] = computeJointsPose(stewart, args)
% computeJointsPose -
%
% Syntax: [stewart] = computeJointsPose(stewart, args)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - platform_F.Fa   [3x6] - Its i'th column is the position vector of joint ai with respect to {F}
%        - platform_M.Mb   [3x6] - Its i'th column is the position vector of joint bi with respect to {M}
%        - platform_F.FO_A [3x1] - Position of {A} with respect to {F}
%        - platform_M.MO_B [3x1] - Position of {B} with respect to {M}
%        - geometry.FO_M   [3x1] - Position of {M} with respect to {F}
%    - args - Can have the following fields:
%        - AP   [3x1] - The wanted position of {B} with respect to {A}
%        - ARB  [3x3] - The rotation matrix that gives the wanted orientation of {B} with respect to {A}
%
% Outputs:
%    - stewart - A structure with the following added fields
%        - geometry.Aa    [3x6]   - The i'th column is the position of ai with respect to {A}
%        - geometry.Ab    [3x6]   - The i'th column is the position of bi with respect to {A}
%        - geometry.Ba    [3x6]   - The i'th column is the position of ai with respect to {B}
%        - geometry.Bb    [3x6]   - The i'th column is the position of bi with respect to {B}
%        - geometry.l     [6x1]   - The i'th element is the initial length of strut i
%        - geometry.As    [3x6]   - The i'th column is the unit vector of strut i expressed in {A}
%        - geometry.Bs    [3x6]   - The i'th column is the unit vector of strut i expressed in {B}
%        - struts_F.l     [6x1]   - Length of the Fixed part of the i'th strut
%        - struts_M.l     [6x1]   - Length of the Mobile part of the i'th strut
%        - platform_F.FRa [3x3x6] - The i'th 3x3 array is the rotation matrix to orientate the bottom of the i'th strut from {F}
%        - platform_M.MRb [3x3x6] - The i'th 3x3 array is the rotation matrix to orientate the top of the i'th strut from {M}

arguments
    stewart
    args.AP  (3,1) double {mustBeNumeric} = zeros(3,1)
    args.ARB (3,3) double {mustBeNumeric} = eye(3)
end

assert(isfield(stewart.platform_F, 'Fa'),   'stewart.platform_F should have attribute Fa')
Fa = stewart.platform_F.Fa;

assert(isfield(stewart.platform_M, 'Mb'),   'stewart.platform_M should have attribute Mb')
Mb = stewart.platform_M.Mb;

assert(isfield(stewart.platform_F, 'FO_A'), 'stewart.platform_F should have attribute FO_A')
FO_A = stewart.platform_F.FO_A;

assert(isfield(stewart.platform_M, 'MO_B'), 'stewart.platform_M should have attribute MO_B')
MO_B = stewart.platform_M.MO_B;

assert(isfield(stewart.geometry,   'FO_M'), 'stewart.geometry should have attribute FO_M')
FO_M = stewart.geometry.FO_M;

Aa = Fa - repmat(FO_A, [1, 6]);
Bb = Mb - repmat(MO_B, [1, 6]);

Ab = Bb - repmat(-MO_B-FO_M+FO_A, [1, 6]);
Ba = Aa - repmat( MO_B+FO_M-FO_A, [1, 6]);

Ab = args.ARB *(Bb - repmat(-args.AP, [1, 6]));
Ba = args.ARB'*(Aa - repmat( args.AP, [1, 6]));

As = (Ab - Aa)./vecnorm(Ab - Aa); % As_i is the i'th vector of As

l = vecnorm(Ab - Aa)';

Bs = (Bb - Ba)./vecnorm(Bb - Ba);

FRa = zeros(3,3,6);
MRb = zeros(3,3,6);

for i = 1:6
  FRa(:,:,i) = [cross([0;1;0], As(:,i)) , cross(As(:,i), cross([0;1;0], As(:,i))) , As(:,i)];
  FRa(:,:,i) = FRa(:,:,i)./vecnorm(FRa(:,:,i));

  MRb(:,:,i) = [cross([0;1;0], Bs(:,i)) , cross(Bs(:,i), cross([0;1;0], Bs(:,i))) , Bs(:,i)];
  MRb(:,:,i) = MRb(:,:,i)./vecnorm(MRb(:,:,i));
end

stewart.geometry.Aa = Aa;
stewart.geometry.Ab = Ab;
stewart.geometry.Ba = Ba;
stewart.geometry.Bb = Bb;
stewart.geometry.As = As;
stewart.geometry.Bs = Bs;
stewart.geometry.l  = l;

stewart.struts_F.l  = l/2;
stewart.struts_M.l  = l/2;

stewart.platform_F.FRa = FRa;
stewart.platform_M.MRb = MRb;
