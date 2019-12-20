function [stewart] = generateCubicConfiguration(stewart, opts_param)
% generateCubicConfiguration -
%
% Syntax: [stewart] = generateCubicConfiguration(stewart, opts_param)
%
% Inputs:
%    - stewart - the Stewart struct should have a parameter "H" corresponding to the total height of the platform
%    - opts_param - Structure with the following parameters
%        - Hc  [1x1] - Height of the "useful" part of the cube [m]
%        - FOc [1x1] - Height of the center of the cute with respect to {F} [m]
%        - FHa [1x1] - Height of the plane joining the points ai with respect to the frame {F} [m]
%        - MHb [1x1] - Height of the plane joining the points bi with respect to the frame {M} [m]
%
% Outputs:
%    - stewart - updated Stewart structure with the added parameters:
%        - Fa [3x6] - Its i'th column is the position vector of joint ai with respect to {F}
%        - Mb [3x6] - Its i'th column is the position vector of joint bi with respect to {M}

opts = struct(  ...
  'Hc',  60e-3, ... % [m]
  'FOc', 50e-3, ... % [m]
  'FHa', 15e-3, ... % [m]
  'MHb', 15e-3  ... % [m]
  );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

sx = [ 2; -1; -1];
sy = [ 0;  1; -1];
sz = [ 1;  1;  1];

R = [sx, sy, sz]./vecnorm([sx, sy, sz]);

L = opts.Hc*sqrt(3);

Cc = R'*[[0;0;L],[L;0;L],[L;0;0],[L;L;0],[0;L;0],[0;L;L]] - [0;0;1.5*opts.Hc];

CCf = [Cc(:,1), Cc(:,3), Cc(:,3), Cc(:,5), Cc(:,5), Cc(:,1)]; % CCf(:,i) corresponds to the bottom cube's vertice corresponding to the i'th leg
CCm = [Cc(:,2), Cc(:,2), Cc(:,4), Cc(:,4), Cc(:,6), Cc(:,6)]; % CCm(:,i) corresponds to the top cube's vertice corresponding to the i'th leg

CSi = (CCm - CCf)./vecnorm(CCm - CCf);

stewart.Fa = CCf + [0; 0; opts.FOc] + ((opts.FHa-(opts.FOc-opts.Hc/2))./CSi(3,:)).*CSi;
stewart.Mb = CCf + [0; 0; opts.FOc-stewart.H] + ((stewart.H-opts.MHb-(opts.FOc-opts.Hc/2))./CSi(3,:)).*CSi;
