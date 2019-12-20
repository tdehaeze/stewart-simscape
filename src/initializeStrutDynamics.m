function [stewart] = initializeStrutDynamics(stewart, opts_param)
% initializeStrutDynamics - Add Stiffness and Damping properties of each strut
%
% Syntax: [stewart] = initializeStrutDynamics(opts_param)
%
% Inputs:
%    - opts_param - Structure with the following fields:
%        - Ki [6x1] - Stiffness of each strut [N/m]
%        - Ci [6x1] - Damping of each strut [N/(m/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Ki [6x1] - Stiffness of each strut [N/m]
%        - Ci [6x1] - Damping of each strut [N/(m/s)]

opts = struct(  ...
  'Ki', 1e6*ones(6,1), ... % [N/m]
  'Ci', 1e2*ones(6,1)  ... % [N/(m/s)]
  );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

stewart.Ki = opts.Ki;
stewart.Ci = opts.Ci;
