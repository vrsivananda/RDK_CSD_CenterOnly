function plotSigmaSummary(psySigma20, psySigma100, CSDSigma20, CSDSigma100)

% Calculate the means of the data
psySigma20Mean = mean(psySigma20);
psySigma100Mean = mean(psySigma100);
CSDSigma20Mean = mean(CSDSigma20);
CSDSigma100Mean = mean(CSDSigma100);

%Calculate the standard error of the data
psySigma20SE = std(psySigma20)/sqrt(length(psySigma20));
psySigma100SE = std(psySigma100)/sqrt(length(psySigma100));
CSDSigma20SE = std(CSDSigma20)/sqrt(length(CSDSigma20));
CSDSigma100SE = std(CSDSigma100)/sqrt(length(CSDSigma100));

% Plot the mean and standard error
plot([1,2,3,4],[psySigma20Mean, psySigma100Mean, CSDSigma20Mean, CSDSigma100Mean],'Marker','.','MarkerSize',20,'LineWidth',3);
hold on;
errorbar([1,2,3,4],[psySigma20Mean, psySigma100Mean, CSDSigma20Mean, CSDSigma100Mean],[psySigma20SE,psySigma100SE,CSDSigma20SE,CSDSigma100SE],'vertical','.','Color','k');

% Set the y-limits
ylim([0,1]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4,5]);
% Get rid of the tick labels
set(gca,'xticklabel',[])

% Print out the values
disp('psySigma20Mean psySigma100Mean CSDSigma20Mean CSDSigma100Mean');
disp([psySigma20Mean,psySigma100Mean,CSDSigma20Mean,CSDSigma100Mean]);
disp('psySigma20SE psySigma100SE CSDSigma20SE CSDSigma100SE');
disp([psySigma20SE,psySigma100SE,CSDSigma20SE,CSDSigma100SE]);