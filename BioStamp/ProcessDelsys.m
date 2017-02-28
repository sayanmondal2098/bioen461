clear all, close all

DATA = csvread('U:\long term EMG\BioStamp\Data\three-channel-test\0001_Trial2\S0001_CrossTalkTest_Larry_MVC_Rep_1.1.csv',1,0);
%% 
bicep = DATA(:,1:2);
tricep = DATA(:,9:10);
deltoid = DATA(:,17:18);

time = bicep(:,1);
EMG = [bicep(:,2) tricep(:,2) deltoid(:,2)];
fs = 1926;
cleanEMG = ones(size(EMG));
percentile = 97;
for i = 1: length(EMG(1,:))
    cleanEMG(:,i) = ProcessEMG(EMG(:,i), fs);
    MVCValue(i) = max(prctile(cleanEMG(:,i),percentile));
    normEMG(:,i) = cleanEMG(:,i) ./ MVCValue(i);
end

%% 
figure()
plot(time,cleanEMG(:,1)), hold on
plot(time,cleanEMG(:,2)) 

title('EMG during MVC Test')
ylabel('Volt (V)')
xlabel('Time (sec)')
legend('bicep','tricep')








