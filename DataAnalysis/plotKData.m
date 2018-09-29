function plotKData(CSDK20, CSDK100)

% Declare a cellarray to hold the legend
legendCellArray = cell(length(CSDK20),1);

% Loop through the data of each participant
for i = 1:length(CSDK20)
   
    % Plot the data
    plot([3,4],[CSDK20(i), CSDK100(i)],'Marker','.','MarkerSize',5,'LineWidth',0.5);
    legendCellArray{i} = ['Subject: ' num2str(i)];
    hold on;
    
end

% Set the legend
%legend(legendCellArray,'location','northwest');

% Set the y-limits
ylim([-0.5,10.5]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4]);
% Get rid of the tick labels
set(gca,'xticklabel',[])
