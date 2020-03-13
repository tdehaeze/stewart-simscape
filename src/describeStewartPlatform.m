function [] = describeStewartPlatform(stewart)
% describeStewartPlatform - Display some text describing the current defined Stewart Platform
%
% Syntax: [] = describeStewartPlatform(args)
%
% Inputs:
%    - stewart
%
% Outputs:

arguments
    stewart
end

fprintf('GEOMETRY:\n')
fprintf('- The height between the fixed based and the top platform is %.3g [mm].\n', 1e3*stewart.geometry.H)

if stewart.platform_M.MO_B(3) > 0
  fprintf('- Frame {A} is located %.3g [mm] above the top platform.\n',  1e3*stewart.platform_M.MO_B(3))
else
  fprintf('- Frame {A} is located %.3g [mm] below the top platform.\n', - 1e3*stewart.platform_M.MO_B(3))
end

fprintf('- The initial length of the struts are:\n')
fprintf('\t %.3g, %.3g, %.3g, %.3g, %.3g, %.3g [mm]\n', 1e3*stewart.geometry.l)
fprintf('\n')

fprintf('ACTUATORS:\n')
if stewart.actuators.type == 1
    fprintf('- The actuators are classical.\n')
    fprintf('- The Stiffness and Damping of each actuators is:\n')
    fprintf('\t k = %.0e [N/m] \t c = %.0e [N/(m/s)]\n', stewart.actuators.K(1), stewart.actuators.C(1))
elseif stewart.actuators.type == 2
    fprintf('- The actuators are mechanicaly amplified.\n')
    fprintf('- The vertical stiffness and damping contribution of the piezoelectric stack is:\n')
    fprintf('\t ka = %.0e [N/m] \t ca = %.0e [N/(m/s)]\n', stewart.actuators.Ka(1), stewart.actuators.Ca(1))
    fprintf('- Vertical stiffness when the piezoelectric stack is removed is:\n')
    fprintf('\t kr = %.0e [N/m] \t cr = %.0e [N/(m/s)]\n', stewart.actuators.Kr(1), stewart.actuators.Cr(1))
end
fprintf('\n')

fprintf('JOINTS:\n')

switch stewart.joints_F.type
  case 1
    fprintf('- The joints on the fixed based are universal joints\n')
  case 2
    fprintf('- The joints on the fixed based are spherical joints\n')
  case 3
    fprintf('- The joints on the fixed based are perfect universal joints\n')
  case 4
    fprintf('- The joints on the fixed based are perfect spherical joints\n')
end

switch stewart.joints_M.type
  case 1
    fprintf('- The joints on the mobile based are universal joints\n')
  case 2
    fprintf('- The joints on the mobile based are spherical joints\n')
  case 3
    fprintf('- The joints on the mobile based are perfect universal joints\n')
  case 4
    fprintf('- The joints on the mobile based are perfect spherical joints\n')
end

fprintf('- The position of the joints on the fixed based with respect to {F} are (in [mm]):\n')
fprintf('\t % .3g \t % .3g \t % .3g\n', 1e3*stewart.platform_F.Fa)

fprintf('- The position of the joints on the mobile based with respect to {M} are (in [mm]):\n')
fprintf('\t % .3g \t % .3g \t % .3g\n', 1e3*stewart.platform_M.Mb)
fprintf('\n')

fprintf('KINEMATICS:\n')

if isfield(stewart.kinematics, 'K')
  fprintf('- The Stiffness matrix K is (in [N/m]):\n')
  fprintf('\t % .0e \t % .0e \t % .0e \t % .0e \t % .0e \t % .0e\n', stewart.kinematics.K)
end

if isfield(stewart.kinematics, 'C')
  fprintf('- The Damping matrix C is (in [m/N]):\n')
  fprintf('\t % .0e \t % .0e \t % .0e \t % .0e \t % .0e \t % .0e\n', stewart.kinematics.C)
end
