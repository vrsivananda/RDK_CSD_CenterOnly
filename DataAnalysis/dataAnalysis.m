close all;
clear;

% Switch parameters
saveStaircase = 0;

% Add the path to the data folder so that MATLAB can access it
addpath([pwd '/Data']);
addpath([pwd '/MatlabCSD']);

% Create a path to the text file with all the subjects
path='RDKCenterVsPeriphery_Subjects_All.txt';
% Make an ID for the subject list file
subjectListFileId=fopen(path);
% Read in the number from the subject list
numberOfSubjects = fscanf(subjectListFileId,'%d');

%-----Prepare arrays to store data-----

% Store for age and gender
ages = [];
genders = '';

% Store for ending center coherence
endingCoherence = [];

% Store for d'
dPrimeCenter = [];
dPrimePeriphery = [];

% Store for d' converged
dPrimeConvergedCenter = [];
dPrimeConvergedPeriphery = [];

% Store for c
confidenceCenter = [];
confidencePeriphery = [];

% Store for c converged
confidenceConvergedCenter = [];
confidenceConvergedPeriphery = [];

% Store for meta-d'
mRatioCenter = [];
mRatioPeriphery = [];

% Store for Psy Mu
centerPsyMu20 = [];
peripheryPsyMu20 = [];
centerPsyMu40 = [];
peripheryPsyMu40 = [];
centerPsyMu60 = [];
peripheryPsyMu60 = [];
centerPsyMu80 = [];
peripheryPsyMu80 = [];
centerPsyMu100 = [];
peripheryPsyMu100 = [];

% Store for CSD Mu
centerCSDMu20 = [];
peripheryCSDMu20 = [];
centerCSDMu40 = [];
peripheryCSDMu40 = [];
centerCSDMu60 = [];
peripheryCSDMu60 = [];
centerCSDMu80 = [];
peripheryCSDMu80 = [];
centerCSDMu100 = [];
peripheryCSDMu100 = [];

% Store for Psy Sigma
centerPsySigma20 = [];
peripheryPsySigma20 = [];
centerPsySigma40 = [];
peripheryPsySigma40 = [];
centerPsySigma60 = [];
peripheryPsySigma60 = [];
centerPsySigma80 = [];
peripheryPsySigma80 = [];
centerPsySigma100 = [];
peripheryPsySigma100 = [];

% Store for CSD Mu
centerCSDSigma20 = [];
peripheryCSDSigma20 = [];
centerCSDSigma40 = [];
peripheryCSDSigma40 = [];
centerCSDSigma60 = [];
peripheryCSDSigma0 = [];
centerCSDSigma80 = [];
peripheryCSDSigma80 = [];
centerCSDSigma100 = [];
peripheryCSDSigma100 = [];

% Store for CSD K
centerCSDK20 = [];
peripheryCSDK20 = [];
centerCSDK40 = [];
peripheryCSDK40 = [];
centerCSDK60 = [];
peripheryCSDK60 = [];
centerCSDK80 = [];
peripheryCSDK80 = [];
centerCSDK100 = [];
peripheryCSDK100 = [];

%-----Prepare variables to keep track of discarded data-----

% General counter for discarded subjects
nDiscardedSubjects = 0;

% Discarded because did not get enough practice trials correct
nDiscardedPracticeTrials = 0;
discardedPracticeTrialsSubjectId = {};

% Discarded because incomplete data
nDiscardedIncompleteData = 0;
discardedIncompleteDataSubjectId = {};

% Discarded because curve did not meet criterion
nDiscardedBadCurve = 0;
discardedBadCurveSubjectId = {};

% Counter for valid subjects
nValidSubjects = 0;

%-----Prepare variable to store data to test JS CSD-----
actualCenterFixedCoherenceForJSCSD = [];
actualCenterConfidenceJudgmentForJSCSD = [];

actualPeripheryFixedCoherenceForJSCSD = [];
actualPeripheryConfidenceJudgmentForJSCSD = [];

%----Start looping and get the values----

