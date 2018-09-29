function confidences = calculateConfidence(dataStructure)

% This function calculates the avearage confidence across center and
% periphery RDKs

% Get the indices of actual trials
actualTrialIndices = returnIndices(dataStructure.trialType,'actual');

% -------------------- CENTER --------------------

% Get the indices of center trials
centerIndices = returnIndices(dataStructure.positionType, 'center');

% Get the indices of actual center trials
actualCenterIndices = intersect(actualTrialIndices,centerIndices);

% Get the confidences of the actual and center trials
centerConfidence = dataStructure.sim_score(actualCenterIndices);

% Flip around the sim score where the participant states that it is going
% left (e.g. if they reponded with 23, then we flip to be 77)

% For loop that goes through all the elements and flips them around if they
% are less than 50
for i = 1:length(centerConfidence)
    
    % If the sim score is less than 50
    if(centerConfidence(i) < 50)
        
        % Calculate the distance from 50
        distanceFrom50 = 50 - centerConfidence(i);
        
        % Add 50 to it and replace the old value
        centerConfidence(i) = distanceFrom50 + 50;
        
    end % End of if
    
end % End of for loop

% Calculate the mean
meanConfidenceCenter = mean(centerConfidence);

% -------------------- PERIPHERY --------------------

% Get the indices of periphery trials
peripheryIndices = returnIndices(dataStructure.positionType, 'periphery');

% Get the indices of actual periphery trials
actualPeripheryIndices = intersect(actualTrialIndices,peripheryIndices);

% Get the confidences of the actual and periphery trials
peripheryConfidence = dataStructure.sim_score(actualPeripheryIndices);

% Flip around the sim score where the participant states that it is going
% left (e.g. if they reponded with 23, then we flip to be 77)

% For loop that goes through all the elements and flips them around if they
% are less than 50
for i = 1:length(peripheryConfidence)
    
    % If the sim score is less than 50
    if(peripheryConfidence(i) < 50)
        
        % Calculate the distance from 50
        distanceFrom50 = 50 - peripheryConfidence(i);
        
        % Add 50 to it and replace the old value
        peripheryConfidence(i) = distanceFrom50 + 50;
        
    end % End of if
    
end % End of for loop

% Calculate the mean
meanConfidencePeriphery = mean(peripheryConfidence);

% -------------------- Return both confidences --------------------

confidences =  [meanConfidenceCenter;...
                meanConfidencePeriphery];

end