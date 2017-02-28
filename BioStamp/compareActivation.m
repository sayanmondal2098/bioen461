data1 = load('U:\trial1TruncatedData.mat');
data2 = load('U:\trial3TruncatedData.mat');
data3 = load('U:\trial4TruncatedData.mat');
EMGData1 = data1.normEMGTruncData;
EMGData2 = data2.normEMGTruncData;
EMGData3 = data3.normEMGTruncData;
%% 
for i = 1:length(EMGData1)
    actLight1(i) = 100 * length(find(EMGData1{i} <= 0.35 & ...
        EMGData1{i} > 0.05)) / length(EMGData1{i});
    actMod1(i) = 100 * length(find(EMGData1{i} <= 0.75 & ...
        EMGData1{i} > 0.35)) / length(EMGData1{i});
    actHeavy1(i) = 100 * length(find(EMGData1{i} > 0.75)) / length(EMGData1{i});
end
for i = 1:length(EMGData1)
    actLight2(i) = 100 * length(find(EMGData2{i} <= 0.35 & ...
        EMGData2{i} > 0.05)) / length(EMGData2{i});
    actMod2(i) = 100 * length(find(EMGData2{i} <= 0.75 & ...
        EMGData2{i} > 0.35)) / length(EMGData2{i});
    actHeavy2(i) = 100 * length(find(EMGData2{i} > 0.75)) / length(EMGData2{i});
%     actSum2(:, i) = 100 .* [actLight2(i) ...
%         actMod2(i) actHeavy2(i)] ./ length(EMGData2{i});
    
end
for i = 1:length(EMGData1)
    actLight3(i) = 100 * length(find(EMGData3{i} <= 0.35 & ...
        EMGData3{i} > 0.05)) / length(EMGData3{i});
    actMod3(i) =100 *  length(find(EMGData3{i} <= 0.75 & ...
        EMGData3{i} > 0.35)) / length(EMGData3{i});
    actHeavy3(i) = 100 * length(find(EMGData3{i} > 0.75)) / length(EMGData3{i});
%     actSum3(:, i) = 100 .* [actLight3(i) ...
%         actMod3(i) actHeavy3(i)] ./ length(EMGData3{i});
    
end

for i = 1:length(actLight1)
    actAllLight = [actLight1(i) actLight2(i) actLight3(i)];
    actAllMod = [actMod1(i) actMod2(i) actMod3(i)];
    actAllHeavy = [actHeavy1(i) actHeavy2(i) actHeavy3(i)];
    actLightAvg(i) = mean(actAllLight);
    if (std(actAllLight) > 2 * median(actAllLight))
        
    end
    actLightStd(i) = std(actAllLight);
    actModAvg(i) = mean(actAllMod);
    actModStd(i) = std(actAllMod);
    actHeavyAvg(i) = mean(actAllHeavy);
    actHeavyStd(i) = std(actAllHeavy);
end
%%
% labelName = {'Light' ,'Moderate' ,'Large'};
figure()
muscleName = {'Left Tricep','Right FCU','Left Bicep','Left ECR',...
    'Left FCU','Right Tricep','Right Bicep','Right ECR'};
subplot(1,3,1)
barwitherr(actLightStd,actLightAvg)
title('Light Activation Level')
set(gca, 'XTickLabel', muscleName)
rotateXLabels(gca, 45)
subplot(1,3,2)
barwitherr(actModStd, actModAvg)
title('Moderate Activation Level')
set(gca, 'XTickLabel', muscleName)
rotateXLabels(gca, 45)
subplot(1,3,3)
barwitherr(actHeavyStd, actHeavyAvg)
title('Heavy Activation Level')
set(gca, 'XTickLabel', muscleName)
rotateXLabels(gca, 45)
%% 
% figure
% colorName = {'b','y','m'};
% titleName = {'Light (<35% MVC)','Moderate(<75% & >35% MVC)', ...
%     'Heavy(>75% MVC)'};
% for i = 1:length(actSum(:,1))
%     subplot(1,3,i)
%     bar(actSum(i,:)',colorName{i})
%     title(titleName{i})
%     set(gca, 'XTickLabel', muscleName)
%     rotateXLabels(gca, 45)
%     ylabel('% of Total Data Collection')
% end
% bar(actSum')
% set(gca, 'XTickLabel', muscleName, 'YScale', 'log')

% ylabel('Percent of Total Time (%)')
% xlabel('Muscle')
% legend('Light','Moderate', 'Heavy')
% title('Time Spent at Different Activation Level of Each Muscle')

% figure
% boxplot(actSum)
% ylim([-5 100])
% ylabel('Percent of Total Time (%)')
% xlabel('Muscle')
% set(gca, 'XTickLabel', muscleName)
% title('Time Spent at Different Activation Level of Each Muscle')
