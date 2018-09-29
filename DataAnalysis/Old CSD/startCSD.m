function output = startCSD(coherence, binaryChoice, confidence)

    opts = optimset('fminsearch');
    opts.TolX = 1.e-4;
    opts.TolFun = 1.e-4;
    
    % ==============================================
    % Step B:

    % Psychometric function
    disp('-------------------------------------');
    disp('Psychometric function on binomial data with 0 guess and 0 lapse rates:');
    disp('    mean      slope');
    %Fitting to binary forced choice data:
    parameters2 = psychometricFit2Parameters(coherence,binaryChoice,0,0,0);
    disp(parameters2);

    %Store what we need in variables
    mu = parameters2(1);
    slope = parameters2(2);
    sigma = 1/slope;

    % ==============================================
    % Step C:

    % Confidence function
    disp('-------------------------------------');
    disp('Confidence function with only k as the free parameter');
    disp('    scalar');
    parameters4 = psychometricFit1Parameter(coherence,confidence,mu,slope,0,0,0);
    disp(parameters4);

    k = parameters4;

    % ==============================================
    % Step D:

    %Preallocate for matrix to hold lower bin limit (col 1) and uper bin limit
    %(col 2)
    binLimits = nan(length(confidence),2);
    
    %Fix the confidence at the ends such that their bins will be inside the
    %range
    fixedConfidence = confidence;
    fixedConfidence(confidence == 1) = 1 - 0.005 - 0.0000000000000001;
    fixedConfidence(confidence == 0) = 0 + 0.005 + 0.0000000000000001;

    %Fill in the bin
    binLimits(:,1) = fixedConfidence(:,1) - 0.005;
    binLimits(:,2) = fixedConfidence(:,1) + 0.005;
    



    % ==============================================
    % Step E:

    %Assignment has been done above in step C.
    % mu sigma k

    %The initial guessing values for fmincon, to be varied
    x0 = [mu, sigma, k]

    % ==============================================
    % Steps F to H:

    %Create an anonymous function to be used in fmincon
    %This gets us around the problem where some variables need to be fixed (the
    %original mu, sigma,and k) and others need to be changed to be optimized
    %(those in x0).
    f = @(x) stepsFtoH(x,fixedConfidence,binLimits,coherence);


    % ==============================================
    % Step I
    %[finalX,fval, exitflag, output, lambda, grad, hessian] = fmincon(f,x0,[],[],[],[],[-0.5 0 0],[0.5 3 30]);
    %finalX = fminsearchbnd(f,x0,[-0.5 0 0],[0.5,3,10],opts);
    finalX = fminsearch(f,x0);

    finalMu = finalX(1);
    finalSigma = finalX(2);
    finalK = finalX(3);

    % ==============================================
    
     output = [mu, sigma, k, finalMu, finalSigma, finalK];