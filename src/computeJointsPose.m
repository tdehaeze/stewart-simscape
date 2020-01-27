function [stewart] = computeJointsPose(stewart)
% computeJointsPose -
%
% Syntax: [stewart] = computeJointsPose(stewart)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - Fa   [3x6] - Its i'th column is the position vector of joint ai with respect to {F}
%        - Mb   [3x6] - Its i'th column is the position vector of joint bi with respect to {M}
%        - FO_A [3x1] - Position of {A} with respect to {F}
%        - MO_B [3x1] - Position of {B} with respect to {M}
%        - FO_M [3x1] - Position of {M} with respect to {F}
%
% Outputs:
%    - stewart - A structure with the following added fields
%        - Aa  [3x6]   - The i'th column is the position of ai with respect to {A}
%        - Ab  [3x6]   - The i'th column is the position of bi with respect to {A}
%        - Ba  [3x6]   - The i'th column is the position of ai with respect to {B}
%        - Bb  [3x6]   - The i'th column is the position of bi with respect to {B}
%        - l   [6x1]   - The i'th element is the initial length of strut i
%        - As  [3x6]   - The i'th column is the unit vector of strut i expressed in {A}
%        - Bs  [3x6]   - The i'th column is the unit vector of strut i expressed in {B}
%        - FRa [3x3x6] - The i'th 3x3 array is the rotation matrix to orientate the bottom of the i'th strut from {F}
%        - MRb [3x3x6] - The i'th 3x3 array is the rotation matrix to orientate the top of the i'th strut from {M}

stewart.Aa = stewart.Fa - repmat(stewart.FO_A, [1, 6]);
stewart.Bb = stewart.Mb - repmat(stewart.MO_B, [1, 6]);

stewart.Ab = stewart.Bb - repmat(-stewart.MO_B-stewart.FO_M+stewart.FO_A, [1, 6]);
stewart.Ba = stewart.Aa - repmat( stewart.MO_B+stewart.FO_M-stewart.FO_A, [1, 6]);

stewart.As = (stewart.Ab - stewart.Aa)./vecnorm(stewart.Ab - stewart.Aa); % As_i is the i'th vector of As

stewart.l = vecnorm(stewart.Ab - stewart.Aa)';

stewart.Bs = (stewart.Bb - stewart.Ba)./vecnorm(stewart.Bb - stewart.Ba);

stewart.FRa = zeros(3,3,6);
stewart.MRb = zeros(3,3,6);

for i = 1:6
  stewart.FRa(:,:,i) = [cross([0;1;0], stewart.As(:,i)) , cross(stewart.As(:,i), cross([0;1;0], stewart.As(:,i))) , stewart.As(:,i)];
  stewart.FRa(:,:,i) = stewart.FRa(:,:,i)./vecnorm(stewart.FRa(:,:,i));

  stewart.MRb(:,:,i) = [cross([0;1;0], stewart.Bs(:,i)) , cross(stewart.Bs(:,i), cross([0;1;0], stewart.Bs(:,i))) , stewart.Bs(:,i)];
  stewart.MRb(:,:,i) = stewart.MRb(:,:,i)./vecnorm(stewart.MRb(:,:,i));
end
