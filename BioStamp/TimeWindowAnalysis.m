% Created by: Larry To 
% Date: 12/14/2016
% Using timing window to calculate max, avg, area, and CCI
load('U:\long term EMG\BioStamp\Data\three-channel-test\0003\participant0003.mat')
%% Creating timing window
% Using 1 sec 
fs = 1000;
timeWindow = 1 * fs;

for i = 1:length(DATA.EMG)
    EMGData{i} = DATA.EMG(i).data{1};
    dataLength(i) = length(EMGData{i});
    if mod(dataLength(i),timeWindow) ~= 0
        EMGCorrectedData{i} = [EMGData{i}; zeros(timeWindow - ...
            mod(dataLength(i),1000),2)]; 
    end
end
numBins = dataLength / timeWindow;
for i = 1:length(DATA.EMG)
    for j = 1:numBins - 1
        maxActivation(i,j) = max(EMGData{i}(1 + 1000 * (j - 1) : 1000 * j,2));
        avgActivation(i,j) = mean(EMGData{i}(1 + 1000 * (j - 1) : 1000 * j,2));
        areaActivation(i,j) = trapz(EMGData{i}(1 + 1000 * (j - 1) : 1000 * j,2));
    end
end
%%  finding overlaping area 
% Bicep: sensor 3, Tricep: sensor 2
for i = 1:length(DATA.EMG)
    timeDiff(i) = DATA.EMG(2).data{1}(1) - DATA.EMG(i).data{1}(1);
end
% Compare Bicep and Tricep time length
truncLength = length(EMGCorrectedData{3}(timeDiff(3):end,2));
truncBicep = (EMGData{3}(timeDiff(3):end,2))';
truncTricep = (EMGData{2}(1:truncLength,2))';
for i = 1:length(DATA.EMG)
    tMs_Bio{i} = (0:1/fs:length(EMGCorrectedData{i}(:,1))...
        /fs - 1/fs)';
    realignTime{i} = (0:1/fs:length(tMs_Bio{i}(timeDiff(i)+1:end))...
        /fs - 1/fs)';
end

for i = 1:length(truncBicep)
    overlapPoint(i) = min(truncBicep(i),truncTricep(i));
end
%% 
% areaBicep = trapz(realignTime{3},EMGData{3}(timeDiff(3)+1:end));
% areaTricep = trapz(tMs_Bio{2}(1:minLength),EMGData{2}(1:minLength));
% time increment should be the same for bicep and overlapping point
% for i = length(DATA.EMG) 
%     overlapArea(i) = trapz(realignTime{2}(1 + 1000 * (i - 1) : 1000 * i,2),...
%         overlapPoint(1 + 1000 * (i - 1) : 1000 * i,2));
% end
% percentCoContraction = 200 * overlapArea / (areaBicep + areaTricep);
    
        