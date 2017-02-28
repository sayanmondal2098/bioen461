% Created by: Larry To
% Date: 11/10/2016
% Take in a data structure of sensor data and Process
close all
% msgbox('DONT TOUCH!!!','DONT YOU DARE', 'warn')
%% Load data structure
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

%% Power Spectrum
% Create a frequency plot with original signal
% Remark to Larry: use ceptral analysis to get outline
% figure('Name','Power Spectrum')
% freq = cell(1,length(DATA.EMG));
% power = freq;
% for i = 1:length(DATA.EMG)
%     [freq{i}, power{i}] = PowerSpectrum(DATA.EMG(i).data{1}(:,2),fs_BioStamp);
%     subplot(length(DATA.EMG),1,i)
%     plot(freq{i},power{i})
%     legend(DATA.EMG(i).name)
%     xlabel('Freq (f)','fontsize',15)
%     ylabel('log |P1(f)|','fontsize',15)
% end
%% Downsampling
% Downsample to 500Hz and 250Hz and generate spectral graph
% parfor i = 1:length(DATA.EMG)
%     downSample500Hz{i} = DATA.EMG(i).data{1}(1:2:end,2);
%     downSample250Hz{i} = downSample500Hz{i}(1:2:end);
%     [f_500{i}, P1_500{i}] = ...
%         PowerSpectrum(downSample500Hz{i}, 500);
%     [f_250{i}, P1_250{i}] = ...
%         PowerSpectrum(downSample250Hz{i}, 250);
%     
% end
% figure('Name','Compareing Power Spectrum between 1000, 500, and 250Hz')
% for i = 1:length(DATA.EMG)
%     subplot(length(DATA.EMG),1,i)
%     title(muscleName{i})
%     plot(freq{i},power{i}), hold on
%     plot(f_500{i},P1_500{i}), hold on
%     plot(f_250{i},P1_250{i})
%     legend('1000','500','250')
% end

%% Accelerated Data 
% Create histogram for acceleration data
% Actigraph
handName = {'Right','Left'};
figure('Name','Acceleration Data in Actigraph')
handNum = length(handName);
parfor i = 1:handNum
    forceVectorActi{i} = RCalculation(DATA.ACTaccel.(handName{i}));
end
for i = 1:handNum
    subplot(1,handNum,i)
    histogram(forceVectorActi{i},300)
    xlabel('Accel (g)')
    ylabel('Frequency (n)')
    legend(handName{i})
end

% BioStamp
accelNum = length(DATA.BIOaccel);
parfor i = 1:accelNum
    forceVectorBio{i} = RCalculation(DATA.BIOaccel(i).data{1}(:,2:4));
end
figure('Name','Accleration Data in BioStamp')
for i = 1:accelNum
    subplot(1,accelNum,i)
    histogram(forceVectorBio{i},100);
    xlabel('Accel (g)')
    ylabel('Frequency (n)')
    legend(muscleName{i})
end

%% Aligning Time Point + Plotting all Channels
% Aligning time points due to the delay in data acquisition based on
% sensors with the latest starting time and earliest stop time

% Finding sensor with the latest start
lateStart = DATA.EMG(1).data{1}(1);
for i = 1:length(DATA.EMG)
    lateStart = max(DATA.EMG(i).data{1}(1), lateStart);
end

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
ylabel('EMG (%MVC)','Fontsize',15), xlabel('Time (s)','Fontsize',15)
title('Compare EMG','Fontsize',15)
h = legend(muscleName);
% set(h,'FontSize',15);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Co-Contraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Co-contraction (Antagonistic Pair)
% Finding the latest start time
% Finding the earliest end time
% Final vector should have latest start time and the earliest time
truncLength = length(normEMGTruncData{1}); %shortest data length
for i = 2:length(DATA.EMG)
    truncLength = min(truncLength, length(normEMGTruncData{i}));
end
for i = 1:length(DATA.EMG)
    normEMGTruncData{i} = normEMGTruncData{i}(1:truncLength);
    realignTime{i} = realignTime{i}(1:truncLength);
end

