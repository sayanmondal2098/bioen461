clear dataOutliers
if(~exist('DATA', 'var'))
    load('U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial1\matlab.mat')
end
%%
fs_BioStamp = 1000;
muscleName = {'Left Tricep','Right FCU','Left Bicep','Left ECR',...
    'Left FCU','Right Tricep','Right Bicep','Right ECR'}; % according to sensor names
sensorName = cell(1,length(DATA.EMG));
for i = 1:length(DATA.EMG)
    sensorName{i} = DATA.EMG(i).name(end-1:end);
end
% Obtain MVC
MVC = ObtainMVC (DATA.annot, DATA.EMG, muscleName, 0);

%%
% Processing Data
parfor i = 1:length(DATA.EMG)
    dataLength = length(DATA.EMG(i).data{1}(:,2));
    EMGData{i} = ProcessEMG(DATA.EMG(i).data{1}(3 * dataLength / 4 : end,2), ...
        fs_BioStamp);
    NormEMGData{i} = EMGData{i} / MVC(i);
end

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
figure('Name','Processed EMG Data')
tMs_Bio = cell(1,length(DATA.EMG));
for i = 6
    tMs_Bio{i} = (0:1/fs_BioStamp:length(NormEMGData{i})...
        /fs_BioStamp - 1/fs_BioStamp)';
    %     subplot(length(EMGData),1,i)
    plot(tMs_Bio{i},NormEMGData{i}), hold on
    
end

legend(muscleName)
ylabel('EMG (%MVC)')
xlabel('Time (s)')