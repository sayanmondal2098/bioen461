load('U:\long term EMG\BioStamp\Data\three-channel-test\0003\participant0003.mat');
[ADLStartInd, exerStartInd, exerEndInd] = ExtractNonSNR(1);


%% 
plot(DATA.EMG(1).data{1}(:,1),DATA.EMG(1).data{1}(:,2),'r'), hold on
plot(DATA.EMG(1).data{1}(exerEndInd(1,1):exerStartInd(1,2),1), ...
    DATA.EMG(1).data{1}(exerEndInd(1,1):exerStartInd(1,2),2)), hold on
plot(DATA.EMG(1).data{1}(exerEndInd(1,2):exerStartInd(1,3),1), ...
    DATA.EMG(1).data{1}(exerEndInd(1,2):exerStartInd(1,3),2)), hold on
plot(DATA.EMG(1).data{1}(exerEndInd(1,3):exerStartInd(1,4),1), ...
    DATA.EMG(1).data{1}(exerEndInd(1,3):exerStartInd(1,4),2)), hold on