for i = 1:numberOfSubjects
    
    % Read the subject ID from the file, stop after each line
    subjectId = fscanf(subjectListFileId,'%s',[1 1]);
    % Print out the subject ID
    fprintf('subject: %s\n',subjectId);
    
    % Import the data
    Alldata = load(['structure_data_' subjectId '.mat']);
    dataStructure = Alldata.data;
    
    %---------------------%
    %   Practice trials   %
    %---------------------%
    
    % Get the indices of the easy practice trials
    easyPracticeTrialsArrayIndices = returnIndices(dataStructure.difficulty, 'easy');
    % Use the indices to get the array of whether they got it correct, and then
    % sum them up.
    numberOfCorrectEasyPracticeTrials = sum(dataStructure.correct(easyPracticeTrialsArrayIndices));
    disp(['numberOfCorrectPracticeTrials: ' num2str(numberOfCorrectEasyPracticeTrials)]);
    
    % GATEKEEPER #1
    % Only run the rest if the number of correct trials is 8 and above (i.e. above 7)
    if(numberOfCorrectEasyPracticeTrials < 8)
        
        %If less than 8, we increment the counters and save the subjectID
        nDiscardedSubjects = nDiscardedSubjects + 1;
        nDiscardedPracticeTrials = nDiscardedPracticeTrials + 1;
        discardedPracticeTrialsSubjectId{length(discardedPracticeTrialsSubjectId)+1,1} = subjectId;
        
    % Else, we run the analysis
    else
        
        %---------------------%
        %      Coherence      %
        %---------------------%
        
        % Get indices of the actual trials
        actualTrialIndices = returnIndices(dataStructure.trialType,'actual');
        
        % ----CENTER----
        
        % Get the indices for the center
        centerIndices = returnIndices(dataStructure.positionType, 'center');
        
        % Get the intersection of two arrays as the actual and center trial indices
        actualCenterSimIndices = intersect(actualTrialIndices,centerIndices);
        
        % Minus 1 to all the indices to match up with the RDK indices
        actualCenterRDKIndices = actualCenterSimIndices - 1;
        
        % Index out the center coherences
        actualCenterCoherence = returnValues(dataStructure.coherence, actualCenterRDKIndices);
        
        % ----PERIPHERY----
        
        % Get the indices for the periphery
        peripheryIndices = returnIndices(dataStructure.positionType, 'periphery');
        
        % Get the intersection of two arrays as the actual and periphery trial indices
        actualPeripherySimIndices = intersect(actualTrialIndices,peripheryIndices);
        
        % Minus 1 to all the indices to match up with the RDK indices
        actualPeripheryRDKIndices = actualPeripherySimIndices - 1;
        
        % Index out the periphery coherences
        actualPeripheryCoherence = returnValues(dataStructure.coherence, actualPeripheryRDKIndices);
        
        % GATEKEEPER #2
        % If the data is not complete, then we save it in the discard pile.
        if ( length(actualTrialIndices) ~= 200 || any(isnan(actualCenterCoherence)) || any(isnan(actualPeripheryCoherence)) )
            
            %Increment the counters and save the subjectID
            nDiscardedSubjects = nDiscardedSubjects + 1;
            nDiscardedIncompleteData = nDiscardedIncompleteData + 1;
            discardedIncompleteDataSubjectId{length(discardedIncompleteDataSubjectId)+1,1} = subjectId;
            
        % Else we run the analysis
        else
           
            % ----PLOT----
            
            % Plot a staircase
            figure;
