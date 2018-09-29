function plotMuData(psyMu20, psyMu100, CSDMu20, CSDMu100)

% Declare a cellarray to hold the legend
legendCellArray = cell(length(psyMu20),1);

% Loop through the data of each participant
for i = 1:length(psyMu20)
   
    % Plot the data
    plot([1,2,3,4],[psyMu20(i), psyMu100(i), CSDMu20(i), CSDMu100(i)],'Marker','.','MarkerSize',5,'LineWidth',0.5);
    legendCellArray{i} = ['Subject: ' num2str(i)];
    hold on;
    
end

% Set the legend
%legend(legendCellArray,'location','northeast');

% Set the y-limits
ylim([-2,2]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4]);
% Get rid of the tick labels
set(gca,'xticklabel',[])
