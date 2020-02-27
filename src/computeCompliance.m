function [C, C_norm, freqs] = computeCompliance(args)
% computeCompliance -
%
% Syntax: [C, C_norm, freqs] = computeCompliance(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - plots [true/false] - Should plot the transmissilibty matrix and its Frobenius norm
%        - freqs [] - Frequency vector to estimate the Frobenius norm
%
% Outputs:
%    - C      [6x6 ss] - Compliance matrix
%    - C_norm [length(freqs)x1] - Frobenius norm of the Compliance matrix
%    - freqs  [length(freqs)x1] - Frequency vector in [Hz]

arguments
  args.plots logical {mustBeNumericOrLogical} = false
  args.freqs double {mustBeNumeric, mustBeNonnegative} = logspace(1,4,1000)
end

freqs = args.freqs;

%% Options for Linearized
options = linearizeOptions;
options.SampleTime = 0;

%% Name of the Simulink File
mdl = 'stewart_platform_model';

%% Input/Output definition
clear io; io_i = 1;
io(io_i) = linio([mdl, '/Disturbances/F_ext'],      1, 'openinput');  io_i = io_i + 1; % External forces [N, N*m]
io(io_i) = linio([mdl, '/Absolute Motion Sensor'],  1, 'openoutput'); io_i = io_i + 1; % Absolute Motion [m, rad]

%% Run the linearization
C = linearize(mdl, io, options);
C.InputName  = {'Fdx', 'Fdy', 'Fdz', 'Mdx', 'Mdy', 'Mdz'};
C.OutputName = {'Edx', 'Edy', 'Edz', 'Erx', 'Ery', 'Erz'};

p_handle = zeros(6*6,1);

if args.plots
  fig = figure;
  for ix = 1:6
    for iy = 1:6
      p_handle((ix-1)*6 + iy) = subplot(6, 6, (ix-1)*6 + iy);
      hold on;
      plot(freqs, abs(squeeze(freqresp(C(ix, iy), freqs, 'Hz'))), 'k-');
      set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
      if ix < 6
          xticklabels({});
      end
      if iy > 1
          yticklabels({});
      end
    end
  end

  linkaxes(p_handle, 'xy')
  xlim([freqs(1), freqs(end)]);

  han = axes(fig, 'visible', 'off');
  han.XLabel.Visible = 'on';
  han.YLabel.Visible = 'on';
  xlabel(han, 'Frequency [Hz]');
  ylabel(han, 'Compliance [m/N, rad/(N*m)]');
end

freqs = args.freqs;

C_norm = zeros(length(freqs), 1);

for i = 1:length(freqs)
  C_norm(i) = sqrt(trace(freqresp(C, freqs(i), 'Hz')*freqresp(C, freqs(i), 'Hz')'));
end

if args.plots
  figure;
  plot(freqs, C_norm)
  set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
  xlabel('Frequency [Hz]');
  ylabel('Compliance - Frobenius Norm');
end