%             plotStaircase(actualCenterCoherence,actualPeripheryCoherence, i, subjectId, saveStaircase);
            
            %---------------------%
            %         CSD         %
            %---------------------%
            
            % ----CENTER----
            
            % Get the sim score for the center and divide by 100 to get range of 0 to 1
            actualCenterConfidenceJudgment = dataStructure.sim_score(actualCenterSimIndices)./100;
            
            % Get the binary form of the sim score
            actualCenterBinaryChoice = (actualCenterConfidenceJudgment > 0.5);
            
            % Get the coherent directions of the actual center trials
            actualCenterCoherentDirection = dataStructure.coherent_direction(actualCenterRDKIndices);
            
            % Fix the coherence array such that leftward direction is negative
            actualCenterFixedCoherence = fixCoherence(actualCenterCoherence, (actualCenterCoherentDirection == 180));
            
            % Invoke the CSD for 20 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            centerCSD20Trials = startCSD(actualCenterFixedCoherence(1:20), actualCenterConfidenceJudgment(1:20));
            
            % Invoke the CSD for 40 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            centerCSD40Trials = startCSD(actualCenterFixedCoherence(1:40), actualCenterConfidenceJudgment(1:40));
            
            % Invoke the CSD for 60 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            centerCSD60Trials = startCSD(actualCenterFixedCoherence(1:60), actualCenterConfidenceJudgment(1:60));
            
            % Invoke the CSD for 80 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            centerCSD80Trials = startCSD(actualCenterFixedCoherence(1:80), actualCenterConfidenceJudgment(1:80));

            % Invoke the CSD for 100 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            centerCSD100Trials = startCSD(actualCenterFixedCoherence, actualCenterConfidenceJudgment);
            
            
            % ----PERIPHERY----
            
            % Get the sim score for the periphery and divide by 100 to get range of 0 to 1
            actualPeripheryConfidenceJudgment = dataStructure.sim_score(actualPeripherySimIndices)./100;
            
            % Get the binary form of the sim score
            actualPeripheryBinaryChoice = (actualPeripheryConfidenceJudgment > 0.5);
            
            % Get the coherent directions of the actual periphery trials
            actualPeripheryCoherentDirection = dataStructure.coherent_direction(actualPeripheryRDKIndices);
            
            % Fix the coherence array such that leftward direction is negative
            actualPeripheryFixedCoherence = fixCoherence(actualPeripheryCoherence, (actualPeripheryCoherentDirection == 180));
            
            % Invoke the CSD for 20 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            peripheryCSD20Trials = startCSD(actualPeripheryFixedCoherence(1:20), actualPeripheryConfidenceJudgment(1:20));
            
            % Invoke the CSD for 40 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            peripheryCSD40Trials = startCSD(actualPeripheryFixedCoherence(1:40), actualPeripheryConfidenceJudgment(1:40));
            
            % Invoke the CSD for 60 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            peripheryCSD60Trials = startCSD(actualPeripheryFixedCoherence(1:60), actualPeripheryConfidenceJudgment(1:60));
            
            % Invoke the CSD for 80 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            peripheryCSD80Trials = startCSD(actualPeripheryFixedCoherence(1:80), actualPeripheryConfidenceJudgment(1:80));
            
            % Invoke the CSD for 100 trials
            % Returns [mu, sigma, k, finalMu, finalSigma, finalK]
            peripheryCSD100Trials = startCSD(actualPeripheryFixedCoherence, actualPeripheryConfidenceJudgment);
            
            % Run the tests on our data to see if we need to discard the it
            discardDataCenter20 = discardDataTest(centerCSD20Trials);
            discardDataCenter40 = discardDataTest(centerCSD40Trials);
            discardDataCenter60 = discardDataTest(centerCSD60Trials);
            discardDataCenter80 = discardDataTest(centerCSD80Trials);
            discardDataCenter100 = discardDataTest(centerCSD100Trials);
            discardDataPeriphery20 = discardDataTest(peripheryCSD20Trials);
            discardDataPeriphery40 = discardDataTest(peripheryCSD40Trials);
            discardDataPeriphery60 = discardDataTest(peripheryCSD60Trials);
            discardDataPeriphery80 = discardDataTest(peripheryCSD80Trials);
            discardDataPeriphery100 = discardDataTest(peripheryCSD100Trials);
            
            % GATEKEEPER #3
            % If the values meet our exclusion criteria, then we discard
            % them
            if(discardDataCenter20 || discardDataCenter40 || discardDataCenter60 || discardDataCenter80 || discardDataCenter100 ||...
                    discardDataPeriphery20 || discardDataPeriphery40 || discardDataPeriphery60 || discardDataPeriphery80 || discardDataPeriphery100)  
                %Increment the counters and save the subjectID
                nDiscardedSubjects = nDiscardedSubjects + 1;
                nDiscardedBadCurve = nDiscardedBadCurve + 1;
                discardedBadCurveSubjectId{length(discardedBadCurveSubjectId)+1,1} = subjectId;
                
            % Else we store them in our arrays
            else
            
                % Increment the number of valid subjects counter
                nValidSubjects = nValidSubjects + 1;
                
                % Get the demographic data for the subject
                [ages(nValidSubjects), genders(nValidSubjects)] = getDemographicData(dataStructure);
                
                % Get the ending center coherence of the subject
                endingCoherence(nValidSubjects) = str2num(dataStructure.coherence{max(find(strcmp(dataStructure.positionType,'center')))-1});
                
                %----Calculate d' for the subject----
                
                % Calculate d'
                dPrimes = calculateDPrime(dataStructure);
                % In the form:
                % 1st row: dPrimeCenter
                % 2nd row: dPrimePeriphery
                
                % Save d' data
                dPrimeCenter(length(dPrimeCenter)+1) = dPrimes(1);
                dPrimePeriphery(length(dPrimePeriphery)+1) = dPrimes(2);
                
                %----Calculate d' using converged data for the subject----
                
                % Calculate d' converged
                dPrimesConverged = calculateDPrimeConverged(dataStructure);
                % In the form:
                % 1st row: dPrimeCenter converged
                % 2nd row: dPrimePeriphery converged
                
                % Save d' converged data
                dPrimeConvergedCenter(length(dPrimeConvergedCenter)+1) = dPrimesConverged(1);
                dPrimeConvergedPeriphery(length(dPrimeConvergedPeriphery)+1) = dPrimesConverged(2);
                
                
                %----Calculate confidence for the subject----
                
                % Calculate confidence
                confidences = calculateConfidence(dataStructure);
                % In the form:
                % 1st row: meanConfidenceCenter
                % 2nd row: meanConfidencePeriphery
                
                % Save confidence data
                confidenceCenter(length(confidenceCenter)+1) = confidences(1);
                confidencePeriphery(length(confidencePeriphery)+1) = confidences(2);
                
                
                %----Calculate confidence converged for the subject----
                
                % Calculate confidence converged
                confidencesConverged = calculateConfidenceConverged(dataStructure);
                % In the form:
                % 1st row: meanConfidenceConvergedCenter
                % 2nd row: meanConfidenceConvergedPeriphery
                
                % Save confidence data
                confidenceConvergedCenter(length(confidenceConvergedCenter)+1) = confidencesConverged(1);
                confidenceConvergedPeriphery(length(confidenceConvergedPeriphery)+1) = confidencesConverged(2);
                
                
                %----Calculate meta-d' for the subject----
                
                % Calculate meta-d'
                metaDPrimeCellArray = calculateMetaDPrime(dataStructure);
                
                % Save the meta-d' MRatio data
                mRatioCenter(length(mRatioCenter)+1) = metaDPrimeCellArray{1}.M_ratio;
                mRatioPeriphery(length(mRatioPeriphery)+1) = metaDPrimeCellArray{2}.M_ratio;
                
                
                %----Sava data for JSCSD----
                
                % Center
                actualCenterFixedCoherenceForJSCSD(nValidSubjects,:) = actualCenterFixedCoherence';
                actualCenterConfidenceJudgmentForJSCSD(nValidSubjects,:) = actualCenterConfidenceJudgment';
                
                % Periphery
                actualPeripheryFixedCoherenceForJSCSD(nValidSubjects,:) = actualPeripheryFixedCoherence';
                actualPeripheryConfidenceJudgmentForJSCSD(nValidSubjects,:) = actualPeripheryConfidenceJudgment';
                
                % ----Center----
                
                % Store the Center 20 values in the array
                centerPsyMu20(nValidSubjects,1) = centerCSD20Trials(1);
                centerPsySigma20(nValidSubjects,1) = centerCSD20Trials(2);
                centerCSDMu20(nValidSubjects,1) = centerCSD20Trials(4);
                centerCSDSigma20(nValidSubjects,1) = centerCSD20Trials(5);
                centerCSDK20(nValidSubjects,1) = centerCSD20Trials(6);
                
                % Store the Center 40 values in the array
                centerPsyMu40(nValidSubjects,1) = centerCSD40Trials(1);
                centerPsySigma40(nValidSubjects,1) = centerCSD40Trials(2);
                centerCSDMu40(nValidSubjects,1) = centerCSD40Trials(4);
                centerCSDSigma40(nValidSubjects,1) = centerCSD40Trials(5);
                centerCSDK40(nValidSubjects,1) = centerCSD40Trials(6);
                
                % Store the Center 60 values in the array
                centerPsyMu60(nValidSubjects,1) = centerCSD60Trials(1);
                centerPsySigma60(nValidSubjects,1) = centerCSD60Trials(2);
                centerCSDMu60(nValidSubjects,1) = centerCSD60Trials(4);
                centerCSDSigma60(nValidSubjects,1) = centerCSD60Trials(5);
                centerCSDK60(nValidSubjects,1) = centerCSD60Trials(6);
                
                % Store the Center 80 values in the array
                centerPsyMu80(nValidSubjects,1) = centerCSD80Trials(1);
                centerPsySigma80(nValidSubjects,1) = centerCSD80Trials(2);
                centerCSDMu80(nValidSubjects,1) = centerCSD80Trials(4);
                centerCSDSigma80(nValidSubjects,1) = centerCSD80Trials(5);
                centerCSDK80(nValidSubjects,1) = centerCSD80Trials(6);
                
                % Store the Center 100 values in the array
                centerPsyMu100(nValidSubjects,1) = centerCSD100Trials(1);
                centerPsySigma100(nValidSubjects,1) = centerCSD100Trials(2);
                centerCSDMu100(nValidSubjects,1) = centerCSD100Trials(4);
                centerCSDSigma100(nValidSubjects,1) = centerCSD100Trials(5);
                centerCSDK100(nValidSubjects,1) = centerCSD100Trials(6);
                
                % ----Periphery----
                
                % Store the Periphery 20 values in the array
                peripheryPsyMu20(nValidSubjects,1) = peripheryCSD20Trials(1);
                peripheryPsySigma20(nValidSubjects,1) = peripheryCSD20Trials(2);
                peripheryCSDMu20(nValidSubjects,1) = peripheryCSD20Trials(4);
                peripheryCSDSigma20(nValidSubjects,1) = peripheryCSD20Trials(5);
                peripheryCSDK20(nValidSubjects,1) = peripheryCSD20Trials(6);
                
                % Store the Periphery 40 values in the array
                peripheryPsyMu40(nValidSubjects,1) = peripheryCSD40Trials(1);
                peripheryPsySigma40(nValidSubjects,1) = peripheryCSD40Trials(2);
                peripheryCSDMu40(nValidSubjects,1) = peripheryCSD40Trials(4);
                peripheryCSDSigma40(nValidSubjects,1) = peripheryCSD40Trials(5);
                peripheryCSDK40(nValidSubjects,1) = peripheryCSD40Trials(6);
                
                % Store the Periphery 60 values in the array
                peripheryPsyMu60(nValidSubjects,1) = peripheryCSD60Trials(1);
                peripheryPsySigma60(nValidSubjects,1) = peripheryCSD60Trials(2);
                peripheryCSDMu60(nValidSubjects,1) = peripheryCSD60Trials(4);
                peripheryCSDSigma60(nValidSubjects,1) = peripheryCSD60Trials(5);
                peripheryCSDK60(nValidSubjects,1) = peripheryCSD60Trials(6);
                
                % Store the Periphery 80 values in the array
                peripheryPsyMu80(nValidSubjects,1) = peripheryCSD80Trials(1);
                peripheryPsySigma80(nValidSubjects,1) = peripheryCSD80Trials(2);
                peripheryCSDMu80(nValidSubjects,1) = peripheryCSD80Trials(4);
                peripheryCSDSigma80(nValidSubjects,1) = peripheryCSD80Trials(5);
                peripheryCSDK80(nValidSubjects,1) = peripheryCSD80Trials(6);
                
                % Store the Periphery 100 values in the array
                peripheryPsyMu100(nValidSubjects,1) = peripheryCSD100Trials(1);
                peripheryPsySigma100(nValidSubjects,1) = peripheryCSD100Trials(2);
                peripheryCSDMu100(nValidSubjects,1) = peripheryCSD100Trials(4);
                peripheryCSDSigma100(nValidSubjects,1) = peripheryCSD100Trials(5);
                peripheryCSDK100(nValidSubjects,1) = peripheryCSD100Trials(6);
            
            end % End of if-else for final exclusion criteria
            
            % Close all for debugging and checking the results one by one
            close all;
            
        end % End of if-else statement that checks if data is complete
    end % End of if-else statement that checks for practice trials
