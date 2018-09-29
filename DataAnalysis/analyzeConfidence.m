function analyzeConfidence(confidenceCenter, confidencePeriphery)

% Parameters
barColor = [0.7, 0.7, 0.7];
minX = 0;
maxX = 3;

% Means
meanCenter = mean(confidenceCenter);
meanPeriphery = mean(confidencePeriphery);

% SD
sdCenter = std(confidenceCenter);
sdPeriphery = std(confidencePeriphery);

% n
nCenter = length(confidenceCenter);
nPeriphery = length(confidencePeriphery);

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
ylabel('Confidence rating');
xlim([minX maxX]);
ylim([50 100]);

% -------  t-test -------

[h,p,ci,stats] = ttest(confidenceCenter, confidencePeriphery)


end