% Finding agnonist and antagonist muscle pair
if ~exist('musclePair', 'var')
    [musclePair, sensorName] = SensorMuscleMatching(DATA.EMG, realignTime, ...
        normEMGTruncData);
end

% Calculating Overlapping Area of angonist-antagonist muscle pairs
% By locating the points with the smaller magnitude of the two compared
% values, and trapz() the overlapping points 
overlapPoint = zeros(length(musclePair), truncLength);
areaMuscle = zeros(1, length(musclePair));
overlapArea = areaMuscle;
percentCoContraction = zeros(1, length(musclePair)/2);
for i = 1:length(musclePair) / 2
    for j = 1:truncLength
        overlapPoint(i, j) = min(musclePair{1 + 2 * (i - 1)}(j,2),...
            musclePair{2 * i}(j,2));
    end
end
for i = 1:length(musclePair) 
    areaMuscle(i) = trapz(musclePair{i}(:,1), musclePair{i}(:,2));
    overlapArea(i) = trapz(musclePair{i}(:,1), overlapPoint(i,:));
end
for i = 1:length(musclePair) / 2
    percentCoContraction(i) = 200 * overlapArea(i) / ...
        (areaMuscle(1 + 2 * (i - 1)) + areaMuscle(2 * i));
end
%% 
% Bar Graph
figure()
CCName = {'Left upperarm', 'Right upperarm', 'Left forearm', 'Right forearm'};
bar(percentCoContraction)
ylim([0 100])
ylabel('Co-contraction index')
set(gca, 'xticklabel', CCName)
title('Co-Contraction Index for Antagonistic Pairs')

% Correlation plot of antagonistic pair muscle
for i = 1:length(musclePair) / 2
%     fitData = fit(musclePair{1 + 2 * (i - 1)}(1:1000:end,2), ...
%         musclePair{2 * i}(1:1000:end,2), 'exp2');
    figure('Name',CCName{i})
    plot(musclePair{1 + 2 * (i - 1)}(1:1000:end,2), ...
        musclePair{2 * i}(1:1000:end,2), '.')
%     plot(fitData)
%     xlabel('Bicep (%MVC)'), ylabel('Tricep (%MVC)')
    title(strcat(CCName{i}, ' Correlation'))
    xlim([0 1]), ylim([0 1])
    hold off
end

% HEAT MAP for antagonistic pair
figure()
for i = 1:length(musclePair) / 2
    subplot(2,2,i)
    heatmapMat = hist3([musclePair{1 + 2 * (i - 1)}(1:100:end,2), ...
        musclePair{2 * i}(1:100:end,2)],[100 100]);
%     N(1,1) = 0;
%     N(1,2) = 0;
%     N(2,1) = 0;
%     N = rot90(N); % rotating the matrix counter-clockwise
    imagesc(heatmapMat)
    colorbar
    caxis([0 10])
%     colormapeditor
    set(gca, 'XTick', 0:10:100, 'YDir','normal')
    ylabel('% MVIC'), xlabel('% MVIC')
    title(strcat(CCName{i}, ' Correlation'))
end
%% Co-contraction (Dominant vs. Non-Dominant Arm)
% Compare the same muscles of both arms 
% Finding overlaping point 
for i = 1:length(musclePair) / 2
    for j = 1:truncLength
        if i < 3
            overlapPoint(i , j) = min(musclePair{i}(j, 2), ...
                musclePair{i + 2}(j, 2));
        else 
            overlapPoint(i, j) = min(musclePair{i + 2}(j, 2), ...
                musclePair{i + 4}(j, 2));
        end
    end   
end
% Finding overlapping area 
for i = 1:length(musclePair)
    overlapArea(i) = trapz(musclePair{i}(:,1), overlapPoint(i, :));
end
% Calculating cocontraction index
for i = 1:length(musclePair) / 2
    if i < 3
        percentCoContraction(i) = 200 *  overlapArea(i) / ...
            (areaMuscle(i) + areaMuscle(i + 2));
    else
        percentCoContraction(i) = 200 * overlapArea(i) / ...
            (areaMuscle(i + 2) + areaMuscle(i + 4));
    end
end