end % End of for loop that loops through all subjects

close all;

%----------Plot Mu, Sigma, and K in Summary----------

% Plot the Mu for the center
figure;
plotMuSummary(centerPsyMu20, centerPsyMu100, centerCSDMu20, centerCSDMu100);

% Plot the Mu for the periphery
figure;
plotMuSummary(peripheryPsyMu20, peripheryPsyMu100, peripheryCSDMu20, peripheryCSDMu100);

% Plot the Sigma for the center
figure;
plotSigmaSummary(centerPsySigma20, centerPsySigma100, centerCSDSigma20, centerCSDSigma100);

% Plot the Sigma for the periphery
figure;
plotSigmaSummary(peripheryPsySigma20, peripheryPsySigma100, peripheryCSDSigma20, peripheryCSDSigma100);

% Plot the K for the center
figure;
plotKSummary(centerCSDK20, centerCSDK100);

% Plot the K for the periphery
figure;
plotKSummary(peripheryCSDK20, peripheryCSDK100);


%----------Plot the progression of trials----------

%---Summary Mu for Center---

% Plot the summary Mu for the center in Psy
figure;
plotEvery20TrialsMuSummary(centerPsyMu20, centerPsyMu40, centerPsyMu60, centerPsyMu80, centerPsyMu100);
% Get the line object to add to legend
line1 = findobj(gca,'Type','line');

