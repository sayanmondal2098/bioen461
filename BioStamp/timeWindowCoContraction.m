tic
if ~exist('DATA', 'var')
load('U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial1\matlab.mat')
end
%% Process BioStamp EMG Data
fs_BioStamp = 1000;
muscleName = {'Left Tricep','Right FCU','Left Bicep','Left ECR',...
    'Left FCU','Right Tricep','Right Bicep','Right ECR'}; % according to sensor names
sensorName = cell(1,length(DATA.EMG));
for i = 1:length(DATA.EMG)
    sensorName{i} = DATA.EMG(i).name(end-1:end);
end
% Obtain MVC
MVC = ObtainMVC (DATA.annot, DATA.EMG, muscleName, 0);

% Processing Data
parfor i = 1:length(DATA.EMG)
    EMGData{i} = ProcessEMG(DATA.EMG(i).data{1}(:,2),fs_BioStamp);
    NormEMGData{i} = EMGData{i} / MVC(i);
end

lateStart = DATA.EMG(1).data{1}(1);
for i = 2:length(DATA.EMG)
    lateStart = max(DATA.EMG(i).data{1}(1), lateStart);
end

%% Full EMG Signal
figure('Name','Processed EMG Data')
tMs_Bio = cell(1,length(DATA.EMG));
for i = 1:length(DATA.EMG)
    tMs_Bio{i} = (0:1/fs_BioStamp:length(DATA.EMG(i).data{1}(:,1))...
        /fs_BioStamp - 1/fs_BioStamp)';
    subplot(length(EMGData),1,i)
    plot(tMs_Bio{i},NormEMGData{i})
    h = legend(muscleName{i});
    set(h,'FontSize',15);
    ylabel('EMG (%MVC)')
    xlabel('Time (s)')
end
%% 
% Truncate original time aray to a new aligned array
timeDiff = zeros(1, 8);
realignTime = cell(1, 8);
normEMGTruncData = cell(1, 8);
figure()
for i = 1:length(DATA.EMG)
    timeDiff(i) = lateStart - DATA.EMG(i).data{1}(1);
    realignTime{i} = (0:1/fs_BioStamp:length(tMs_Bio{i}(timeDiff(i)+1:end))...
        /fs_BioStamp - 1/fs_BioStamp)';
    normEMGTruncData{i} = NormEMGData{i}(timeDiff(i)+1:end);
    plot(realignTime{i}, normEMGTruncData{i}), hold on
end

%% Basic Info with Time Window
% obatin info of each EMG signal (avg, max, integrated area) in a user-set
% time- window
timeWindow = 3 * fs_BioStamp; % 60 sec
% Ensure all EMG array contains timsWindows' bins by adding zeros
for i = 1:length(DATA.EMG)
    dataLength(i) = length(normEMGTruncData{i});
    if mod(dataLength(i),timeWindow) ~= 0
        correctedTime{i} = [realignTime{i}; zeros(timeWindow - ...
            mod(dataLength(i), timeWindow), 1)];
        EMGCorrectedData{i} = [normEMGTruncData{i}; zeros(timeWindow - ...
            mod(dataLength(i), timeWindow), 1)];
    end
    numBins(i) = length(EMGCorrectedData{i}) / timeWindow;
end

% Using the shortest amount of bins so all vectors are in the same length
maxAct_TW = zeros(length(DATA.EMG), numBins(1));
avgAct_TW = maxAct_TW;
areaAct_TW = maxAct_TW;
for i = 1:length(DATA.EMG)
    for j = 1:min(numBins)
        maxAct_TW(i,j) = max(EMGCorrectedData{i}(1 + timeWindow * ...
            (j - 1) : timeWindow * j));
        avgAct_TW(i,j) = mean(EMGCorrectedData{i}(1 + timeWindow * ...
            (j - 1) : timeWindow * j));
        areaAct_TW(i,j) = trapz(EMGCorrectedData{i}(1 + timeWindow * ...
            (j - 1) : timeWindow * j));
    end
end

% Time Window analysis for Bicep-Tricep correlation
if ~exist('muscleCorrected', 'var')
    [muscleCorrected, ~] = SensorMuscleMatching(DATA.EMG, ...
        correctedTime, EMGCorrectedData);
end

% Cocontraction Analysis
for i = 1:length(muscleCorrected)
    for j = 1:min(numBins)
        muscleBin{i}(:,j) = muscleCorrected{i}((j - 1) * timeWindow + 1 : ...
            j * timeWindow, 2);
        %         muscle2Bin{i}(:,j) = muscle2Corrected{i}((j - 1) * timeWindow + 1 : ...
        %             j * timeWindow, 2);
        timeBin{i}(:,j) = correctedTime{1}((j - 1) * timeWindow + 1 : j * ...
            timeWindow);
        
        areaMuscle(i, j) = trapz(timeBin{i}(:,j), muscleBin{i}(:,j));
        %         areaMuscle2(i, j) = trapz(timeBin{i}(:,j), muscle2Bin{i}(:,j));
        maxMuscle1(i, j) = max(muscleBin{i}(:,j));
        %         maxMuscle2(i, j) = max(muscle2Bin{i}(:,j));
        avgMuscle1(i, j) = mean(muscleBin{i}(:,j));
        %         avgMuscle2(i, j) = mean(muscle2Bin{i}(:,j));
        
    end
end
overlapPoint_TW = zeros(1, timeWindow);
overlapArea_TW = zeros(length(muscleCorrected) / 2, min(numBins));
percentCC_TW = overlapArea_TW;
%% Plotting Co-Contraction Time Window
figure
CCName = {'Left upperarm', 'Right upperarm', 'Left forearm', 'Right forearm'};
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
    histogram(percentCC_TW(i, :))
    titleName = strcat('Co-Contraction Index in 1-sec Time Window ', ...
        CCName{i});
    title(titleName)
    xlabel('Co-Contraction Index')
    ylabel('Count (n^t^h)')
    
end
toc