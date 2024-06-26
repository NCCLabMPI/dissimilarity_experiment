%% Clear and go to the folder for the data 
clear
clc
addpath('./')
config;
cd(rawDataPath)% you should give the permission to matlab for shared folders
addpath(genpath(rawDataPath)); %I open the path where my data is

% Decide whether the file is object or face data
subjectFolders = dir(rawDataPath);
subjectFolders = subjectFolders([subjectFolders.isdir] & ~startsWith({subjectFolders.name}, '.') ...
                                                        & ~strcmp({subjectFolders.name},'Age&Gender')); % remove both hidden and demographics file
%sessionID = {}; % this one is for deciding which code I'll use - face or object
objectFiles = {}; %I will add the object files in this cell with participant numbers
faceFiles = {}; % I will add the face files here
trialDataFaces = {}; %for faces
trialDataObjects = {};%for objects
cleanTrialDataFaces = {}; %put clean face trial data
cleanTrialDataObject = {}; %put clean object trial data

% this goes through all the subjectFolders and cleans the data based on its
% subject group 

for i = 1:numel(subjectFolders)
    % first I open the session file that contains the info I am looking for
    
    currentSubject = fullfile(rawDataPath,subjectFolders(i).name);
    subjectFileContent = dir(currentSubject);
    subjectSessionFile = fullfile(currentSubject,'sessions.csv');
    sessionData = readtable(subjectSessionFile);
    
    if sessionData.Session_Name(1) == "sessionFace"
        faceFiles{i} = currentSubject;
        faceFiles = faceFiles(~cellfun(@isempty, faceFiles)); % get rid of empty files

            for i = 1:numel(faceFiles)
            %first I open the files here and clean the hidden files
    
            facePath = faceFiles{i};  % each facePath consist of two files: 
                              % trial and session 
     
             % access trial data 

             trialPath = fullfile(facePath,"trials.csv");
             currentTrial = readtable(trialPath);

              %clean the trial data

             Face1Block1 = rmmissing(currentTrial.RowFace1(:)); %clean the NaN values
             Face2Block1 = rmmissing(currentTrial.RowFace2(:));
             FaceBlock1Ratings = rmmissing(currentTrial.faceSimilarityBlock1(:));

            FaceMatrix1 = [Face1Block1,Face2Block1,FaceBlock1Ratings]; % first block

            FaceTable1 = array2table(FaceMatrix1, 'VariableNames', {'Face1Block1', 'Face2Block1', 'RatingsBlock1'});

            Face1Block2 = rmmissing(currentTrial.RowFace1SecondBlock(:));
            Face2Block2 = rmmissing(currentTrial.RowFace2SecondBlock(:));
            FaceBlock2Ratings = rmmissing(currentTrial.faceSimilarityBlock2);
   
            FaceMatrix2 = [Face1Block2,Face2Block2,FaceBlock2Ratings]; % second block
            FaceTable2 = array2table(FaceMatrix2,'VariableNames',{'Face1Block2','Face2Block2','RatingsBlock2'});

            cleanTrialDataFaces = horzcat(FaceTable1,FaceTable2);
    
            % match the pairs 
    
            block1Pairs = cleanTrialDataFaces {:,1:2};
            block2Pairs = cleanTrialDataFaces{:,4:5};
            ratings1 = cleanTrialDataFaces{:,3};
            ratings2 = cleanTrialDataFaces{:,6};

            [~, idx] = ismember(block1Pairs, block2Pairs, 'rows'); %finding matching pairs
   
   
            matchingRatings = [block1Pairs,ratings1,ratings2(idx)];
            RatingTable = array2table(matchingRatings,'VariableNames',{'Stimulus1','Stimulus2','RatingBlock1','RatingBlock2'});
    
            %here I also want to add subject ID. 
    
            sessionPath = fullfile(facePath,"sessions.csv");
            currentSession = readtable(sessionPath);
            subjectID = currentSession.Subject_Code;
    
                    
    
            totalRowNum = height(RatingTable);
            subjectIDRepeat = repmat({subjectID}, totalRowNum, 1);
    
            RatingTable = addvars(RatingTable, subjectIDRepeat, 'Before', 1, 'NewVariableNames', 'subjectNumber');
   
             trialDataFaces{i} = RatingTable;

            end

  elseif sessionData.Session_Name == "sessionObject"
        objectFiles{i} = currentSubject;
        objectFiles = objectFiles(~cellfun(@isempty, objectFiles));

            for i = 1:numel(objectFiles)
    
            objectPath = objectFiles{i};  
    
            % access trial data 

            trialPath = fullfile(objectPath,"trials.csv");
            currentTrial = readtable(trialPath);

             %clean the trial data

             Object1Block1 = rmmissing(currentTrial.RowNumStim1(:)); %clean the NaN values
            Object2Block1 = rmmissing(currentTrial.RowNumStim2(:));
            ObjectBlock1Ratings = rmmissing(currentTrial.ObjectSimilarityBlock1(:));

            ObjectMatrix1 = [Object1Block1,Object2Block1,ObjectBlock1Ratings]; % first block

            ObjectTable1 = array2table(ObjectMatrix1, 'VariableNames', {'Object1Block1', 'Object2Block1', 'RatingsBlock1'});

            Object1Block2 = rmmissing(currentTrial.RowObject1SecondBlock(:));
            Object2Block2 = rmmissing(currentTrial.RowObject2SecondBlock(:));
            ObjectBlock2Ratings = rmmissing(currentTrial.ObjectSimilarityBlock2(:));
   
            ObjectMatrix2 = [Object1Block2,Object2Block2,ObjectBlock2Ratings]; % second block
            ObjectTable2 = array2table(ObjectMatrix2,'VariableNames',{'Object1Block2','Object2Block2','RatingsBlock2'});

            cleanTrialDataObjects = horzcat(ObjectTable1,ObjectTable2);
            block1Pairs = cleanTrialDataObjects {:,1:2};
            block2Pairs = cleanTrialDataObjects{:,4:5};
            ratings1 = cleanTrialDataObjects{:,3};
             ratings2 = cleanTrialDataObjects{:,6};

          [~, idx] = ismember(block1Pairs, block2Pairs, 'rows'); %finding matching pairs
   
          matchingRatings = [block1Pairs,ratings1,ratings2(idx)];
          RatingTable = array2table(matchingRatings,'VariableNames',{'Stimulus1','Stimulus2','RatingBlock1','RatingBlock2'});
    
          %here I also want to add subject ID. 
         
    
         sessionPath = fullfile(objectPath,"sessions.csv");
         currentSession = readtable(sessionPath);
         subjectID = currentSession.Subject_Code;
               
              
        
        totalRowNum = height(RatingTable);
        subjectIDRepeat = repmat({subjectID}, totalRowNum, 1);
    
         RatingTable = addvars(RatingTable, subjectIDRepeat, 'Before', 1, 'NewVariableNames', 'subjectNumber');
   
        trialDataObjects{i} = RatingTable;

        end   


    end
    
