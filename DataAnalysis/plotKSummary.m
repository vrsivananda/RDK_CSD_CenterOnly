function plotKSummary(CSDK20, CSDK100)

% Calculate the means of the data
CSDK20Mean = mean(CSDK20);
CSDK100Mean = mean(CSDK100);

%Calculate the standard error of the data
CSDK20SE = std(CSDK20)/sqrt(length(CSDK20));
CSDK100SE = std(CSDK100)/sqrt(length(CSDK100));

% Plot the mean and standard error
plot([3,4],[CSDK20Mean, CSDK100Mean],'Marker','.','MarkerSize',20,'LineWidth',3);
hold on;
errorbar([3,4],[CSDK20Mean, CSDK100Mean],[CSDK20SE,CSDK100SE],'vertical','.','Color','k');

% Set the y-limits
ylim([0,35]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4]);
% Get rid of the tick labels
set(gca,'xticklabel',[])

% Print out the values
disp('CSDK20Mean CSDK100Mean');
disp([CSDK20Mean,CSDK100Mean]);
disp('CSDK20SE CSDK100SE');
disp([CSDK20SE,CSDK100SE]);
