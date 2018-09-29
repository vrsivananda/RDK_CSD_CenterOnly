function newRate = fixRate(rate,n)

% This function fixes the hit rate or false alarm rate when it is 0 or 1

% The rule used to compute the new rate
rule = 1/((2*n)+1);

if(rate == 0)
   newRate = rule;
elseif(rate == 1)
   newRate = 1 - rule;
% Else just return the rate as it doesn't need fixing
else
    newRate = rate;
end

end