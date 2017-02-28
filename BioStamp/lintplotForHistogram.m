%% Basic Info with Time Window
% obatin info of each EMG signal (avg, max, integrated area) in a user-set
% time- window 
% Note to Larry: testing 1, 3, 10, 30, 60, 120
testNum = [1 3 10 30 60 120];
for i = 1:length(testNum)
timeWindow = testNum(i) * fs_BioStamp; % 3 sec
% Ensure all EMG array contains timsWindows' bins by adding zeros
for i = 1:length(DATA.EMG)
    dataLength(i) = length(normEMGTruncData{i});
    if mod(dataLength(i),timeWindow) ~= 0
        correctedTime{i} = [realignTime{i}; zeros(timeWindow - ...
            mod(dataLength(i), timeWindow), 1)];
        EMGCorrectedData{i} = [normEMGTruncData{i}; zeros(timeWindow - ...
            mod(dataLength(i), timeWindow), 1)];
    end
    numBins = length(EMGCorrectedData{i}) / timeWindow;
end

% Using the shortest amount of bins so all vectors are in the same length
maxAct_TW = zeros(length(DATA.EMG), numBins(1));
avgAct_TW = maxAct_TW;
areaAct_TW = maxAct_TW;
for i = 1:length(DATA.EMG)
    for j = 1:min(numBins)
        avgAct_TW(i,j) = mean(EMGCorrectedData{i}(1 + timeWindow * ...
            (j - 1) : timeWindow * j));
        if (avgAct_TW(i, j) > 0.025)
            maxAct_TW(i,j) = max(EMGCorrectedData{i}(1 + timeWindow * ...
                (j - 1) : timeWindow * j));

            areaAct_TW(i,j) = trapz(EMGCorrectedData{i}(1 + timeWindow * ...
                (j - 1) : timeWindow * j));
        else
            avgAct_TW(i, j) = nan;
            maxAct_TW(i, j) = nan;
            areaAct_TW(i, j) = nan;
        end
    end
end

% Time Window analysis for Bicep-Tricep correlation
% if ~exist('muscleCorrected', 'var')
[muscleCorrected, ~] = SensorMuscleMatching(DATA.EMG, ...
    correctedTime, EMGCorrectedData, sensorName);
% end

% Cocontraction Analysis
muscleBin = cell(1, length(muscleCorrected));
timeBin = muscleBin;
areaMuscle = zeros(length(muscleCorrected), min(numBins));
maxMuscle1 = areaMuscle;
avgMuscle1 = areaMuscle;
for i = 1:length(muscleCorrected)
    for j = 1:min(numBins)
%         Set up bin
        muscleBin{i}(:,j) = muscleCorrected{i}((j - 1) * timeWindow + 1 : ...
            j * timeWindow, 2);
        timeBin{i}(:,j) = correctedTime{1}((j - 1) * timeWindow + 1 : j * ...
            timeWindow);
%         Calculate 
        if (avgAct_TW(i, j) > 0.025)
            areaMuscle(i, j) = trapz(timeBin{i}(:,j), muscleBin{i}(:,j));
        else 
            areaMuscle(i, j) = nan;
        end
%         maxMuscle1(i, j) = max(muscleBin{i}(:,j));
%         avgMuscle1(i, j) = mean(muscleBin{i}(:,j));
    end
end

% Plotting Co-Contraction Time Window
overlapPoint_TW = zeros(1, timeWindow);
overlapArea_TW = zeros(length(muscleCorrected) / 2, min(numBins));
percentCC_TW = overlapArea_TW;
% figure()


for i = 1:length(muscleCorrected) / 2
    for j = 1:min(numBins)
        for k = 1:timeWindow
            overlapPoint_TW(k) = min(muscleBin{1 + 2 * (i - 1)}(k, j),...
                muscleBin{2 * i}(k, j));
        end
        overlapArea_TW(i, j) = trapz(timeBin{i}(:,j), overlapPoint_TW);
        percentCC_TW(i, j) = 200 * overlapArea_TW(i, j) / ...
            (areaMuscle(1 + 2 * (i - 1), j) + areaMuscle(2 * i ,j));
    end
    subplot(2,2,i)
    [histFreq, histXout] = hist(percentCC_TW(i, :));
%     bar(histXout1, 100*histFreq1/sum(histFreq1)), hold on;
    plot(histXout, 100*histFreq/sum(histFreq)), hold on 
    titleName = strcat('Co-Contraction Index in Various Time Window ', ...
        CCName{i});
    title(titleName)
    xlabel('Co-Contraction Index')
    ylabel('Count (n^t^h)')
    
end
end
legend(num2str(testNum))