% Bar Graph
figure()
CCNameArm = {'Bicep', 'Tricep', 'ECR', 'FCU'};
bar(percentCoContraction)
ylabel('Co-contraction index')
set(gca, 'xticklabel', CCNameArm)

% Correlation Plot of Left-Right arm 
for i = 1:length(musclePair) / 2
    figure('Name', CCNameArm{i})
    if i < 3
       plot(musclePair{i}(1:1000:end,2), ...
           musclePair{i + 2}(1:1000:end,2),'.')
    else 
       plot(musclePair{i + 2}(1:1000:end,2), ...
           musclePair{i + 4}(1:1000:end,2),'.')
    end
    title(strcat(CCNameArm{i}, ' Correlation'))
    xlim([0 1.6]), ylim([0 1.6])
end
%% 
% Heat Map 
figure()
for i = 1:length(musclePair) / 2
    subplot(2,2,i)
    heatmapMat = hist3([musclePair{i + 2}(1:1000:end,2), ...
           musclePair{i + 4}(1:1000:end,2)],[100 100]);
%     N(1,1) = 0;
%     N(1,2) = 0;
%     N(2,1) = 0;
%     N = rot90(N); % rotating the matrix counter-clockwise
    imagesc(heatmapMat)
    colorbar
    caxis([0 10])
%     colormapeditor
    set(gca, 'XTick', 0:10:100, 'YDir','normal')
    ylabel('% MVIC'), xlabel('% MVIC')
    title(strcat(CCNameArm{i}, ' Correlation'))
end

%% Basic Info
% obtain info of each EMG signal (avg, max, integrated area)
average = zeros(1, length(NormEMGData));
maxData = average;
integratedArea = average;
for i = 1:length(NormEMGData)
    average(i) = mean(normEMGTruncData{i});
    maxData(i) = max(normEMGTruncData{i});
    integratedArea(i) = trapz(normEMGTruncData{i});
    sensorName{i} = DATA.EMG(i).name;
end
% recordingTime = realignTime{1}(end);

EMGDATAINFO = table(muscleName', average', maxData', integratedArea',...
    'RowNames',sensorName', 'VariableNames',{'Muscle_Name', 'Average', 'Max', ...
    'Integrated_Area'});
disp(EMGDATAINFO)

% Number of activation
for i = 1:length(DATA.EMG)
    pks = findpeaks(normEMGTruncData{i}, realignTime{i},...
        'MinPeakHeight', 0.4, 'MinPeakDistance', 0.5);
    numPks(i) = length(pks);
end
%% Activation Level
% Calclate activity level and display them using a bar graph 
actRest = zeros(length(DATA.EMG), 1);
actLight = actRest;
actMod = actRest;
actHeavy = actRest;
% Setting threshold for different activity level
% Update: excluding resting stat
for i = 1:length(DATA.EMG)
%     activityRest(i) = length(find(normEMGTruncData{i} <= 0.05));
    actLight(i) = length(find(normEMGTruncData{i} <= 0.35 & ...
        normEMGTruncData{i} > 0.05));
    actMod(i) = length(find(normEMGTruncData{i} <= 0.75 & ...
        normEMGTruncData{i} > 0.35));
    actHeavy(i) = length(find(normEMGTruncData{i} > 0.75));
    actSum(:, i) = 100 .* [actLight(i) ...
        actMod(i) actHeavy(i)] ./ length(normEMGTruncData{i});
    
end
figure
colorName = {'b','y','m'};
titleName = {'Light (<35% MVC)','Moderate(<75% & >35% MVC)', ...
    'Heavy(>75% MVC)'};
