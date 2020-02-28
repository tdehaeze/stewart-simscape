function [T, T_norm, freqs] = computeTransmissibility(args)
% computeTransmissibility -
%
% Syntax: [T, T_norm, freqs] = computeTransmissibility(args)
%
% Inputs:
%    - args - Structure with the following fields:
%        - plots [true/false] - Should plot the transmissilibty matrix and its Frobenius norm
%        - freqs [] - Frequency vector to estimate the Frobenius norm
%
% Outputs:
%    - T      [6x6 ss] - Transmissibility matrix
%    - T_norm [length(freqs)x1] - Frobenius norm of the Transmissibility matrix
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
io(io_i) = linio([mdl, '/Disturbances/D_w'],        1, 'openinput');  io_i = io_i + 1; % Base Motion [m, rad]
io(io_i) = linio([mdl, '/Absolute Motion Sensor'],  1, 'output'); io_i = io_i + 1; % Absolute Motion [m, rad]

%% Run the linearization
T = linearize(mdl, io, options);
T.InputName = {'Wdx', 'Wdy', 'Wdz', 'Wrx', 'Wry', 'Wrz'};
T.OutputName = {'Edx', 'Edy', 'Edz', 'Erx', 'Ery', 'Erz'};

p_handle = zeros(6*6,1);

if args.plots
  fig = figure;
  for ix = 1:6
    for iy = 1:6
      p_handle((ix-1)*6 + iy) = subplot(6, 6, (ix-1)*6 + iy);
      hold on;
      plot(freqs, abs(squeeze(freqresp(T(ix, iy), freqs, 'Hz'))), 'k-');
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
  ylim([1e-5, 1e2]);

  han = axes(fig, 'visible', 'off');
  han.XLabel.Visible = 'on';
  han.YLabel.Visible = 'on';
  xlabel(han, 'Frequency [Hz]');
  ylabel(han, 'Transmissibility [m/m]');
end

T_norm = zeros(length(freqs), 1);

for i = 1:length(freqs)
  T_norm(i) = sqrt(trace(freqresp(T, freqs(i), 'Hz')*freqresp(T, freqs(i), 'Hz')'));
end

T_norm = T_norm/sqrt(6);

if args.plots
  figure;
  plot(freqs, T_norm)
  set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
  xlabel('Frequency [Hz]');
  ylabel('Transmissibility - Frobenius Norm');
end
