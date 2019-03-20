%%
clear; close all; clc;

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%% Load
load('./mat/G_iff.mat', 'G_light_vc_iff', 'G_light_pz_iff', 'G_heavy_vc_iff', 'G_heavy_pz_iff');
load('./mat/G.mat', 'G_light_vc', 'G_light_pz', 'G_heavy_vc', 'G_heavy_pz');

%% New Damped Plant - Horizontal Direction
figure;
% Amplitude
ax1 = subaxis(2,1,1);
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_cart('Dx', 'Fx'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_cart('Dx', 'Fx'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(gca, 'XTickLabel',[]);
ylabel('Amplitude [m/N]');
hold off;

% Phase
ax2 = subaxis(2,1,2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_vc.G_cart('Dx', 'Fx'), freqs, 'Hz'))), 'DisplayName', 'VC - Light');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_pz.G_cart('Dx', 'Fx'), freqs, 'Hz'))), 'DisplayName', 'PZ - Light');
set(gca,'ColorOrderIndex',1)
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_vc_iff.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_pz_iff.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca,'xscale','log');
yticks(-180:90:180);
ylim([-180 180]);
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
legend('Location', 'southwest');
hold off;

linkaxes([ax1,ax2],'x');

if save_fig; exportFig('G_hori_iff', 'normal-normal', struct('path', 'active_damping')); end

%% New Damped Plant - Vertical Direction
figure;
% Amplitude
ax1 = subaxis(2,1,1);
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_cart('Dz', 'Fz'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_cart('Dz', 'Fz'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(gca, 'XTickLabel',[]);
ylabel('Amplitude [m/N]');
hold off;

% Phase
ax2 = subaxis(2,1,2);
hold on;
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_vc.G_cart('Dz', 'Fz'), freqs, 'Hz'))), 'DisplayName', 'VC - Light');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_pz.G_cart('Dz', 'Fz'), freqs, 'Hz'))), 'DisplayName', 'PZ - Light');
set(gca,'ColorOrderIndex',1)
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_vc_iff.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_light_pz_iff.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca,'xscale','log');
yticks(-180:90:180);
ylim([-180 180]);
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
legend('Location', 'southwest');
hold off;

linkaxes([ax1,ax2],'x');

if save_fig; exportFig('G_vert_iff', 'normal-normal', struct('path', 'active_damping')); end

%% Ground motion Transmissibility - Horizontal Direction
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_db('Dx', 'Dbx'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_db('Dx', 'Dbx'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_db('Dx', 'Dbx'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_db('Dx', 'Dbx'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Frequency [Hz]'); ylabel('Amplitude [m/N]');
hold off;

if save_fig; exportFig('G_db_hori_iff', 'normal-normal', struct('path', 'active_damping')); end

%% Ground motion Transmissibility - Vertical Direction
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_db('Dz', 'Dbz'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_db('Dz', 'Dbz'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_db('Dz', 'Dbz'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_db('Dz', 'Dbz'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Frequency [Hz]'); ylabel('Amplitude [m/N]');
hold off;

if save_fig; exportFig('G_db_vert_iff', 'normal-normal', struct('path', 'active_damping')); end

%% Direct Forces Compliance - Horizontal Direction
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_fi('Dx', 'Fix'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_fi('Dx', 'Fix'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_fi('Dx', 'Fix'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_fi('Dx', 'Fix'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Frequency [Hz]'); ylabel('Amplitude [m/N]');
hold off;

if save_fig; exportFig('G_fi_hori_iff', 'normal-normal', struct('path', 'active_damping')); end

%% Direct Forces Compliance - Vertical Direction
figure;
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_fi('Dz', 'Fiz'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_fi('Dz', 'Fiz'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_light_vc_iff.G_fi('Dz', 'Fiz'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_light_pz_iff.G_fi('Dz', 'Fiz'), freqs, 'Hz'))), '--');
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
xlabel('Frequency [Hz]'); ylabel('Amplitude [m/N]');
hold off;

if save_fig; exportFig('G_fi_vert_iff', 'normal-normal', struct('path', 'active_damping')); end
