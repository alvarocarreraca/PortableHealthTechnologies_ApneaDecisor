close all; 
clear all; clc
%% Description:
% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Main code to obtain all the attributes of a fragment of 45 seconds.
% 4 of the attributes are from the time domain and 6 from the frequency
% domain.
%% Obtain the recordings (input)
cdir = fileparts(mfilename('fullpath'));
% Nomral breathing input.
file = fullfile(cdir,'recordings/10 apnea.m4a');
[y,Fs] = audioread(file);
%% INPUTS:
f_down = 8000; % Frequency sampling that will be used
fragment_origin = 10; % second where it will be set the origin of the 45 sec. fragment
fragment_size = 45; % 45 seg
windowSize = 0.06; % 60 ms
max_VLF = 200; % 200 Hz
max_LF = 600; % 600 Hz

%% Filtering (Low-pass filter + Downsample)
t =(0:length(y)-1)/Fs;
% Take a fragment of the sample:
ind_inf = find(t <= fragment_origin);
ind_sup = find(t > (fragment_origin + fragment_size),1);
y_frag = y(ind_inf(end):ind_sup-1);
t_frag = t(ind_inf(end):ind_sup-1);
% Filtering:
[y_down,t_down] = resample(y_frag,t_frag,f_down); % Lowpass filter + downsampling
plot(t_frag,y_frag)
hold on
plot(t_down,y_down)
xlim([37.5 37.505])
legend('44.1 kHz','8 kHz')
[energy,t_energy] = EventDetector(y_down,f_down,windowSize); % method to obtain the energy of a 60 ms window
peaks = countPeaks(energy,t_energy); % method to count the peaks that are above a fixed threshold under certain conditions
% Frequency domain:
[freq_axis, freq] = frequencyDomain(f_down,y_down); % method that returns fft
% Positive frequency values:
f_index = find(freq_axis <= 0);
positive_frequency_axis = freq_axis(f_index(end):end); 
positive_freq = freq(f_index(end):end);
% VLF - Record from 0 to max_VLF:
VLF_f_index = find(positive_frequency_axis <= max_VLF);
VLF_frequency_axis = positive_frequency_axis(1:length(VLF_f_index));
VLF_freq = positive_freq(1:length(VLF_f_index));
% LF - Record from max_VLF to max_LF:
LF_f_index = find(positive_frequency_axis > max_VLF & positive_frequency_axis <= max_LF);
LF_frequency_axis = positive_frequency_axis(LF_f_index(1):LF_f_index(length(LF_f_index)));
LF_freq = positive_freq(LF_f_index(1):LF_f_index(length(LF_f_index)));
% HF - Record from max_LF to 4000:
HF_f_index = find(positive_frequency_axis <= max_LF);
HF_frequency_axis = positive_frequency_axis(HF_f_index(end):end);
HF_freq = positive_freq(HF_f_index(end):end);
% Power above 500 Hz:
f_500Hz_index = find(positive_frequency_axis <= 500);
f_500Hz_axis = positive_frequency_axis(f_500Hz_index(end):end);
f_500Hz = positive_freq(f_500Hz_index(end):end);
power_above_500 = sum(f_500Hz);
% Power between 0 - 120 Hz:
f_120Hz_index = find(positive_frequency_axis <= 120);
f_120Hz_axis = positive_frequency_axis(1:length(f_120Hz_index));
f_120Hz = positive_freq(1:length(f_120Hz_index));
p_0_120_Hz = sum(f_120Hz);
% Power between 120 - 400 Hz:
f_400Hz_index = find(positive_frequency_axis > 120 & positive_frequency_axis <= 400);
f_400Hz_axis = positive_frequency_axis(f_400Hz_index(1):f_400Hz_index(length(f_400Hz_index)));
f_400Hz = positive_freq(f_400Hz_index(1):f_400Hz_index(length(f_400Hz_index)));
p_120_400_Hz = sum(f_400Hz);

%% Results:
% (1) Mean of the absolut window:
mean_abs_1 = sum(abs(y_down))/length(y_down);
% (2) Standard deviation of the original input:
std_2 = std(y_down);
% (3) Energy mean:
energy_mean_3 = sum(energy)/length(energy);
% (4) Number of peaks:
num_peak_4 = peaks;
% (5) Power Spectrum Density:
PSD_5 = sum(positive_freq);
% (6) Very Low Frequency power Normalization:
VLF_power_6 = sum(VLF_freq);
% (7) Low Frequency power Normalization:
LF_power_norm_7 = sum(LF_freq)/(PSD_5 - VLF_power_6);
% (8) High Frequency power:
HF_power_norm_8 = sum(HF_freq)/(PSD_5 - VLF_power_6);
% (9) Ratio Power(120-400Hz)/Power(0-120Hz):
ratio_9 = p_120_400_Hz/p_0_120_Hz;
% (10) Power above 500 Hz:
ratio_500Hz_10 = power_above_500/PSD_5;

% Print the sample attributes:
sample = mean_abs_1+","+std_2+","+energy_mean_3+","+num_peak_4+","+PSD_5+","+VLF_power_6+","+LF_power_norm_7+","+HF_power_norm_8+","+ratio_9+","+ratio_500Hz_10
%% PLOTS:
%Plot of the spectogram:
figure;
spectrogram(y_down,0.5*f_down,0.1*f_down,0:f_down/2-1,f_down,'yaxis')

% Time domain:
figure;
subplot(3,2,1);
plot(t_down,y_down); % Original
subplot(3,2,2);
plot(t_down,abs(y_down)); % Absolut value
subplot(3,2,3);
plot(t_down,abs(y_down)/max(abs(y_down))); % Normalized
subplot(3,2,4);
plot(t_energy,energy); % energy
hold on;
yline(2*mean(energy));
% Frequency domain:
subplot(3,2,5);
plot(positive_frequency_axis,positive_freq)
xlim([0,400]);
subplot(3,2,6);
plot(positive_frequency_axis,positive_freq/max(positive_freq)) % Normalized
xlim([0,400]);
