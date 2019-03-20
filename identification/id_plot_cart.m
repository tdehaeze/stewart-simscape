%%
clear; close all; clc;

%% Load the transfer functions
load('./mat/G.mat', 'G_light_vc', 'G_light_pz', 'G_heavy_vc', 'G_heavy_pz');

%% Load Configuration file
load('./mat/config.mat', 'save_fig', 'freqs');

%% Plant in the X direction
figure;
% Amplitude
ax1 = subaxis(2,1,1);
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_cart('Dx', 'Fx'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_cart('Dx', 'Fx'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_heavy_vc.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_heavy_pz.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--');
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
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_vc.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_pz.G_cart('Dx', 'Fx'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca,'xscale','log');
yticks(-180:90:180);
ylim([-180 180]);
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
legend('Location', 'southwest');
hold off;

linkaxes([ax1,ax2],'x');

if save_fig; exportFig('G_hori', 'normal-normal', struct('path', 'identification')); end

%% Plant in the Z direction
figure;
% Amplitude
ax1 = subaxis(2,1,1);
hold on;
plot(freqs, abs(squeeze(freqresp(G_light_vc.G_cart('Dz', 'Fz'), freqs, 'Hz'))));
plot(freqs, abs(squeeze(freqresp(G_light_pz.G_cart('Dz', 'Fz'), freqs, 'Hz'))));
set(gca,'ColorOrderIndex',1);
plot(freqs, abs(squeeze(freqresp(G_heavy_vc.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--');
plot(freqs, abs(squeeze(freqresp(G_heavy_pz.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--');
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
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_vc.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--', 'DisplayName', 'VC - Heavy');
plot(freqs, 180/pi*angle(squeeze(freqresp(G_heavy_pz.G_cart('Dz', 'Fz'), freqs, 'Hz'))), '--', 'DisplayName', 'PZ - Heavy');
set(gca,'xscale','log');
yticks(-180:90:180);
ylim([-180 180]);
xlabel('Frequency [Hz]'); ylabel('Phase [deg]');
legend('Location', 'southwest');
hold off;

linkaxes([ax1,ax2],'x');

if save_fig; exportFig('G_vert', 'normal-normal', struct('path', 'identification')); end

%% Coupling
figure;

for i_input = 1:3
    for i_output = 1:3
        subaxis(3,3,3*(i_input-1)+i_output);
        hold on;
        plot(freqs, abs(squeeze(freqresp(G_light_vc.G_cart(i_output, i_input), freqs, 'Hz'))));
        plot(freqs, abs(squeeze(freqresp(G_light_pz.G_cart(i_output, i_input), freqs, 'Hz'))));
        set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
        xlim([freqs(1) freqs(end)]); ylim([1e-22, 1e-2]);
        yticks([1e-20, 1e-15, 1e-10, 1e-5]); xticks([0.1 1 10 100 1000]);
        if i_output > 1; set(gca,'yticklabel',[]); end
        if i_input < 3; set(gca,'xticklabel',[]); end
        hold off;
    end
end

if save_fig; exportFig('G_coupling', 'wide-tall', struct('path', 'identification')); end
