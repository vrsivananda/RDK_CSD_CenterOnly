function analyzeEndingCoherence(endingCoherence)
    
    % Add path to the beeswarm functions
    addpath('plotSpread/plotSpread');
    
    % Parameters
    barColor = [0.7, 0.7, 0.7];
    
    % Get the number of subjects
    nSubjects = length(endingCoherence);
    
    % Get the stats for the endingCoherence
    endingCoherenceCenterMean = mean(endingCoherence);
    endingCoherenceCenterSD = std(endingCoherence);
    endingCoherenceCenterSEM = endingCoherenceCenterSD/sqrt(nSubjects);
    
    % Plot the bar graph
    figure;
    bar(endingCoherenceCenterMean,'FaceColor',barColor);
    hold on;
    errorbar(1, endingCoherenceCenterMean,endingCoherenceCenterSEM,'.'); % This works when we run only this file
    
    % Format the graph
    set(gca, 'XTickLabel', {'Center'});
    xlabel('');
    ylabel('Ending coherence');
    xlim([0 2]);
    ylim([0 1]);
    
    % Plot the bee swarm
    figure;
    plotSpread({endingCoherence',[0.1900; 0.2100; 0.1567; 0.2000]});
    hold on;
    
end