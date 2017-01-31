data = csvread('Right_Bicep_Data.csv');
time = (0:1:length(data(:,1)) - 1)';
figure()
subplot(2,1,1)
plot(time, data(:,1))
subplot(2,1,2)
plot(time, data(:,2))