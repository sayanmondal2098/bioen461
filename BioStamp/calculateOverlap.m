x = 0:0.1:50;
y1 = abs(sin(x));
y2 = abs(cos(x));
figure()
plot(x, y1), hold on
plot(x, y2), hold on

% area1 = trapz(x,y1);
% area2 = trapz(x,y2);
overlapPoint = zeros(length(x),1);
for i = 1:length(x)
    overlapPoint(i) = min(y1(i),y2(i));
end
overlapArea = trapz(x,overlapPoint);
area(x, overlapPoint);

window = 0.5;
numbin = x(end) / window;
for i = 1:numbin
    area1 = trapz(x(1 + 5*(i-1):5*i), y1(1 + 5*(i-1):5*i));
    area2 = trapz(x(1 + 5*(i-1):5*i), y2(1 + 5*(i-1):5*i));
    commonarea(i) = max(area1,area2) - (max(area1,area2) - min(area1,area2));
    coContraction(i) = 200 * commonarea(i) / (area1 + area2);
end

avgCoContraction = sum(coContraction) / numbin;

