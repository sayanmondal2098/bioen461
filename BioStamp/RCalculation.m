% Larry To
% Created on 10/28/2016
% Calculate force vector R from the accelorometer data 
function R = RCalculation(accelData)


xData = accelData(:,1);
yData = accelData(:,2);
zData = accelData(:,3);

R = sqrt(xData.^2 + yData.^2 + zData.^2);



end