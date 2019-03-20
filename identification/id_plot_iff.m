%%
clear; close all; clc;

%% Load the transfer functions
load('./mat/G.mat', 'G_light_vc', 'G_light_pz', 'G_heavy_vc', 'G_heavy_pz');

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%%
figure;
% Amplitude
ax1 = subaxis(2,1,1);
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm1', 'F1'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_iff('Fm1', 'F1'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_heavy_vc.G_iff('Fm1', 'F1'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_heavy_pz.G_iff('Fm1', 'F1'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(gca, 'XTickLabel',[]);
ylabel('Amplitude [m/N]');
hold off;

% Phase
ax2 = subaxis(2,1,2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_vc.G_iff('Fm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'VC - Light');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_pz.G_iff('Fm1', 'F1'), freqs, 'Hz'))), 'DisplayName', 'PZ - Light');
set(gca,'ColorOrderIndex',1)
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_vc.G_iff('Fm1', 'F1'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_pz.G_iff('Fm1', 'F1'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca,'xscale','log');
yticks(-180:90:180);
ylim([-180 180]);
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
legend('Location', 'southwest');
hold off;

linkaxes([ax1,ax2],'x');

if save_fig; exportFig('G_iff', 'normal-normal', struct('path', 'identification')); end

%% Coupling
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm1', 'F1'), freqs, 'Hz'))), 'k-');
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm2', 'F1'), freqs, 'Hz'))), 'k--');
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm3', 'F1'), freqs, 'Hz'))), 'k--');
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm4', 'F1'), freqs, 'Hz'))), 'k--');
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm5', 'F1'), freqs, 'Hz'))), 'k--');
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_iff('Fm6', 'F1'), freqs, 'Hz'))), 'k--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/N]'); xlabel('Frequency [Hz]');
hold off;

if save_fig; exportFig('G_iff_coupling', 'normal-normal', struct('path', 'identification')); end
