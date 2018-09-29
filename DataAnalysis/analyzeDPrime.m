function analyzeDPrime(dPrimeCenter, dPrimePeriphery)

% Parameters
barColor = [0.7, 0.7, 0.7];
minX = 0;
maxX = 3;

% Means
meanCenter = mean(dPrimeCenter);
meanPeriphery = mean(dPrimePeriphery);

% SD
sdCenter = std(dPrimeCenter);
sdPeriphery = std(dPrimePeriphery);

% n
nCenter = length(dPrimeCenter);
nPeriphery = length(dPrimePeriphery);

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
ylabel('d''');
xlim([minX maxX]);
ylim([1 2]);

% -------  t-test -------

[h,p,ci,stats] = ttest(dPrimeCenter, dPrimePeriphery)


end