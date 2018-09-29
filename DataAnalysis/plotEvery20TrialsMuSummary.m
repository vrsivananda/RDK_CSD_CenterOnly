function plotEvery20TrialsMuSummary(Mu20, Mu40, Mu60, Mu80, Mu100)

% Calculate the means of the data
Mu20Mean = mean(Mu20);
Mu40Mean = mean(Mu40);
Mu60Mean = mean(Mu60);
Mu80Mean = mean(Mu80);
Mu100Mean = mean(Mu100);

% Calculate the standard error of the data
Mu20SE = std(Mu20)/sqrt(length(Mu20));
Mu40SE = std(Mu40)/sqrt(length(Mu40));
Mu60SE = std(Mu60)/sqrt(length(Mu60));
Mu80SE = std(Mu80)/sqrt(length(Mu80));
Mu100SE = std(Mu100)/sqrt(length(Mu100));

% Plot the mean and standard error
plot([1,2,3,4,5],[Mu20Mean, Mu40Mean, Mu60Mean, Mu80Mean, Mu100Mean],'Marker','.','MarkerSize',20,'LineWidth',3);
hold on;
errorbar([1,2,3,4,5],[Mu20Mean, Mu40Mean, Mu60Mean, Mu80Mean, Mu100Mean],[Mu20SE,Mu40SE,Mu60SE,Mu80SE,Mu100SE],'vertical','.','Color','k');

% Set the y-limits
ylim([-0.5,0.5]);
% Set the x-limits
xlim([0,6]);
% Specify where to show the tick
xticks([1,2,3,4,5]);
% Get rid of the tick labels
set(gca,'xticklabel',[])

% Print out the values
disp('Mu20Mean Mu40Mean Mu60Mean Mu80Mean Mu100Mean');
disp([Mu20Mean,Mu40Mean,Mu60Mean,Mu80Mean,Mu100Mean]);
disp('Mu20SE Mu40SE Mu60SE Mu80SE Mu100SE');
disp([Mu20SE,Mu40SE,Mu60SE,Mu80SE,Mu100SE]);