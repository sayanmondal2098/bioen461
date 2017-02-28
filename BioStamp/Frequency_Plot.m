close all, clear all
% LOAD DATA
% [Name Path] = uigetfile('.csv','Select EMG file');
% Path = 'U:\long term EMG\BioStamp\Data\subject_0001\studies\larry_s_test\subjects\0001\sensors\d5la7xn8\recordings\2016-09-30T21-20-41-228Z\sensors\';
% Name = 'emg.csv';
% EMGData=csvread([Path Name],1,0); % trims header
% 
% % TIMESTAMP TO Ms
% startTsMs = min(EMGData(:,1));
% tMs = EMGData(:,1) - startTsMs;  % sets start time as 0ms instead of time of day
% v = EMGData(:,2); % unpack EMG data as v
% fs = 1 / ((tMs(2)-tMs(1))/1000);
% 
% %% Creating Frequency Spectrum
% T = 1/fs;             % Sampling period
% L = length(v);             % Length of signal 
% 
% freqData = fft(v);
% P2 = abs(freqData/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = fs*(0:(L/2))/L;
% figure()
% plot(f(10:end),P1(10:end))
% title('Frequency Plot') 
% ylabel('|P(f)|')
% xlabel('Frequency')
% 
% 
% procData = ProcessEMG(v,fs);
% freqDataNew = fft(procData);
% P2New = abs(freqDataNew/L);
% P1New = P2New(1:L/2+1);
% P1New(2:end-1) = 2*P1New(2:end-1);
% figure()
% plot(f(10:end),P1New(10:end))
% title('Filtered Frequency Plot')
% ylabel('|P(f)|')
% xlabel('Frequency')
% 
% 
% 
% 
% %% 
clear all, close all

Path{1} = 'U:\long term EMG\BioStamp\Data\Compare_Sam_Freq\studies(250 Hz)\larry_s_test__250_hz_\subjects\0001\sensors\d5la7xn8\recordings\2016-10-07T20-21-24-730Z\sensors\';
Path{2} = 'U:\long term EMG\BioStamp\Data\Compare_Sam_Freq\studies(500 Hz)\larry_s_test__500_hz_\subjects\0001\sensors\d5la7xn8\recordings\2016-10-07T20-11-23-491Z\sensors\';
Path{3} = 'U:\long term EMG\BioStamp\Data\Compare_Sam_Freq\studies(1000 Hz)\larry_s_test__1000_hz_\subjects\0001\sensors\d5la7xn8\recordings\2016-10-07T19-58-38-019Z\sensors\';
Name = 'emg.csv';

for i = 1:3
    data{i} = csvread([Path{i} Name], 1, 0);
    
    % TIMESTAMP TO Ms
    startTsMs = min(data{i}(:,1));
    tMs{i} = data{i}(:,1) - startTsMs;  % sets start time as 0ms instead of time of day
    EMG{i} = data{i}(:,2); % unpack EMG data as v
    fs(i) = 1 / ((tMs{i}(2)-tMs{i}(1))/1000);
    
    % Process Data
    procData{i} = ProcessEMG(EMG{i},fs(i));
end


%% Creating Frequency Spectrum
fs = [250 500 1000];

figure()
for i = 1:3
    T(i) = 1/fs(i);             % Sampling period
    L(i) = length(EMG{i});             % Length of signal 

    freqData{i} = fft(procData{i});
    P2{i} = abs(freqData{i}/L(i));
    P1{i} = P2{i}(1:L(i)/2+1);
    P1{i}(2:end-1) = 2*P1{i}(2:end-1);
    f{i} = fs(i)*(0:(L(i)/2))/L(i);
    
    plot(f{i}(10:end),P1{i}(10:end)), hold on



%     procData = ProcessEMG(v,fs);
%     freqDataNew = fft(procData);
%     P2New = abs(freqDataNew/L);
%     P1New = P2New(1:L/2+1);
%     P1New(2:end-1) = 2*P1New(2:end-1);
%     figure()
%     plot(f(10:end),P1New(10:end))
%     title('Filtered Frequency Plot')
%     ylabel('|P(f)|')
%     xlabel('Frequency')
end

    legend('250','500','1000')
    title('Frequency Plot') 
    ylabel('|P(f)|')
    xlabel('Frequency')




