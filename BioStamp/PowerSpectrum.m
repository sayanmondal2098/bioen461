% Larry To
% Created 10/31/2016
% Generates power spectrum of EMG data 
% Process data with high pass filter and rectification
% pre: require raw EMG data and its sampling rate 
function [f, P1] = PowerSpectrum(unprocEMG, Fs)

%% Signal Processing

% high-pass filter 
cutoff = 20; % 40 Hz
[b, a] = butter(4, cutoff/(Fs/2),'high');

% Implementing data processing
%   Filter 
highFiltData = filtfilt(b, a, unprocEMG); % High pass
recData = abs(highFiltData); % Rectfication

%% Generate power spectrum
Y = fft(recData);
L = length(recData);
P2 = abs(Y/L);
if (mod(L,2) ~= 0)
    P1 = P2(1:(L-1)/2+1);
    f = Fs*(0:(L-1)/2)/L;
else
    P1 = P2(1:L/2+1);
    f = Fs*(0:(L/2))/L;
end
P1(2:end-1) = 2*P1(2:end-1);






