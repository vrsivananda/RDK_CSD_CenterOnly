function plotSigmaData(psySigma20, psySigma100, CSDSigma20, CSDSigma100)

% Declare a cellarray to hold the legend
legendCellArray = cell(length(psySigma20),1);

% Loop through the data of each participant
for i = 1:length(psySigma20)
   
    % Plot the data
    plot([1,2,3,4],[psySigma20(i), psySigma100(i), CSDSigma20(i), CSDSigma100(i)],'Marker','.','MarkerSize',5,'LineWidth',0.5);
    legendCellArray{i} = ['Subject: ' num2str(i)];
    hold on;
    
end

% Set the legend
%legend(legendCellArray,'location','northeast');

% Set the y-limits
ylim([-0.5,3.5]);
% Set the x-limits
xlim([0,5]);
% Specify where to show the tick
xticks([1,2,3,4]);
% Get rid of the tick labels
set(gca,'xticklabel',[])
