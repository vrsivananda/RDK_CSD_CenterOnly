function plotMuSummary(psyMu20, psyMu100, CSDMu20, CSDMu100)

% Calculate the means of the data
psyMu20Mean = mean(psyMu20);
psyMu100Mean = mean(psyMu100);
CSDMu20Mean = mean(CSDMu20);
CSDMu100Mean = mean(CSDMu100);

% Calculate the standard error of the data
psyMu20SE = std(psyMu20)/sqrt(length(psyMu20));
psyMu100SE = std(psyMu100)/sqrt(length(psyMu100));
CSDMu20SE = std(CSDMu20)/sqrt(length(CSDMu20));
CSDMu100SE = std(CSDMu100)/sqrt(length(CSDMu100));

% Plot the mean and standard error
plot([1,2,3,4],[psyMu20Mean, psyMu100Mean, CSDMu20Mean, CSDMu100Mean],'Marker','.','MarkerSize',20,'LineWidth',3);
hold on;
errorbar([1,2,3,4],[psyMu20Mean, psyMu100Mean, CSDMu20Mean, CSDMu100Mean],[psyMu20SE,psyMu100SE,CSDMu20SE,CSDMu100SE],'vertical','.','Color','k');

% Set the y-limits
ylim([-0.5,0.5]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4]);
% Get rid of the tick labels
set(gca,'xticklabel',[])

% Print out the values
disp('psyMu20Mean psyMu100Mean CSDMu20Mean CSDMu100Mean');
disp([psyMu20Mean,psyMu100Mean,CSDMu20Mean,CSDMu100Mean]);
disp('psyMu20SE psyMu100SE CSDMu20SE CSDMu100SE');
disp([psyMu20SE,psyMu100SE,CSDMu20SE,CSDMu100SE]);
