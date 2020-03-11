function [references] = initializeReferences(stewart, args)
% initializeReferences - Initialize the references
%
% Syntax: [references] = initializeReferences(args)
%
% Inputs:
%    - args -

arguments
  stewart
  args.t double {mustBeNumeric, mustBeReal} = 0
  args.r double {mustBeNumeric, mustBeReal} = zeros(6, 1)
end

rL = zeros(6, length(args.t));

for i = 1:length(args.t)
  R = [cos(args.r(6,i)) -sin(args.r(6,i))  0;
       sin(args.r(6,i))  cos(args.r(6,i))  0;
       0           0           1] * ...
      [cos(args.r(5,i))  0           sin(args.r(5,i));
       0           1           0;
      -sin(args.r(5,i))  0           cos(args.r(5,i))] * ...
      [1           0           0;
       0           cos(args.r(4,i)) -sin(args.r(4,i));
       0           sin(args.r(4,i))  cos(args.r(4,i))];

 [Li, dLi] = inverseKinematics(stewart, 'AP', [args.r(1,i); args.r(2,i); args.r(3,i)], 'ARB', R);
 rL(:, i) = dLi;
end

references.r  = timeseries(args.r, args.t);
references.rL = timeseries(rL, args.t);
