% p(1) = alpha  = bias / mean / threshold / PSE
% p(2) = beta   = slope = 1/sigma [p(2) enters function as sigma]
% gamma  = guess rate = 0
% lambda = lapse rate = 0

function output = cumulativeGaussian(x,p)
    % Convert sigma into the slope
    p(2) = 1/p(2);

    % Calculates the percentage (y) given the x
    output = 0.5*(erfc((-p(2)).*(x-p(1))./sqrt(2)));
end