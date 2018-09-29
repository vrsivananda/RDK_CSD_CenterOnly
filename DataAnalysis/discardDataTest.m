% This function checks the data after the CSD procedure and returns true if
% it meets the criteria to be discarded

function discardData = discardDataTest(CSDOutput)

% Set parameters
meanThreshold = 0.75;
rangeThreshold = 0.25;

% Transfer values from arguments to variables
mu = CSDOutput(1);
sigma = CSDOutput(2);
k = CSDOutput(3);
finalMu = CSDOutput(4);
finalSigma = CSDOutput(5);
finalK = CSDOutput(6);

% First check if the mean is within the acceptable range
if( (abs(mu) > meanThreshold) || (abs(finalMu) > meanThreshold) )
    
    % If it is outside the range, return true to signal discarding
    discardData = true;
    
%     waitfor(msgbox('Mu is outside range'));
    
% Else we check for the range
else
    
    % ----Calculate the range of our curve----
    
    % Define the function - p(2) is slope, not sigma
    psyFit = @(p,a) 0.5*(erfc((-p(2)).*(a-p(1))./sqrt(2)));
    
    %Calculate the range
    range = psyFit([mu,1/sigma],[1]) - psyFit([mu,1/sigma],[-1]);
    
    % If the range is less than our threshold, return true to signal
    % discarding
    if(range < rangeThreshold)
%         waitfor(msgbox('Range is too small'));
        discardData = true;
    % Else return false and we keep the data
    else
        discardData = false;
    end
    
end