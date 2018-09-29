function output = calculateMetaDPrime(dataStructure)

% This function calculates the meta-d' with Brian Maniscalco's toolbox


%% ----------- CENTER -----------

actualCenterIndices = intersect(...
    returnIndices(dataStructure.trialType,'actual'),...
    returnIndices(dataStructure.positionType,'center')...
    );

% --- stimID ---

% The array of size 100x1, with 0 meaning right and 180 meaning left 
actualCenterDirection = dataStructure.coherent_direction(actualCenterIndices);

% The stimID to be fed into the meta-d' toolbox
stimIDCenter = (actualCenterDirection == 180)';
% ^ 
% 0 == 0 == rightwards == S1
% 1 == 180 == leftwards == S2


% --- response ---

% The 100x1 array of the sim scores (proxy for bidirectional confidence)
actualCenterSimScore = dataStructure.sim_score(actualCenterIndices);

% The response to be fed into the meta-d' toolbox
responseCenter = (actualCenterSimScore < 50)';


% --- rating ---

% Array for center ratings
ratingCenter = nan(1,100);

% For loop that goes through the array and allocate the rating
for i = 1:length(actualCenterSimScore)
   
    % Get the score from 50
    scoreFrom50 = abs(actualCenterSimScore(i)-50);
    
    % If it is 12.5 from 50, then rate as 1
    if(scoreFrom50 <= 12.5)
        ratingCenter(i) = 1;
    elseif(scoreFrom50 <= 25)
        ratingCenter(i) = 2;
    elseif(scoreFrom50 <= 37.5)
        ratingCenter(i) = 3;
    elseif(scoreFrom50 <= 50)
        ratingCenter(i) = 4;
    else
        disp('Something wrong here');
    end

end

% --- meta-d' toolbox calculation ---

[nR_S1Center, nR_S2Center] = trials2counts(stimIDCenter, responseCenter, ratingCenter, 4, 1);

fitCenter = fit_meta_d_MLE(nR_S1Center, nR_S2Center);



%% ----------- PERIPHERY -----------

actualPeripheryIndices = intersect(...
    returnIndices(dataStructure.trialType,'actual'),...
    returnIndices(dataStructure.positionType,'periphery')...
    );

% --- stimID ---

% The array of size 100x1, with 0 meaning right and 180 meaning left 
actualPeripheryDirection = dataStructure.coherent_direction(actualPeripheryIndices);

% The stimID to be fed into the meta-d' toolbox
stimIDPeriphery = (actualPeripheryDirection == 180)';
% ^ 
% 0 == 0 == rightwards == S1
% 1 == 180 == leftwards == S2


% --- response ---

% The 100x1 array of the sim scores (proxy for bidirectional confidence)
actualPeripherySimScore = dataStructure.sim_score(actualPeripheryIndices);

% The response to be fed into the meta-d' toolbox
responsePeriphery = (actualPeripherySimScore < 50)';


% --- rating ---

% Array for center ratings
ratingCenter = nan(1,100);

% For loop that goes through the array and allocate the rating
for i = 1:length(actualPeripherySimScore)
   
    % Get the score from 50
    scoreFrom50 = abs(actualPeripherySimScore(i)-50);
    
    % If it is 12.5 from 50, then rate as 1
    if(scoreFrom50 <= 12.5)
        ratingPeriphery(i) = 1;
    elseif(scoreFrom50 <= 25)
        ratingPeriphery(i) = 2;
    elseif(scoreFrom50 <= 37.5)
        ratingPeriphery(i) = 3;
    elseif(scoreFrom50 <= 50)
        ratingPeriphery(i) = 4;
    else
        disp('Something wrong here');
    end

end

% --- meta-d' toolbox calculation ---

[nR_S1Periphery, nR_S2Periphery] = trials2counts(stimIDPeriphery, responsePeriphery, ratingPeriphery, 4, 1);

fitPeriphery = fit_meta_d_MLE(nR_S1Periphery, nR_S2Periphery);


%% ----------- OUTPUT -----------

output = {fitCenter, fitPeriphery};

end