% This function returns the values of the cell array where at those
% specific indices

function valuesArray = returnValues(cellArray, indicesArray)

% Declare the array
valuesArray = nan(length(indicesArray),1);

% Go through all the cells in the cell array
for i = 1:length(indicesArray)
    
    % The current index to use
    currentIndex = indicesArray(i);
    
    % If it is a string, then we use str2double to convert it into a double
    % and push it into the array
    if(ischar(cellArray{currentIndex}))
       valuesArray(i,1) = str2double(cellArray{currentIndex});
    end
    
    
    
end


