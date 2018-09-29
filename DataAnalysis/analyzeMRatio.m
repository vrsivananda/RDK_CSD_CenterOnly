function analyzeMRatio(mRatioCenter, mRatioPeriphery)

% Parameters
barColor = [0.7, 0.7, 0.7];
minX = 0;
maxX = 3;

% Means
meanCenter = mean(mRatioCenter);
meanPeriphery = mean(mRatioPeriphery);

% SD
sdCenter = std(mRatioCenter);
sdPeriphery = std(mRatioPeriphery);

% n
nCenter = length(mRatioCenter);
nPeriphery = length(mRatioPeriphery);

% SEM
semCenter = sdCenter/sqrt(nCenter);
semPeriphery = sdPeriphery/sqrt(nPeriphery);

% Plot the bar graph
figure;
bar([meanCenter, meanPeriphery],'FaceColor',barColor);
hold on;
errorbar([1,2],[meanCenter, meanPeriphery],[semCenter, semPeriphery],'.'); % This works when we run only this file

% Format the graph
set(gca, 'XTickLabel', {'Center' 'Periphery'});
xlabel('Condition');
ylabel('M-Ratio');
xlim([minX maxX]);
ylim([0 1]);

% -------  t-test -------

disp('mRatio');
[h,p,ci,stats] = ttest(mRatioCenter, mRatioPeriphery)


end