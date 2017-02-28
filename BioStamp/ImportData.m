% Created by: Larry To & Kat Steele
% Date: 11/8/2016
% Read and process biostamp and actigraph data
% REMARK: make sure users must write down the corrspondance of each sensor 
% Data Structure: A large structure separates into annotation,
% accelerometer from BioStamp, EMG from BioStamp and accelerometer from
% actigraph. 
clear all
%% 
% For each participant -- biostamp and actigraph folders
%   Assumes that biostamp folders start with 'd'
% function DATA = data_summary(path)
path = 'U:\long term EMG\BioStamp\Data\Winter_Quarter\0001_Trial4';
% 
% Determine whether directory has biostamp data
bio_path = [path '\biostamp\'];
if isdir(bio_path)
    % Read in annotation data (if exists)
    % Search in bio_path for annotations.csv
    DATA.annot =  readtable([bio_path 'annotations.csv']);
    folders = dir(bio_path);
    n_sensors = 1;
    for i = 1:size(folders,1)
        if folders(i).name(1,1) == 'd' % Find biostamp folder (starts with 'd')
            folderSensor = dir([bio_path folders(i).name]); % Open sensor folder
            
            trialNum = 1;
            for j = 1:size(folderSensor,1)                
                trialName = ['trial_' num2str(trialNum)];
                
                if folderSensor(j).name(1,1) == '2' % Find sensor folder (starts with '201X')
                    folderTrial = dir([bio_path folders(i).name '\' folderSensor(j).name]);
                    trialPath = [bio_path folders(i).name '\' folderSensor(j).name];
                    
                    if exist([trialPath '\accel.csv'],'file') % Find accel data if exists
                        DATA.BIOaccel(n_sensors).name = folders(i).name;
                        DATA.BIOaccel(n_sensors).data{trialNum} = csvread([trialPath '\accel.csv'],1,0);
                    end
                    if exist([trialPath '\emg.csv'],'file') % Find EMG data if exists
                        DATA.EMG(n_sensors).name = folders(i).name;
                        DATA.EMG(n_sensors).data{trialNum} = csvread([trialPath '\emg.csv'],1,0);
                    end                                          
                    trialNum = trialNum + 1;
                end
            end
            n_sensors = n_sensors + 1;
        end
    end
else
    disp('NOTE: No biostamp data in specified folder');
end
%% 
% Determine whether directory has actigraph data
acti_path = [path '\actigraph'];
Name_Right = 'TAS1E52150596RAW.csv';
Name_Left = 'TAS1E52150597RAW.csv';
if isdir(acti_path)
    DATA.ACTaccel.Right = csvread([acti_path '\csv\' Name_Right],11,1,...
        [11 1 1800100 3]);
    DATA.ACTaccel.Left = csvread([acti_path '\csv\' Name_Left],11,1,...
        [11 1 1800100 3]);
else
    disp('NOTE: No actigraph data in specified folder');
end

% end