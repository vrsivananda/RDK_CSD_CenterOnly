function [age gender] = getDemographicData(dataStructure)
    
    % ----- Age ----
    
    % Get the index of the age question
    ageIndex = returnIndices(dataStructure.trial_type, 'survey-text');
    
    % Get the age string
    ageString = dataStructure.responses{ageIndex};
    
    % Get the index of the colon
    colonIndex = strfind(ageString, ':');
    
    % Get the two characters after the colon
    ageChars = ageString(colonIndex+2:colonIndex+3);
    
    % Convert the age into numbers
    [age, conversionSuccessful] = str2num(ageChars);
    
    % If the conversion was unsuccessful, then return a NaN
    if(~conversionSuccessful)
        age = nan;
    end
    
     % ----- gender ----
    
    % Get the index of the gender question
    genderIndex = returnIndices(dataStructure.trial_type, 'survey-multi-choice');
    
    % Get the gender string
    genderString = dataStructure.responses{genderIndex};
    
    % Get the index of the colon
    colonIndex = strfind(genderString, ':');
    
    % Get the two characters after the colon
    gender = genderString(colonIndex+2);
    
end % End of function 