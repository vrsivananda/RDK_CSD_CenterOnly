clear;
close all;

% First, add the java file that you'll need to connect
% (This needs to be in the same directory or have the path added)
% Get this file from the Oracle website if you don't have it otherwise.
javaaddpath('mysql-connector-java-5.1.42-bin.jar');


% Next, create a connection object by connecting to our SQL database.
databaseName = 'qualia_01';
tableName = 'RDKCenterVsPeriphery2';
databasePassword = 'Bgt5kn|e';
serverAddess = 'psiturk.psych.ucla.edu';
conn = database('psych_qualia',databaseName,databasePassword,'Vendor','MySQL',...
    'Server',serverAddess);


% Then, load a text file that lists all of the subjects.
path='RDKCenterVsPeriphery_Subjects_All.txt';
% Make an ID for the subject list file
subjectListFileId=fopen(path);
% Read in the number from the subject list
numberOfSubjects = fscanf(subjectListFileId,'%d');
disp('Number of subjects: ');
disp(numberOfSubjects);

% Loop through all the subjects to get all the data from the database
for i = 1:numberOfSubjects
    
    % Read the subject ID from the file, stop after each line
    subjectId = fscanf(subjectListFileId,'%s',[1 1]);
    % Print out the subject ID
    fprintf('subject: %s\n',subjectId);

    % Make the SQL query to download everything.
    sqlquery = ['SELECT * FROM ' tableName ' WHERE subject = "' subjectId '"'];
    
    %------------%
    % CELL ARRAY %
    %------------%
    
    dataFormat = 'cellarray';
    
    % Execute the query
    cursor = exec(conn,sqlquery);
    % Set the format of how you want the data to be stored
    setdbprefs('DataReturnFormat',dataFormat);
    cursor = fetch(cursor);
    % Get the data in the format specified above
    data = cursor.Data;
    %Save the data
    savingFileName = [dataFormat '_data_' subjectId];
    save(savingFileName, 'data');
    
    %-----------%
    % STRUCTURE %
    %-----------% 
    
    dataFormat = 'structure';
    
    % Execute the query
    cursor = exec(conn,sqlquery);
    % Set the format of how you want the data to be stored
    setdbprefs('DataReturnFormat',dataFormat);
    cursor = fetch(cursor);
    % Get the data in the format specified above
    data = cursor.Data;
    % Save the data
    savingFileName = [dataFormat '_data_' subjectId];
    save(savingFileName, 'data');
    

end