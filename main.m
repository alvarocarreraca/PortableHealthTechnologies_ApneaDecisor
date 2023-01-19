close all; clear all; clc
%% Obtain the recordings (input)
cdir = fileparts(mfilename('fullpath'));
% Nomral breathing input.
normalFile = fullfile(cdir,'recordings/9 normal.m4a');
[y_normal,Fs_normal] = audioread(normalFile);
% Snor input.
snorFile = fullfile(cdir,'recordings/9 snor.m4a');
[y_snor,Fs_snor] = audioread(snorFile);
% Apnea input.
apneaFile = fullfile(cdir,'recordings/9 apnea.m4a');
[y_apnea,Fs_apnea] = audioread(apneaFile);
% The frequency sampling must be the same.
if (Fs_normal == Fs_snor && Fs_snor == Fs_apnea)
    Fs = Fs_apnea;
else
    Fs = 0;
end
%% Filtering (Low-pass filter + Downsample)
% INPUTS:
f_down = 8000;
%y = y_normal;
y = y_snor;
%y = y_apnea;
t =(0:length(y)-1)/Fs; % time axis
xmin_time =55;
xmax_time =65;
xmin_freq =0;
xmax_freq =400;
x_start = 10;
windowSize = 0.06; % 60 ms


% Create a window:
ind = find(t>60,1); % 60 sec
y_cut = y(1:ind-1);
[energy,t_energy] = EventDetector(y_cut,Fs,windowSize);


low_ind = find(t>x_start,1);
high_ind = low_ind + Fs * windowSize - 1;
y_window = y(low_ind:high_ind);
t_window = 0:1/Fs:windowSize - 1/Fs;  % t(low_ind:high_ind);

% Filtering:
[y_down,t_down]=resample(y,t,f_down);

% Time domain:
figure();
%plot(t,y);
plot(t,abs(y)/max(abs(y))); % original
hold on;
%plot(t_down,y_down);
plot(t_down,abs(y_down)/max(abs(y_down))); % downsampled
xlim([xmin_time xmax_time]);
legend('Original','Downsampled');

% SHAPE OF THE NORMAL BRETHING IN BETHWEEN 5 - 5.05:
% f1=50;
% f2=100;
% f3=98;
% t1=5:1/1000:5.05;
% y1=2*sin(2*pi*t1*f1)+2.54*sin(2*pi*t1*f2)+0.37*sin(2*pi*t1*f3);
% val_norm=max(y1)/0.015;
% y1_norm=y1/val_norm;
% plot(t1,y1_norm)

% Frequency domain:
[freq_axis, freq] = frequencyDomain(Fs,y);
[freq_axis_down, freq_down] = frequencyDomain(f_down,y_down);
figure();
plot(freq_axis,freq); % original
hold on;
plot(freq_axis_down,freq_down/max(freq_down)); % downsampled
xlim([xmin_freq xmax_freq]);
legend('Original','Downsampled');

%%

frequency_index=find(freq_axis_down <= 0);
positive_frequency_axis = freq_axis_down(frequency_index(end):end); 
positive_freq = freq_down(frequency_index(end):end);
figure;
plot(positive_frequency_axis,positive_freq)

% VLF - Record from 0 to 200:
VLF_f_index = find(positive_frequency_axis > 200 & positive_frequency_axis <= 600);
VLF_frequency_axis = positive_frequency_axis(VLF_f_index(1):VLF_f_index(length(VLF_f_index)));
VLF_freq = positive_freq(VLF_f_index(1):VLF_f_index(length(VLF_f_index)));
figure();
plot(VLF_frequency_axis,VLF_freq)

HF_f_index = find(positive_frequency_axis <= 600);
HF_frequency_axis = positive_frequency_axis(HF_f_index(end):end);
HF_freq = positive_freq(HF_f_index(end):end);
figure;
plot(HF_frequency_axis,HF_freq)

temp_VLF_power = sum(temp_VLF);


