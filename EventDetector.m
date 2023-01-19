% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Method 'EventDetector':
%   Get as an input a vector in the time domain and calculates the energy
%   in this vector by using a window of 60 ms size and an overlap of 75%
%   (45 ms)
function [energy_return,t_return] = EventDetector(y,fs,windowSize)
    %t = 0:1/fs:length(y)*(1/fs)- 1/fs; % time vector of the input signal
    n = (length(y)*(1/fs))/windowSize; % number of fragments with the windowsSize of the vector y
    n_overlap = round(4*n-3); % number of windows if there is an overlap of 75% 
    % BLOCK 1: energy vector calculation.
    windowsPoints = round(windowSize*fs); % number of points of the window
    windowStep = round(windowsPoints*0.25 - 0.5); % 75% of overlap
    low_ind = 1;
    high_ind = windowsPoints + low_ind - 1;
    energy = nan(n_overlap,1);
    % Loop simulating the displacement of the window through the vector:
    for j = 1:(n_overlap)
        y_window = y(low_ind:high_ind);
        energy(j) = sum(y_window.^2);
        low_ind = low_ind + windowStep;
        high_ind = windowsPoints + low_ind - 1;
    end
    
    energy_return=energy;
    t_return = 0:45/length(energy):45-(1/length(energy));
end