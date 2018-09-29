function coherenceArray = fixCoherence(coherenceArray, logicalArray)

%Loop through every element in the array
for i = 1:length(logicalArray)
   
    % If it is a one, then turn it negative
    if(logicalArray(i) == 1)
        coherenceArray(i) = -coherenceArray(i);
    end
    
end