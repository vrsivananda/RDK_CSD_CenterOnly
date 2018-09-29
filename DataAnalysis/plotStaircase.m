function plotStaircase(centerArray, peripheryArray, i, subjectId, save)

% If there is no save argument, then don't save it
if(nargin == 4)
   save = 0; 
end

trials = 1:100;

%Parameters
linespec = '- .'; % Formatting for line
width = 2; % Width of line
size = 10; % Size of marker
minY = 0; % Minimum Y axis label
maxY = 1; % Maximum Y axis label
legendFontSize = 18; % Size of the font in the legend


plot(trials, centerArray, linespec, 'LineWidth', width, 'MarkerSize', size);
hold on;
plot(trials, peripheryArray, linespec, 'LineWidth', width, 'MarkerSize', size);
ylim([minY maxY]);
title(['Subject ' num2str(i) ': ' subjectId]);
legendObject = legend('Center','Periphery');
legendObject.FontSize = legendFontSize;

%Save the figure
if(save == 1)
    fileName = [subjectId '_Staircase.png'];
    saveas(gcf,fileName);
end

