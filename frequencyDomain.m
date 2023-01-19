% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Method 'frequencyDomain'
%   Calculates the Fats Fourier Transform (fft) of an input vector and
%   returns the spectrum power centreing the frequency vector in the
%   origin.
function [freq_axis, freq_values] = frequencyDomain(freq_samp,y)
    y_clean=y(~isnan(y));
    %freq_values=abs((fftshift(fft(y_clean)).^2)/length(y_clean));%fft
    freq_values=abs(((fft(y_clean)).^2)/length(y_clean));%fft
    %freq_axis=-freq_samp/2:freq_samp/(length(freq_values)):(freq_samp/2-freq_samp/(length(freq_values))); % shift to centre the spectrum in the origin
    freq_axis= 0:freq_samp/(length(freq_values)):(freq_samp-freq_samp/(length(freq_values))); 
end

