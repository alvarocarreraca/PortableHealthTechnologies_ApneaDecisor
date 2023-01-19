close all; clear all; clc
%% Obtain the recordings (input)
cdir = fileparts(mfilename('fullpath'));
% Nomral breathing input.
normalFile = fullfile(cdir,'recordings/10-normal.m4a');
[y_normal,Fs_normal] = audioread(normalFile);
% Snor input.
snorFile = fullfile(cdir,'recordings/10-snor.m4a');
[y_snor,Fs_snor] = audioread(snorFile);
% Apnea input.
apneaFile = fullfile(cdir,'recordings/10-apnea.m4a');
[y_apnea,Fs_apnea] = audioread(apneaFile);
% The frequency sampling must be the same.
if (Fs_normal == Fs_snor && Fs_snor == Fs_apnea)
    Fs = Fs_apnea;
else
    Fs = 0;
end
f_down = 8000;
y = y_normal;
%y = y_snor;
%y = y_apnea;
[t_down, y_down] = noiseFilter(Fs, f_down, y);

%% Filtering
% % Plot of the 3 inputs.
% t_normal =(0:length(y_normal)-1)/Fs;
% t_snor =(0:length(y_snor)-1)/Fs;
% t_apnea =(0:length(y_apnea)-1)/Fs;
% figure;
% plot(t_normal,y_normal,'b');
% hold on;
% plot(t_snor,y_snor,'r');
% plot(t_apnea,y_apnea,'k');
% xlim([0 122]);
% legend('Normal','Snor','Apnea');
% 
% 
% 
% % Down-sampling.
% f_4KHz = 4000;
% f_16KHz = 16000;
% [t_normal_4K, y_normal_4K] = downSample(Fs, f_4KHz, t_normal, y_normal);
% [t_normal_16K, y_normal_16K] = downSample(Fs, f_16KHz, t_normal, y_normal);
% [t_snor_4K, y_snor_4K] = downSample(Fs, f_4KHz, t_snor, y_snor);
% [t_snor_16K, y_snor_16K] = downSample(Fs, f_16KHz, t_snor, y_snor);
% [t_apnea_4K, y_apnea_4K] = downSample(Fs, f_4KHz, t_apnea, y_apnea);
% [t_apnea_16K, y_apnea_16K] = downSample(Fs, f_16KHz, t_apnea, y_apnea);
% 
% figure;
% subplot(1,3,1);
% plot(t_normal,y_normal,'g');
% hold on;
% plot(t_normal_4K,y_normal_4K,'r');
% plot(t_normal_16K,y_normal_16K,'k');
% legend('Orignial','4 KHz','16 KHz');
% title('Normal');
% xlim([20.5 20.505]);
% subplot(1,3,2);
% plot(t_snor,y_snor,'g');
% hold on;
% plot(t_snor_4K,y_snor_4K,'r');
% plot(t_snor_16K,y_snor_16K,'k');
% legend('Orignial','4 KHz','16 KHz');
% title('Snor');
% xlim([20.5 20.505]);
% subplot(1,3,3);
% plot(t_apnea,y_apnea,'g');
% hold on;
% plot(t_apnea_4K,y_apnea_4K,'r');
% plot(t_apnea_16K,y_apnea_16K,'k');
% legend('Orignial','4 KHz','16 KHz');
% title('Apnea');
% xlim([20.5 20.505]);
% 
% %% Frequency analysis:
% % Normal breathing.
% [freq_axis_normal, freq_normal] = frequencyDomain(Fs,y_normal);
% [freq_axis_normal_4K, freq_normal_4K] = frequencyDomain(f_4KHz,y_normal_4K);
% [freq_axis_normal_16K, freq_normal_16K] = frequencyDomain(f_16KHz,y_normal_16K);
% % Snor.
% [freq_axis_snor, freq_snor] = frequencyDomain(Fs,y_snor);
% [freq_axis_snor_4K, freq_snor_4K] = frequencyDomain(f_4KHz,y_snor_4K);
% [freq_axis_snor_16K, freq_snor_16K] = frequencyDomain(f_16KHz,y_snor_16K);
% % Apnea.
% [freq_axis_apnea, freq_apnea] = frequencyDomain(Fs,y_apnea);
% [freq_axis_apnea_4K, freq_apnea_4K] = frequencyDomain(f_4KHz,y_apnea_4K);
% [freq_axis_apnea_16K, freq_apnea_16K] = frequencyDomain(f_16KHz,y_apnea_16K);
% 
% figure;
% plot(freq_axis_normal,freq_normal,'g');
% hold on;
% plot(freq_axis_normal_4K,freq_normal_4K,'b');
% plot(freq_axis_normal_16K,freq_normal_16K,'r');
% xlim([0 400]);
% title('Normal');
% legend('Original','4KHz','16KHz');
% 
% figure;
% plot(freq_axis_snor,freq_snor,'g');
% hold on;
% plot(freq_axis_snor_4K,freq_snor_4K,'b');
% plot(freq_axis_snor_16K,freq_snor_16K,'r');
% xlim([0 1500]);
% title('Snor');
% legend('Original','4KHz','16KHz');
% 
% figure;
% plot(freq_axis_apnea,freq_apnea,'g');
% hold on;
% plot(freq_axis_apnea_4K,freq_apnea_4K,'b');
% plot(freq_axis_apnea_16K,freq_apnea_16K,'r');
% xlim([0 400]);
% title('Apnea');
% legend('Original','4KHz','16KHz');
% 
% 
% x_min = 0;
% x_max = 320;
% y_min = 0;
% y_max = 0.8;
% 
% figure;
% subplot(3,3,1);
% plot(freq_axis_normal,freq_normal);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,2);
% plot(freq_axis_snor,freq_snor);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,3);
% plot(freq_axis_apnea,freq_apnea);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,4);
% plot(freq_axis_normal_16K,freq_normal_16K);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,5);
% plot(freq_axis_snor_16K,freq_snor_16K);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,6);
% plot(freq_axis_apnea_16K,freq_apnea_16K);
% xlim([x_min x_max]);
% ylim([y_min y_max]);
% subplot(3,3,7);
% plot(freq_axis_normal_4K,freq_normal_4K);
% xlim([x_min x_max]);
% ylim([y_min 0.25]);
% subplot(3,3,8);
% plot(freq_axis_snor_4K,freq_snor_4K);
% xlim([x_min x_max]);
% ylim([y_min 0.25]);
% subplot(3,3,9);
% plot(freq_axis_apnea_4K,freq_apnea_4K);
% xlim([x_min x_max]);
% ylim([y_min 0.25]);
% 
% 
% 
% 
% % 
% % figure;
% % plot(freq_axis_normal_4K,freq_normal_4K,'g');
% % hold on;
% % plot(freq_axis_snor_4K,freq_snor_4K,'b');
% % plot(freq_axis_apnea_4K,freq_apnea_4K,'r');
% % xlim([0 200]);
% % ylim([0 0.25]);
% % 
% % legend('Normal','Snor','Apnea');