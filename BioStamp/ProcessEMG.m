% Larry To
% Created 7/22/2016
% Applies Filter to raw EMG data 
% pre: require raw EMG data and its sampling rate 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lowFiltData = ProcessEMG(rawData,fs)
%% Signal Processing
% 1.116 is for 25% adjusment factor in 4th order filter 
% 1.25 in 2nd order filter 

% high-pass filter 
cutoff = 20; % 20 Hz
[b, a] = butter(4, 1.116 * cutoff/(fs/2),'high');
% low-Pass filter
cutoff = 5; % 10 Hz
[d, c] = butter(4, 1.116 * cutoff/(fs/2),'low');

% Implementing data processing
%   Filter 
highFiltData = filtfilt(b, a, rawData); % High pass
recData = abs(highFiltData); % Rectfication

%% Remove outliers
thres = 99.99; % Threshold for the percentile
timeWindow = 5000; % Selecting the time window 
outliersThres = prctile(recData, thres);
outliersInd = (find(recData >= outliersThres))';
outliersInd = [outliersInd(1)-timeWindow : outliersInd(1), outliersInd, ...
    outliersInd(end):outliersInd(end)+timeWindow];
for i = 1 : length(outliersInd) - 1
    if (outliersInd(i + 1) - outliersInd(i) > 1)
        outliersInd = [outliersInd(1:i), outliersInd(i)+1 : ...
            outliersInd(i)+timeWindow, outliersInd(i+1)-timeWindow:...
            outliersInd(i+1)-1, outliersInd(i+1:end)];
    end
end
recData(outliersInd) = 0;

%% Low-Pass filter 

lowFiltData = abs(filtfilt(d, c, recData)); % Low pass
% notFiltData = abs(filtfilt(f, e, lowFiltData)); % Notch filter



disp('done signal processing')



