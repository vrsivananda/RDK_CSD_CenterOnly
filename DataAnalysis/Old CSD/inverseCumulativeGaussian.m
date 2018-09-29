% p(1) = alpha  = bias / mean / threshold / PSE
% p(2) = beta   = slope = 1/sigma [Enters function as sigma]
% p(3) = gamma  = guess rate
% p(4) = lambda = lapse rate

function output = inverseCumulativeGaussian(p,y)
    
    %p(2) is sigma. Need to convert to slope
    p(2) = 1/p(2);

    if(length(p) == 2)
       p = [p 0 0];
    end
    
    output = (sqrt(2)/(-p(2)))*(erfcinv((2*(y-p(3)))/(1-p(3)-p(4))))+p(1);
end