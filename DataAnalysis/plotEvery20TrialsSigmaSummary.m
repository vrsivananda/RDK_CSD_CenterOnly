function plotEvery20TrialsSigmaSummary(Sigma20, Sigma40, Sigma60, Sigma80, Sigma100)

% Calculate the means of the data
Sigma20Mean = mean(Sigma20);
Sigma40Mean = mean(Sigma40);
Sigma60Mean = mean(Sigma60);
Sigma80Mean = mean(Sigma80);
Sigma100Mean = mean(Sigma100);

% Calculate the standard error of the data
Sigma20SE = std(Sigma20)/sqrt(length(Sigma20));
Sigma40SE = std(Sigma40)/sqrt(length(Sigma40));
Sigma60SE = std(Sigma60)/sqrt(length(Sigma60));
Sigma80SE = std(Sigma80)/sqrt(length(Sigma80));
Sigma100SE = std(Sigma100)/sqrt(length(Sigma100));

% Plot the mean and standard error
plot([1,2,3,4,5],[Sigma20Mean, Sigma40Mean, Sigma60Mean, Sigma80Mean, Sigma100Mean],'Marker','.','MarkerSize',20,'LineWidth',3);
hold on;
errorbar([1,2,3,4,5],[Sigma20Mean, Sigma40Mean, Sigma60Mean, Sigma80Mean, Sigma100Mean],[Sigma20SE,Sigma40SE,Sigma60SE,Sigma80SE,Sigma100SE],'vertical','.','Color','k');

% Set the y-limits
ylim([0,1]);
% Set the x-limits
xlim([0,6]);
% Specify where to show the tick
xticks([1,2,3,4,5]);
% Get rid of the tick labels
set(gca,'xticklabel',[])

% Print out the values
disp('Sigma20Mean Sigma40Mean Sigma60Mean Sigma80Mean Sigma100Mean');
disp([Sigma20Mean,Sigma40Mean,Sigma60Mean,Sigma80Mean,Sigma100Mean]);
disp('Sigma20SE Sigma40SE Sigma60SE Sigma80SE Sigma100SE');
disp([Sigma20SE,Sigma40SE,Sigma60SE,Sigma80SE,Sigma100SE]);