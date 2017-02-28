% load('U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial1\matlab.mat')
% %% 
% annotData = DATA.annot;
% EMGData = DATA.EMG;
% muscleName = {'Left Tricep','Right FCU','Left Bicep','Left ECR',...
%     'Left FCU','Right Tricep','Right Bicep','Right ECR'};
% plotOption = 0;
function MVCData = ObtainMVC (annotData, EMGData, muscleName, plotOption)

% Pairing up the starting and stopping time with each muscle. 
for j = 1:length(muscleName)
    for i = 1:size(annotData.EventType,1)
        if(contains(annotData.EventType{i},muscleName{j}))
            startTime(j) = annotData.StartTimestamp_ms_(i);
            endTime(j) = annotData.StopTimestamp_ms_(i);
        end
    end
end


for i = 1:length(EMGData)
    EMGStart(i) = find(EMGData(i).data{1}(:,1) == startTime(i));
    EMGEnd(i) = find(EMGData(i).data{1}(:,1) == endTime(i));
    fullEMGData{i} = EMGData(i).data{1}(EMGStart(i):EMGEnd(i),2);
    
end


%% Process Data 
fs = 1000;
for i = 1:length(EMGData)
    filtEMGData{i} = ProcessEMG(EMGData(i).data{1}(:,2),fs);
end

%% Obtain MVC
percentile = 97;
for i = 1:length(EMGData)
    MVCData(i) = max(prctile(filtEMGData{i}(EMGStart(i):EMGEnd(i)), percentile));
end

%% Plot
if plotOption == 1
    figure()
    i = 2;
    plot(filtEMGData{i}(EMGStart(i):EMGEnd(i)))
    title('Linear envelope for MVC Test')
    ylabel('Voltage (V)'), xlabel('Data (n^t^h)')
    data  = [zeros(5000, 1); filtEMGData{i}(EMGStart(i):EMGEnd(i)); zeros(5000, 1)];
    pulsewidth(data, 1000, 'MidPercentReferenceLevel',10);
end
% plot(filtEMGData{i}) 

%% 






