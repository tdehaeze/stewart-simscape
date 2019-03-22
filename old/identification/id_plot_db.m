%%
clear; close all; clc;

%% Load the transfer functions
load('./mat/G.mat', 'G_light_vc', 'G_light_pz', 'G_heavy_vc', 'G_heavy_pz');

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%%
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_db('Dx', 'Dbx'), freqs, 'Hz'))), 'DisplayName', 'VC - Light');
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_db('Dx', 'Dbx'), freqs, 'Hz'))), 'DisplayName', 'PZ - Light');
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_heavy_vc.G_db('Dx', 'Dbx'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, abs(squeeze(freqresp(G_heavy_pz.G_db('Dx', 'Dbx'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/m]'); xlabel('Frequency [Hz]');
hold off;
legend('Location', 'southeast');

if save_fig; exportFig('G_db_hori', 'normal-normal', struct('path', 'identification')); end

%%
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_db('Dz', 'Dbz'), freqs, 'Hz'))), 'DisplayName', 'VC - Light');
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_db('Dz', 'Dbz'), freqs, 'Hz'))), 'DisplayName', 'PZ - Light');
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_heavy_vc.G_db('Dz', 'Dbz'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, abs(squeeze(freqresp(G_heavy_pz.G_db('Dz', 'Dbz'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
ylabel('Amplitude [m/m]'); xlabel('Frequency [Hz]');
hold off;
legend('Location', 'southeast');

if save_fig; exportFig('G_db_vert', 'normal-normal', struct('path', 'identification')); end

%%
