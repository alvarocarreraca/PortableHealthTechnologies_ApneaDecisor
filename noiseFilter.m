function [t_down, y_down] = noiseFilter(Fs, f_down, y)
    D = round(Fs/f_down - 0.5); % downsampled integer factor
    t =(0:length(y)-1)/Fs; % time axis
    
    % Filtering:
    Fc = Fs/(2*D);
    Wn = Fc/(Fs/2); % Wn = 1/D
    filt = designfilt('lowpassiir','FilterOrder',10,'HalfPowerFrequency',Wn); % butter filter: [num,den] = butter(10,Wn,'low')
    %fvtool(filt,'Fs',Fs); % prints de filter
    y_filtrated = filter(filt,y);   
    delay = mean(grpdelay(filt));
    y_shifted = circshift(y_filtrated',[0 -round(delay + 4)]);
    
    % Downsampling:
    [t_down, y_down] = downSample(Fs, f_down, t, y_shifted);  

    % Time domain
    figure();
    plot(t,y); % original
    hold on;
    plot(t,y_shifted); % filtered (low-pass, Fc ~= 4kHz)    
    plot(t_down,y_down); % downsampled
    xlim([5 5.005]);
    legend('Original','Filtered','Downsampled');
    % Frequency domain
    [freq_axis, freq] = frequencyDomain(Fs,y);
    [freq_axis_filtrated, freq_filtrated] = frequencyDomain(Fs,y_shifted);
    [freq_axis_down, freq_down] = frequencyDomain(f_down,y_down);
    figure;
    plot(freq_axis,freq); % original
    hold on;
    plot(freq_axis_filtrated,freq_filtrated); % filtered (low-pass, Fc ~= 4kHz)
    plot(freq_axis_down,freq_down); % downsampled
    xlim([0 120]);
    legend('Original','Filtered','Downsampled');

end

