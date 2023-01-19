function [ t_samp, y_samp ] = downSample(Fs, f_samp, t, y)
    N = round(Fs/f_samp - 0.5);
    t_samp = t(1:N:end);
    y_samp = y(1:N:end); % lowering sample rate
end

