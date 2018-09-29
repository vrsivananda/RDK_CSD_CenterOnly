function dPrimes = calculateDPrime(dataStructure)

% This function calculates the d' for the subject by ignoring the coherence
% and taking the Hits and False Alarms from throughout the trials

% Get the indices of actual trials
actualTrialIndices = returnIndices(dataStructure.trialType,'actual');

% Get the indices of the correct trials
correctIndices = find(dataStructure.correct == 1);

% Get the indices of the incorrect trials
incorrectIndices = find(dataStructure.correct == 0);

% -------------------- CENTER --------------------

% Get the indices of center trials
centerIndices = returnIndices(dataStructure.positionType, 'center');

% --- HR ---

% Get the indices where the RDK was going left
leftIndices = find(dataStructure.coherent_direction == 180);

% Intersect left + actual + center to get the indices of actual trials that
% were going left and RDK is in the center
actualCenterLeftIndices = intersect(intersect(actualTrialIndices,centerIndices), leftIndices);

% Intersect them all to find the indices of actual trials where the RDK is
% in the center, going left, and is correct
actualCenterLeftCorrectIndices = intersect(actualCenterLeftIndices, correctIndices);

% Get the number of correct left trials
nCorrectCenterLeft = length(actualCenterLeftCorrectIndices);

% Get the number of total left trials
nTotalCenterLeft = length(actualCenterLeftIndices);

% Calculate the Hit Rate == P(Left Response | Left RDK)
centerHR = nCorrectCenterLeft/nTotalCenterLeft;

% --- FAR ---

% Get the indices where the RDK was going right
rightIndices = find(dataStructure.coherent_direction == 0);

% Intersect right + actual + center to get the indices of actual trials that
% were going right and RDK is in the center
actualCenterRightIndices = intersect(intersect(actualTrialIndices,centerIndices), rightIndices);

% Intersect them all to find the indices of actual trials where the RDK is
% in the center, going left, and is incorrect
actualCenterRightIncorrectIndices = intersect(actualCenterRightIndices, incorrectIndices);

% Get the number of correct left trials
nIncorrectCenterRight = length(actualCenterRightIncorrectIndices);

% Get the number of total left trials
nTotalCenterRight = length(actualCenterRightIndices);

% Calculate the False Alarm Rate == P(Left Response | Right RDK)
centerFAR = nIncorrectCenterRight/nTotalCenterRight;

% ------ Calculate d' for Center ------

dPrimeCenter = norminv(centerHR) - norminv(centerFAR);


% -------------------- PERIPHERY --------------------

% Get the indices of periphery trials
peripheryIndices = returnIndices(dataStructure.positionType, 'periphery');

% --- HR ---

% Get the indices where the RDK was going left
leftIndices = find(dataStructure.coherent_direction == 180);

% Intersect left + actual + periphery to get the indices of actual trials that
% were going left and RDK is in the periphery
actualPeripheryLeftIndices = intersect(intersect(actualTrialIndices,peripheryIndices), leftIndices);

% Intersect them all to find the indices of actual trials where the RDK is
% in the periphery, going left, and is correct
actualPeripheryLeftCorrectIndices = intersect(actualPeripheryLeftIndices, correctIndices);

% Get the number of correct left trials
nCorrectPeripheryLeft = length(actualPeripheryLeftCorrectIndices);

% Get the number of total left trials
nTotalPeripheryLeft = length(actualPeripheryLeftIndices);

% Calculate the Hit Rate == P(Left Response | Left RDK)
peripheryHR = nCorrectPeripheryLeft/nTotalPeripheryLeft;

% --- FAR ---

% Get the indices where the RDK was going right
rightIndices = find(dataStructure.coherent_direction == 0);

% Intersect right + actual + periphery to get the indices of actual trials that
% were going right and RDK is in the periphery
actualPeripheryRightIndices = intersect(intersect(actualTrialIndices,peripheryIndices), rightIndices);

% Intersect them all to find the indices of actual trials where the RDK is
% in the periphery, going left, and is incorrect
actualPeripheryRightIncorrectIndices = intersect(actualPeripheryRightIndices, incorrectIndices);

% Get the number of correct left trials
nIncorrectPeripheryRight = length(actualPeripheryRightIncorrectIndices);

% Get the number of total left trials
nTotalPeripheryRight = length(actualPeripheryRightIndices);

% Calculate the False Alarm Rate == P(Left Response | Right RDK)
peripheryFAR = nIncorrectPeripheryRight/nTotalPeripheryRight;

% ------ Calculate d' for Periphery ------

dPrimePeriphery = norminv(peripheryHR) - norminv(peripheryFAR);

% -------------------- Return both d' --------------------

dPrimes =  [dPrimeCenter;...
            dPrimePeriphery];


end