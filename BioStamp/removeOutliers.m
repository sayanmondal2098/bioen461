% Created by: Larry To
% Date: 2/08/2017
% Testing different methods for removing outliers/motion artifacts 
close all
if(~exist('DATA', 'var'))
    load('U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial3\matlab.mat')
end
%% 
fs = 1000;
%%
% high-pass filter
cutoff = 20; % 20 Hz
[b, a] = butter(4, 1.116 * cutoff/(fs/2),'high');
% low-Pass filter
cutoff = 5; % 10 Hz
[d, c] = butter(4, 1.116 * cutoff/(fs/2),'low');

% Implementing data processing
% Filter
highFiltData = filtfilt(b, a, DATA.EMG(8).data{1}(:,2)); % High pass
recData = abs( highFiltData); % Rectfication
tMs_Bio = (0:1/fs:length(DATA.EMG(8).data{1}(:,1))...
        /fs - 1/fs)';
%% Find outliers
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

%%
lowFiltData = abs(filtfilt(d, c, recData)); % Low pass

%% 
figure()
plot(tMs_Bio, highFiltData)
title('EMG Data after High-Pass Filter')
xlabel('time (s)')
ylabel('Voltage (v)')

figure()
plot(tMs_Bio, lowFiltData)
title('EMG Data after Low-Pass Filter')
xlabel('time (s)')
ylabel('Voltage (v)')

%%
% % Number of activation
% tMs_Bio = (0:1/fs:length(DATA.EMG(1).data{1}(:,1))...
%     /fs - 1/fs)';
% 
% [pks, loc] = findpeaks(lowFiltData, tMs_Bio,...
%     'MinPeakHeight', 0.0005, 'MinPeakDistance', 0.5);



