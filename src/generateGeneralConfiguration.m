function [stewart] = generateGeneralConfiguration(stewart, args)
% generateGeneralConfiguration - Generate a Very General Configuration
%
% Syntax: [stewart] = generateGeneralConfiguration(stewart, args)
%
% Inputs:
%    - stewart - A structure with the following fields
%        - H   [1x1] - Total height of the platform [m]
%    - args - Can have the following fields:
%        - FH  [1x1] - Height of the position of the fixed joints with respect to the frame {F} [m]
%        - FR  [1x1] - Radius of the position of the fixed joints in the X-Y [m]
%        - FTh [6x1] - Angles of the fixed joints in the X-Y plane with respect to the X axis [rad]
%        - MH  [1x1] - Height of the position of the mobile joints with respect to the frame {M} [m]
%        - FR  [1x1] - Radius of the position of the mobile joints in the X-Y [m]
%        - MTh [6x1] - Angles of the mobile joints in the X-Y plane with respect to the X axis [rad]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%        - Fa  [3x6] - Its i'th column is the position vector of joint ai with respect to {F}
%        - Mb  [3x6] - Its i'th column is the position vector of joint bi with respect to {M}

arguments
    stewart
    args.FH  (1,1) double {mustBeNumeric, mustBePositive} = 15e-3
    args.FR  (1,1) double {mustBeNumeric, mustBePositive} = 90e-3;
    args.FTh (6,1) double {mustBeNumeric} = [-10, 10, 120-10, 120+10, 240-10, 240+10]*(pi/180);
    args.MH  (1,1) double {mustBeNumeric, mustBePositive} = 15e-3
    args.MR  (1,1) double {mustBeNumeric, mustBePositive} = 70e-3;
    args.MTh (6,1) double {mustBeNumeric} = [-60+10, 60-10, 60+10, 180-10, 180+10, -60-10]*(pi/180);
end

stewart.Fa = zeros(3,6);
stewart.Mb = zeros(3,6);

for i = 1:6
  stewart.Fa(:,i) = [args.FR*cos(args.FTh(i)); args.FR*sin(args.FTh(i)); args.FH];
  stewart.Mb(:,i) = [args.MR*cos(args.MTh(i)); args.MR*sin(args.MTh(i)); -args.MH];
end
