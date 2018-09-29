function dPrimesConverged = calculateDPrimeConverged(dataStructure)

% This function takes the last 50 trials of each (center and periphery)
% conditions and calculates the d primes

% Which trial to start analyzing (i.e. where do we assume convergence)
convergenceTrial = 50;

% Get the indices of actual trials
actualTrialIndices = returnIndices(dataStructure.trialType,'actual');

% Get the indices of the correct trials
correctIndices = find(dataStructure.correct == 1);

% Get the indices of the incorrect trials
incorrectIndices = find(dataStructure.correct == 0);

% Get the indices where the RDK was going right
rightIndices = find(dataStructure.coherent_direction == 0);

% Get the indices where the RDK was going left
leftIndices = find(dataStructure.coherent_direction == 180);

%% -------------------- CENTER --------------------

% Get the indices of center trials
actualCenterIndices = intersect(...
    returnIndices(dataStructure.positionType, 'center'),...
    actualTrialIndices);

% The indices for the relevant trial onwards
relevantTrialCenterIndices = actualCenterIndices(convergenceTrial:end);

% --- HR ---
% Signal is Left (180)

% The indices of relevant trials that went left
relevantLeftCenterIndices = intersect(relevantTrialCenterIndices,leftIndices);

% The total number of relevant trials that went left
nRelevantLeftCenter = length(relevantLeftCenterIndices);

% Get the number of trials correct
nLeftCorrectCenter = length(intersect(relevantLeftCenterIndices,correctIndices));

% Get the hit rate
centerHR = nLeftCorrectCenter/nRelevantLeftCenter;

% Fix the rate
centerHR = fixRate(centerHR,nRelevantLeftCenter);

% --- FAR ---
% Noise is Right (0)

% The indices of relevant trials that went right
relevantRightCenterIndices = intersect(relevantTrialCenterIndices,rightIndices);

% The total number of relevant trials that went right
nRelevantRightCenter = length(relevantRightCenterIndices);

% Get the number of trials correct
nRightIncorrectCenter = length(intersect(relevantRightCenterIndices,incorrectIndices));

% Get the hit rate
centerFAR = nRightIncorrectCenter/nRelevantRightCenter;

% Fix the rate
centerFAR = fixRate(centerFAR,nRelevantRightCenter);

% ------ Calculate d' for Center ------

dPrimeCenter = norminv(centerHR) - norminv(centerFAR);




%% -------------------- PERIPHERY --------------------

% Get the indices of periphery trials
actualPeripheryIndices = intersect(...
    returnIndices(dataStructure.positionType, 'periphery'),...
    actualTrialIndices);

% The indices for the relevant trial onwards
relevantTrialPeripheryIndices = actualPeripheryIndices(convergenceTrial:end);

% --- HR ---
% Signal is Left (180)

% The indices of relevant trials that went left
relevantLeftPeripheryIndices = intersect(relevantTrialPeripheryIndices,leftIndices);

% The total number of relevant trials that went left
nRelevantLeftPeriphery = length(relevantLeftPeripheryIndices);

% Get the number of trials correct
nLeftCorrectPeriphery = length(intersect(relevantLeftPeripheryIndices,correctIndices));

% Get the hit rate
peripheryHR = nLeftCorrectPeriphery/nRelevantLeftPeriphery;

% Fix the rate
peripheryHR = fixRate(peripheryHR,nRelevantLeftPeriphery);


% --- FAR ---
% Noise is Right (0)

% The indices of relevant trials that went right
relevantRightPeripheryIndices = intersect(relevantTrialPeripheryIndices,rightIndices);

% The total number of relevant trials that went right
nRelevantRightPeriphery = length(relevantRightPeripheryIndices);

% Get the number of trials correct
nRightIncorrectPeriphery = length(intersect(relevantRightPeripheryIndices,incorrectIndices));

% Get the hit rate
peripheryFAR = nRightIncorrectPeriphery/nRelevantRightPeriphery;

% Fix the rate
peripheryFAR = fixRate(peripheryFAR,nRelevantRightPeriphery);

% ------ Calculate d' for Center ------

dPrimePeriphery = norminv(peripheryHR) - norminv(peripheryFAR);


%% -------------------- Return both d' --------------------

dPrimesConverged =  [dPrimeCenter;...
                     dPrimePeriphery];




end
