data = xlsread('sampleData_Larry');

figure()
subplot(3,1,1)
plot(data(:,1), data(:,2),'r', 'linewidth',1.5)
title('Brachioradialis Trial 1')

subplot(3,1,2)
plot(data(:,3), data(:,4),'r', 'linewidth',1.5)
title('Brachioradialis Trial 2')

subplot(3,1,3)
plot(data(:,5), data(:,6),'r', 'linewidth',1.5)
title('Brachioradialis Trial 3')
xlabel('data point (nth)', 'fontsize', 12)


