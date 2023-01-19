% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Method 'countPeaks'
%   Receives as an input an energy vector (the one calculated in
%   EventDetector.m) and calculates the number of peaks that are over a
%   fixed threshold under certain circumstances.
%       1) The fixed threshold is 180% of the mean of the input vector
%       2) To count a peak, its width has to be bigger than 300 ms and the
%       distance in between peaks has to be at least of 3.5 seconds.
function num_peak = countPeaks(energy,t)
    threshold = 1.8*mean(energy); % 180% of the energy mean (fixed threshold)
    upward = 1;
    downward = 0;
    t_min = -1;
    t_max = -1;
    min_duration = 0.3; % 300 ms (minimum width of the peak)
    max_duration = 3.5; % 3.5 sec (minimum distance in between peaks)
    t_min_origin = -max_duration; % Variable to save the position of the last peak detected
    count = 0;
    % Loop that runs the input vector looking for peaks.
    for j = 1 : length(energy)
        if (upward)
            if(energy(j) >= threshold)
                t_min = t(j);          
                upward = 0;
                downward = 1;
            end
        elseif (downward)
            if(energy(j) <= threshold)
                t_max = t(j);        
                upward = 1;
                downward = 0;
            end
        end
        % When it is detected a peak, it must meet the width and distance between peaks requirements 
        if (t_min ~= -1 && t_max ~= -1)
            if (t_max - t_min >= min_duration && t_max - t_min_origin >= max_duration)
                count = count + 1;
                t_min_origin = t_min;
            end
            t_min = -1;
            t_max = -1;
        end
    end
    
    num_peak = count;
end

