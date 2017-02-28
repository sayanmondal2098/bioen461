function [ADLStartInd, exerStartInd, exerEndInd] = ExtractNonSNR(n)
load('U:\long term EMG\BioStamp\Data\three-channel-test\0003\participant0003.mat');
%% Finding Non-Exercise EMG 
% 
countExercise = 0;
countMVC = 0;
ADLStart = 0;
for i = 1:size(DATA.annot.EventType,1)
%     finding timepoints of exercise
   if(~isempty(strfind(DATA.annot.EventType{i},'Exercise')))
       countExercise = countExercise + 1;
       exerciseStart(countExercise) = DATA.annot.StartTimestamp_ms_(i);
       exerciseEnd(countExercise) = DATA.annot.StopTimestamp_ms_(i);
   end
   
%    finding when the ADL starts
   if(~isempty(strfind(DATA.annot.EventType{i},'MVC')))
       if(DATA.annot.StopTimestamp_ms_(i) > ADLStart)
           ADLStart = DATA.annot.StopTimestamp_ms_(i);
       end
   end
end

%% Corresponding index
% finding corresponding index number in DATA
format long
for i = 1:length(DATA.EMG)
    ADLStartInd(i) = find(DATA.EMG(i).data{1}(:,1) == ADLStart);
end
for i = 1:length(DATA.EMG)
    for j = 1:length(exerciseStart)
        exerStartInd(i,j) = min(find(abs(DATA.EMG(i).data{1}(:,1) - exerciseStart(j)) < 2));
        exerEndInd(i,j) = min(find(abs(DATA.EMG(i).data{1}(:,1) - exerciseEnd(j)) < 2));
    end
end




end