end


    combinedFaceCells = vertcat(trialDataFaces{:});
    combinedObjectCells = vertcat(trialDataObjects{:});

    % I know that first participant's id is missing. This line will check
    % NaN in the final version of tables and assign a the value sub-101 

   subjectNumberCell = (combinedObjectCells.subjectNumber);
   nanIndices = cellfun(@(x) isnumeric(x) && any(isnan(x)), subjectNumberCell);
   subjectNumberCell(nanIndices) = {'Sub-101'};
   combinedObjectCells.subjectNumber = subjectNumberCell;

    %save the file
    faceRatingFile = 'FaceData.mat';
    save(fullfile(processedDataPath,faceRatingFile),'combinedFaceCells');
    objectRatingFile = 'ObjectData.mat';
    save(fullfile(processedDataPath,objectRatingFile),'combinedObjectCells');
    
%% Descriptive for gender and age 
clear
clc
config;
cd(demographics);
addpath(genpath(demographics));
demographics = readtable("participantDemographics_DM.xlsx");

meanAge = mean(demographics.Age);
medianAge = median(demographics.Age);
sdAge = std(demographics.Age);
youngestAge = min(demographics.Age);
oldestAge = max(demographics.Age);

% You can use tabulate function to divide the excel based on participant
% sex 

tabulate(demographics.Gender);

femaleAge = demographics.Age(strcmp(demographics.Gender,'F')); 
countFemale = sum((strcmp(demographics.Gender,'F')));
maleAge = demographics.Age(strcmp(demographics.Gender,'M'));
countMale = sum((strcmp(demographics.Gender,'M')));
ageTable = table({femaleAge},{maleAge},'VariableNames',{'Female Age','Male Age'});

% Plot age and sex data 

% plot sex

figure;

bar([countFemale,countMale],'FaceColor',descriptiveColor);
xlabel('Sex');
ylabel('Count');
xticklabels({'Female','Male'});
title('Sex Distribution');

%plot age
figure;
histogram([demographics.Age],'FaceColor',descriptiveColor);
xlabel('Age');
ylabel('Count');
title('Age distribution');



