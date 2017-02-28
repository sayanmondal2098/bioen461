% load('U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial1\matlab.mat')
% dataName = DATA.EMG;
function [muscle, sensorName] = SensorMuscleMatching(dataName, time, data, varargin)
% Ordering the data in a logical manner by prompting users sensor name for
% the corresponding muscle
% Input: 
% dataName = sensorName in cell array
% time = time vector 
% data = EMG vector
if isempty(varargin)
%% finding sensor-muscle pair
    prompt{1} = 'Which sensor corresponds to L. Bicep?';
    prompt{2} = 'Which sensor corresponds to L. Tricep?';
    prompt{3} = 'Which sensor corresponds to R. Bicep?';
    prompt{4} = 'Which sensor corresponds to R. Tricep?';
    prompt{5} = 'Which sensor corresponds to L. ECR?';
    prompt{6} = 'Which sensor corresponds to L. FCU?';
    prompt{7} = 'Which sensor corresponds to R. ECR?';
    prompt{8} = 'Which sensor corresponds to R. FCU?';
    dlg_title = 'Sensor Muscle Pairing';
    answer = inputdlg(prompt, dlg_title);
else 
    answer = varargin;
end

%% matching antagonistic muscle pairs
counter1 = 0;
counter2 = 0;
for i = 1: length(answer)
    for j = 1: length(dataName)
%         sensors with odd number index are considered as agonist
%         sensors with even number index are considered as antagonist
        if(contains(dataName(j).name, answer{i}))
            counter1 = counter1 + 1;
            muscle{counter1} = [time{j} data{j}];
%         elseif (contains(dataName(j).name, answer{2 * i}))
%             counter2 = counter2 + 1;
%             muscle2{counter2} = [time{j} data{j}];
        end
    end
    sensorName{i} = answer{i};
end


    