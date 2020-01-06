function [stewart] = generateCubicConfiguration(stewart, args)
% generateCubicConfiguration - Generate a Cubic Configuration
%
% Syntax: [stewart] = generateCubicConfiguration(stewart, args)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - H   [1x1] - Total height of the platform [m]
%    - args - Can have the following fields:
%        - Hc  [1x1] - Height of the "useful" part of the cube [m]
%        - FOc [1x1] - Height of the center of the cube with respect to {F} [m]
%        - FHa [1x1] - Height of the plane joining the points ai with respect to the frame {F} [m]
%        - MHb [1x1] - Height of the plane joining the points bi with respect to the frame {M} [m]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Fa  [3x6] - Its i'th column is the position vector of joint ai with respect to {F}
%        - Mb  [3x6] - Its i'th column is the position vector of joint bi with respect to {M}

arguments
    stewart
    args.Hc  (1,1) double {mustBeNumeric, mustBePositive} = 60e-3
    args.FOc (1,1) double {mustBeNumeric} = 50e-3
    args.FHa (1,1) double {mustBeNumeric, mustBePositive} = 15e-3
    args.MHb (1,1) double {mustBeNumeric, mustBePositive} = 15e-3
end

sx = [ 2; -1; -1];
sy = [ 0;  1; -1];
sz = [ 1;  1;  1];

R = [sx, sy, sz]./vecnorm([sx, sy, sz]);

L = args.Hc*sqrt(3);

Cc = R'*[[0;0;L],[L;0;L],[L;0;0],[L;L;0],[0;L;0],[0;L;L]] - [0;0;1.5*args.Hc];

CCf = [Cc(:,1), Cc(:,3), Cc(:,3), Cc(:,5), Cc(:,5), Cc(:,1)]; % CCf(:,i) corresponds to the bottom cube's vertice corresponding to the i'th leg
CCm = [Cc(:,2), Cc(:,2), Cc(:,4), Cc(:,4), Cc(:,6), Cc(:,6)]; % CCm(:,i) corresponds to the top cube's vertice corresponding to the i'th leg

CSi = (CCm - CCf)./vecnorm(CCm - CCf);

stewart.Fa = CCf + [0; 0; args.FOc] + ((args.FHa-(args.FOc-args.Hc/2))./CSi(3,:)).*CSi;
stewart.Mb = CCf + [0; 0; args.FOc-stewart.H] + ((stewart.H-args.MHb-(args.FOc-args.Hc/2))./CSi(3,:)).*CSi;