% Plot the summary Mu for the center in CSD
hold on; % Plot in the same figure
plotEvery20TrialsMuSummary(centerCSDMu20, centerCSDMu40, centerCSDMu60, centerCSDMu80, centerCSDMu100);
% Get the line object to add to legend
line2 = findobj(gca,'Type','line');
% Add in the legend
legend([line1,line2'],{'Psy','CSD'});

%---Summary Mu for Periphery---

% Plot the summary Mu for the periphery in Psy
figure;
plotEvery20TrialsMuSummary(peripheryPsyMu20, peripheryPsyMu40, peripheryPsyMu60, peripheryPsyMu80, peripheryPsyMu100);
% Get the line object to add to legend
line1 = findobj(gca,'Type','line');

% Plot the summary Mu for the periphery in CSD
hold on; % Plot in the same figure
plotEvery20TrialsMuSummary(peripheryCSDMu20, peripheryCSDMu40, peripheryCSDMu60, peripheryCSDMu80, peripheryCSDMu100);
% Get the line object to add to legend
line2 = findobj(gca,'Type','line');
% Add in the legend
legend([line1,line2'],{'Psy','CSD'});


%---Summary Sigma for Center---

% Plot the summary Sigma for the center in Psy
figure;
plotEvery20TrialsSigmaSummary(centerPsySigma20, centerPsySigma40, centerPsySigma60, centerPsySigma80, centerPsySigma100);
% Get the line object to add to legend
line1 = findobj(gca,'Type','line');

% Plot the summary Sigma for the center in CSD
hold on; % Plot in the same figure
plotEvery20TrialsSigmaSummary(centerCSDSigma20, centerCSDSigma40, centerCSDSigma60, centerCSDSigma80, centerCSDSigma100);
% Get the line object to add to legend
line2 = findobj(gca,'Type','line');
% Add in the legend
legend([line1,line2'],{'Psy','CSD'});

%---Summary Sigma for Periphery---

% Plot the summary Sigma for the periphery in Psy
figure;
plotEvery20TrialsSigmaSummary(peripheryPsySigma20, peripheryPsySigma40, peripheryPsySigma60, peripheryPsySigma80, peripheryPsySigma100);
% Get the line object to add to legend
line1 = findobj(gca,'Type','line');

% Plot the summary Sigma for the periphery in CSD
hold on; % Plot in the same figure
plotEvery20TrialsSigmaSummary(peripheryCSDSigma20, peripheryCSDSigma40, peripheryCSDSigma60, peripheryCSDSigma80, peripheryCSDSigma100);
% Get the line object to add to legend
line2 = findobj(gca,'Type','line');
% Add in the legend
legend([line1,line2'],{'Psy','CSD'});


% %---------Plot Mu, Sigma, and K Individually----------
%
% % Plot the Mu for the center
% figure;
% plotMuData(centerPsyMu20, centerPsyMu100, centerCSDMu20, centerCSDMu100);
%
% % Plot the Mu for the periphery
% figure;
% plotMuData(peripheryPsyMu20, peripheryPsyMu100, peripheryCSDMu20, peripheryCSDMu100);
%
% % Plot the Sigma for the center
% figure;
% plotSigmaData(centerPsySigma20, centerPsySigma100, centerCSDSigma20, centerCSDSigma100);
%
% % Plot the Sigma for the periphery
% figure;
% plotSigmaData(peripheryPsySigma20, peripheryPsySigma100, peripheryCSDSigma20, peripheryCSDSigma100);
%
% % Plot the K for the center
% figure;
% plotKData(centerCSDK20, centerCSDK100);
%
% % Plot the K for the periphery
% figure;
% plotKData(peripheryCSDK20, peripheryCSDK100);

% --------- d' Analysis ----------
analyzeDPrime(dPrimeCenter,dPrimePeriphery);

% --------- d' Converged Analysis ----------
analyzeDPrime(dPrimeConvergedCenter,dPrimeConvergedPeriphery);

% --------- Confidence Analysis ----------
analyzeConfidence(confidenceCenter,confidencePeriphery);

% --------- Confidence Converged Analysis ----------
analyzeConfidence(confidenceConvergedCenter,confidenceConvergedPeriphery);

% --------- mRatio Analysis ----------
analyzeMRatio(mRatioCenter, mRatioPeriphery);

% --------- Ending Coherence Analysis ----------
analyzeEndingCoherence(endingCoherence);