for i = 1:length(actSum(:,1))
    subplot(1,3,i)
    bar(actSum(i,:)',colorName{i})
    title(titleName{i})
    set(gca, 'XTickLabel', muscleName)
    rotateXLabels(gca, 45)
    ylabel('% of Total Data Collection')
end
% bar(activitySum')
% set(gca, 'XTickLabel', muscleName, 'YScale', 'log')

% ylabel('Percent of Total Time (%)')
% xlabel('Muscle')
% legend('Light','Moderate', 'Heavy')
% title('Time Spent at Different Activation Level of Each Muscle')

% figure
% boxplot(activitySum)
% ylim([-5 100])
% ylabel('Percent of Total Time (%)')
% xlabel('Muscle')
% set(gca, 'XTickLabel', muscleName)
% title('Time Spent at Different Activation Level of Each Muscle')

%% Basic Info with Time Window
% obatin info of each EMG signal (avg, max, integrated area) in a user-set
% time- window 
% Note to Larry: testing 1, 3, 10, 30, 60, 120
timeWindow = 10 * fs_BioStamp; % 3 sec
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
figure()
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
    bar(histXout1, 100*histFreq1/sum(histFreq1)), hold on;
%     plot(histXout, 100*histFreq/sum(histFreq))
    titleName = strcat('Co-Contraction Index in 1-sec Time Window ', ...
        CCName{i});
    title(titleName)
    xlabel('Co-Contraction Index')
    ylabel('Count (n^t^h)')
    
end

%% Activation Analysis 
% Break down individual actiations and calculate basic inforamtion on each
% activation.
% threshold = mean + J * std
J = 1.5; % Threshold constant 
dAT = cell(1, length(DATA.EMG));
actCount = zeros(1, length(DATA.EMG));
for i = 1:length(DATA.EMG)

    threshold = average(i) + J * std(normEMGTruncData{i}); % Threshold
    dAT{i} = find(normEMGTruncData{i} > threshold); % data above threshold
    count = 0;
    %   isolating activation
    for j = 1:length(dAT{i}) - 1
        if (dAT{i}(j+1) - dAT{i}(j) > 100)
            count = count + 1;
        end
    end
    actCount(i) = count;

    %   Plotting
%         figure('Name', strcat('Muscle Activation ', muscleName{i}))
%         plot(realignTime{i}, normEMGTruncData{i}), hold on
%         plot(realignTime{i}(dAT{i}), normEMGTruncData{i}(dAT{i}))
%         title(strcat('Threshold for Muscle Activation ', muscleName{i}))
%         xlabel('Time (s)')
%         ylabel('EMG (%MVC)')
%         legend('EMG Data', 'Data Point above Threshold')
end

ACTINFO = table(muscleName', actCount','RowNames',sensorName',...
    'VariableNames',{'Muscle_Name', 'Number_of_Activation'});
disp(ACTINFO)

%% Testing Threshold 
figure()
timeThresh = 1:50:1000;
for ind = 1:length(timeThresh)
    for i = 1:length(DATA.EMG)
        
        threshold = average(i) + J * std(normEMGTruncData{i}); % Threshold
        dAT{i} = find(normEMGTruncData{i} > threshold); % data above threshold
        count = 0;
        %   isolating activation
        for j = 1:length(dAT{i}) - 1
            if (dAT{i}(j+1) - dAT{i}(j) > timeThresh(ind))
                count = count + 1;
            end
        end
        actCount(i, ind) = count;
       
    end
end

for i = 1:length(DATA.EMG)
%     subplot(2,4,i)
    plot(timeThresh, actCount(i,:),'o-'), hold on
   
end
title('Assessment of different time threshold')
legend(muscleName)
title('Testing of Different Time Threshold')
xlabel('Time Threshold (ms)')
ylabel('Number of Count')
%% 
thresCoeff = 1:9;
clear actCount
for ind = 1:length(thresCoeff)
    for i = 1:length(DATA.EMG)
        
        threshold = average(i) + thresCoeff(ind) * std(normEMGTruncData{i}); % Threshold
        dAT{i} = find(normEMGTruncData{i} > threshold); % data above threshold
        count = 0;
        %   isolating activation
        for j = 1:length(dAT{i}) - 1
            if (dAT{i}(j+1) - dAT{i}(j) > 100)
                count = count + 1;
            end
        end
        actCount(i, ind) = count;
        
    end
end
%% 
figure()
for i = 1:length(DATA.EMG)
%     subplot(2,4,i)
    plot(thresCoeff, actCount(i,:),'o-'), hold on
   
end
title('Assessment of different time threshold')
legend(muscleName)
title('Testing of Different Threshold Coefficient')
xlabel('Threshold Coefficient')
ylabel('Number of Count')