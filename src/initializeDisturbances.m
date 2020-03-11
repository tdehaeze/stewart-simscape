function [disturbances] = initializeDisturbances(args)
% initializeDisturbances - Initialize the disturbances
%
% Syntax: [disturbances] = initializeDisturbances(args)
%
% Inputs:
%    - args -

arguments
  args.Fd     double  {mustBeNumeric, mustBeReal} = zeros(6,1)
  args.Fd_t   double  {mustBeNumeric, mustBeReal} = 0
  args.Dw     double  {mustBeNumeric, mustBeReal} = zeros(6,1)
  args.Dw_t   double  {mustBeNumeric, mustBeReal} = 0
end

disturbances = struct();

disturbances.Dw = timeseries([args.Dw], args.Dw_t);

disturbances.Fd = timeseries([args.Fd], args.Fd_t);
