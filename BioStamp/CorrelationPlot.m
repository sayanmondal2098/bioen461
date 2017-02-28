close all
for i = 1:length(muscle1Corrected)
    for j = 1:min(numBins)
        muscle1Bin{i}(:,j) = muscle1Corrected{i}((j - 1) * timeWindow + 1 : ...
            j * timeWindow, 2);
        muscle2Bin{i}(:,j) = muscle2Corrected{i}((j - 1) * timeWindow + 1 : ...
            j * timeWindow, 2);
        timeBin{i}(:,j) = correctedTime{1}((j - 1) * timeWindow + 1 : j * ...
            timeWindow);
        for k = 1:timeWindow
            overlapPoint_TW(k) = min(muscle1Bin{i}(k, j), muscle2Bin{i}(k, j));
        end
        areaMuscle1(i, j) = trapz(timeBin{i}(:,j), muscle1Bin{i}(:,j));
        areaMuscle2(i, j) = trapz(timeBin{i}(:,j), muscle2Bin{i}(:,j));
        overlapArea_TW(i, j) = trapz(timeBin{i}(:,j), overlapPoint_TW);
        percentCC_TW(i, j) = 200 * overlapArea_TW(i, j) / (areaMuscle1(i, j) ...
            + areaMuscle2(i ,j));
    end
end

for i = 1:length(muscle1)
    figure()
    plot(muscle1{i}(:,2), muscle2{i}(:,2), '.')
    xlim([0 2]), ylim([0 2])
end