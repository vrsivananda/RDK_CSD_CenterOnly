% This function returns the indices of the cell array where the contents match the
% target value

function indicesArray = returnIndices(cellArray, targetValue)

% Declare the array
indicesArray = [];
    
% Go through all the cells in the cell array
for i = 1:length(cellArray)
    % If it is the value that we are looking for, then push the index into
    % the array
    
    % If it is a string, then we use strcmp
    if(ischar(cellArray{i}))
        if(strcmp(cellArray{i}, targetValue))
           indicesArray(length(indicesArray)+1,1) = i; 
        end
    end
end





