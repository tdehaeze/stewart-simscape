function [stewart] = initializeJointDynamics(stewart, args)
% initializeJointDynamics - Add Stiffness and Damping properties for the spherical joints
%
% Syntax: [stewart] = initializeJointDynamics(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - type_F - 'universal', 'spherical', 'universal_p', 'spherical_p'
%        - type_M - 'universal', 'spherical', 'universal_p', 'spherical_p'
%        - Kf_M [6x1] - Bending (Rx, Ry) Stiffness for each top joints [(N.m)/rad]
%        - Kt_M [6x1] - Torsion (Rz) Stiffness for each top joints [(N.m)/rad]
%        - Cf_M [6x1] - Bending (Rx, Ry) Damping of each top joint [(N.m)/(rad/s)]
%        - Ct_M [6x1] - Torsion (Rz) Damping of each top joint [(N.m)/(rad/s)]
%        - Kf_F [6x1] - Bending (Rx, Ry) Stiffness for each bottom joints [(N.m)/rad]
%        - Kt_F [6x1] - Torsion (Rz) Stiffness for each bottom joints [(N.m)/rad]
%        - Cf_F [6x1] - Bending (Rx, Ry) Damping of each bottom joint [(N.m)/(rad/s)]
%        - Cf_F [6x1] - Torsion (Rz) Damping of each bottom joint [(N.m)/(rad/s)]
%
% Outputs:
%    - stewart - updated Stewart structure with the added fields:
%      - stewart.joints_F and stewart.joints_M:
%        - type - 1 (universal), 2 (spherical), 3 (universal perfect), 4 (spherical perfect)
%        - Kx, Ky, Kz [6x1] - Translation (Tx, Ty, Tz) Stiffness [N/m]
%        - Kf [6x1] - Flexion (Rx, Ry) Stiffness [(N.m)/rad]
%        - Kt [6x1] - Torsion (Rz) Stiffness [(N.m)/rad]
%        - Cx, Cy, Cz [6x1] - Translation (Rx, Ry) Damping [N/(m/s)]
%        - Cf [6x1] - Flexion (Rx, Ry) Damping [(N.m)/(rad/s)]
%        - Cb [6x1] - Torsion (Rz) Damping [(N.m)/(rad/s)]

arguments
    stewart
    args.type_F     char   {mustBeMember(args.type_F,{'universal', 'spherical', 'universal_p', 'spherical_p', 'flexible'})} = 'universal'
    args.type_M     char   {mustBeMember(args.type_M,{'universal', 'spherical', 'universal_p', 'spherical_p', 'flexible'})} = 'spherical'
    args.Kf_M (6,1) double {mustBeNumeric, mustBeNonnegative} = 15*ones(6,1)
    args.Cf_M (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-4*ones(6,1)
    args.Kt_M (6,1) double {mustBeNumeric, mustBeNonnegative} = 20*ones(6,1)
    args.Ct_M (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-3*ones(6,1)
    args.Kf_F (6,1) double {mustBeNumeric, mustBeNonnegative} = 15*ones(6,1)
    args.Cf_F (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-4*ones(6,1)
    args.Kt_F (6,1) double {mustBeNumeric, mustBeNonnegative} = 20*ones(6,1)
    args.Ct_F (6,1) double {mustBeNumeric, mustBeNonnegative} = 1e-3*ones(6,1)
    args.K_M        double {mustBeNumeric} = zeros(6,6)
    args.M_M        double {mustBeNumeric} = zeros(6,6)
    args.n_xyz_M    double {mustBeNumeric} = zeros(2,3)
    args.xi_M       double {mustBeNumeric} = 0.1
    args.step_file_M char {} = ''
    args.K_F        double {mustBeNumeric} = zeros(6,6)
    args.M_F        double {mustBeNumeric} = zeros(6,6)
    args.n_xyz_F    double {mustBeNumeric} = zeros(2,3)
    args.xi_F       double {mustBeNumeric} = 0.1
    args.step_file_F char {} = ''
end

switch args.type_F
  case 'universal'
    stewart.joints_F.type = 1;
  case 'spherical'
    stewart.joints_F.type = 2;
  case 'universal_p'
    stewart.joints_F.type = 3;
  case 'spherical_p'
    stewart.joints_F.type = 4;
  case 'flexible'
    stewart.joints_F.type = 5;
end

switch args.type_M
  case 'universal'
    stewart.joints_M.type = 1;
  case 'spherical'
    stewart.joints_M.type = 2;
  case 'universal_p'
    stewart.joints_M.type = 3;
  case 'spherical_p'
    stewart.joints_M.type = 4;
  case 'flexible'
    stewart.joints_M.type = 5;
end

stewart.joints_M.Kx = zeros(6,1);
stewart.joints_M.Ky = zeros(6,1);
stewart.joints_M.Kz = zeros(6,1);

stewart.joints_F.Kx = zeros(6,1);
stewart.joints_F.Ky = zeros(6,1);
stewart.joints_F.Kz = zeros(6,1);

stewart.joints_M.Cx = zeros(6,1);
stewart.joints_M.Cy = zeros(6,1);
stewart.joints_M.Cz = zeros(6,1);

stewart.joints_F.Cx = zeros(6,1);
stewart.joints_F.Cy = zeros(6,1);
stewart.joints_F.Cz = zeros(6,1);

stewart.joints_M.Kf = args.Kf_M;
stewart.joints_M.Kt = args.Kf_M;

stewart.joints_F.Kf = args.Kf_F;
stewart.joints_F.Kt = args.Kf_F;

stewart.joints_M.Cf = args.Cf_M;
stewart.joints_M.Ct = args.Cf_M;

stewart.joints_F.Cf = args.Cf_F;
stewart.joints_F.Ct = args.Cf_F;

stewart.joints_F.M = args.M_F;
stewart.joints_F.K = args.K_F;
stewart.joints_F.n_xyz = args.n_xyz_F;
stewart.joints_F.xi = args.xi_F;
stewart.joints_F.xi = args.xi_F;
stewart.joints_F.step_file = args.step_file_F;

stewart.joints_M.M = args.M_M;
stewart.joints_M.K = args.K_M;
stewart.joints_M.n_xyz = args.n_xyz_M;
stewart.joints_M.xi = args.xi_M;
stewart.joints_M.step_file = args.step_file_M;
