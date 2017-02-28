dataLarry = xlsread('sampleData_Larry');

figure()
% subplot(3,1,1)
% normalizedData = 5 .* dataLarry(:,2) ./ 1023;
% plot(dataLarry(:,1), normalizedData,'b', 'linewidth',1.5)
% title('Brachioradialis Trial 1')

% subplot(3,1,2)

normalizedData = 5 .* dataLarry(:,4) ./ 1023;
dataAct = find(normalizedData > 0.2);
count = 0;
t1 = [3246 4330 7430 8583 12929 13840];
v1 = normalizedData(t1);
plot(dataLarry(:,3), normalizedData,'b'), hold on
plot(dataLarry(:,3), 0.2 * ones(length(dataLarry(:,3)), 1), 'r')
vline(dataLarry(t1,3))
set(gca,'color','black')
title('Brachioradialis')
xlabel('Time (s)') 
ylabel('Voltage (V)')

% subplot(3,1,3)
% normalizedData = 5 .* dataLarry(:,6) ./ 1023;
% plot(dataLarry(:,5), normalizedData,'b', 'linewidth',1.5)
% title('Brachioradialis Trial 3')
% xlabel('data point (nth)', 'fontsize', 12)
% 

%% 
dataEric = xlsread('sampleData_Eric');

figure()
subplot(2,1,1)
plot(dataEric(:,1), dataEric(:,2),'r', 'linewidth',1.5)
title('Bicep ')

subplot(2,1,2)
plot(dataEric(:,3), dataEric(:,4),'r', 'linewidth',1.5)
title('Brachioradialis')

%% Recognizing Activation 
% Using Larry's Data: the first trial will be a training set to create
% regonization parameters to identify muscle activation. The second and
% third trials will be used as experimental sets 

% In 1st trial,
% 1st activation happens at 21-31 sec
% MVCData = max(prctile(dataLarry(:,2)








