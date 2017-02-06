data = xlsread('SampleDataFromEric');

figure()
subplot(2,1,1)
plot(data(:,2),'r', 'linewidth',1.5)
title('Brachioradialis')

subplot(2,1,2)
plot(data(:,4),'r', 'linewidth',1.5)
title('Bicep')
xlabel('data point (nth)', 'fontsize', 15)


