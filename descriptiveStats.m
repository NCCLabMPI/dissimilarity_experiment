%% Clear and go to the folder
clear
clc
folderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/FirstPilotData';
cd(folderPath)

%% Face File & trial files 
% open the subject file and get all the files in it
faceFolderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/FirstPilotData/SubjectPilot';
faceFolders = dir(faceFolderPath); % to open all the folders inside
faceFolders = faceFolders([faceFolders.isdir] & ~startsWith({faceFolders.name}, '.')); %removing hidden files
% create a cell array to store the content (aka folders in my subjectPilot)


folderNames = {};%I added this to check whether I go through all the variables. 
trialDataFaces = {};

%this is a struct. I want to convert it to a cell. 
for i = 1:numel(faceFolders) % loop for the size of the faceFolder
currentFaceFolder = fullfile(faceFolderPath,faceFolders(i).name); %session ID


%folderNames{i} = folderName; %here I put it to check whether I see all the folders. 

faceFolderContent = dir(currentFaceFolder); %I opened the sessionfolder

trialsCSVFile = fullfile(currentFaceFolder, 'trials.csv'); %I read the csv file

trialData = readtable(trialsCSVFile);

trialDataFaces{i} = trialData; %this one is not clean

end

% clean NaN variables in the trial data
% loop through each trial data 

    trialRatingMatrixFace = {}; %this one is clean, without NaN 

for i = 1:numel(trialDataFaces)

    currentTrialFace = trialDataFaces{i};

    
    Face1Block1 = rmmissing(currentTrialFace.RowFace1(:)); %clean the NaN values
    Face2Block1 = rmmissing(currentTrialFace.RowFace2(:));
    FaceBlock1Ratings = rmmissing(currentTrialFace.faceSimilarityBlock1(:));

    FaceMatrix1 = [Face1Block1,Face2Block1,FaceBlock1Ratings]; % first block

    FaceTable1 = array2table(FaceMatrix1, 'VariableNames', {'Face1Block1', 'Face2Block1', 'RatingsBlock1'});

    Face1Block2 = rmmissing(currentTrialFace.RowFace1SecondBlock(:));
    Face2Block2 = rmmissing(currentTrialFace.RowFace2SecondBlock(:));
    FaceBlock2Ratings = rmmissing(currentTrialFace.faceSimilarityBlock2);
   
    FaceMatrix2 = [Face1Block2,Face2Block2,FaceBlock2Ratings]; % second block
    FaceTable2 = array2table(FaceMatrix2,'VariableNames',{'Face1Block2','Face2Block2','RatingsBlock2'});

    trialRatingMatrixFace{i} = horzcat(FaceTable1,FaceTable2);

end

% Matching the same pairs in 2 blocks 

RatingsCellFace = {};

for i= 1:numel(trialRatingMatrixFace)

    currentTable = trialRatingMatrixFace{i}; %open the first cell
    
    block1Pairs = currentTable {:,1:2};
    block2Pairs = currentTable{:,4:5};
    ratings1 = currentTable{:,3};
    ratings2 = currentTable{:,6};

    [~, idx] = ismember(block1Pairs, block2Pairs, 'rows'); %finding matching pairs

    matchingRatings = [block1Pairs,ratings1,ratings2(idx)];
    RatingTable = array2table(matchingRatings,'VariableNames',{'Face1','Face2','RatingBlock1','RatingBlock2'});
    
    RatingsCellFace{i} = RatingTable;

end

%Save files as matlab
faceRatingFile = 'ratingFace.mat';
dataFile = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/DataFiles';
save(fullfile(dataFile,faceRatingFile),'RatingsCellFace');

    
%% Object Files & trial Files

objectFolderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/FirstPilotData/ObjectPilot';
objectFolders = dir(objectFolderPath);
objectFolders = objectFolders([objectFolders.isdir] & ~startsWith({objectFolders.name}, '.'));

trialDataObjects = {};

%this is a struct. I want to convert it to a cell. 
for i = 1:numel(objectFolders) % loop for the size of the faceFolder
    currentObjectFolder = fullfile(objectFolderPath,objectFolders(i).name); %session ID

    objectFolderContent = dir(currentObjectFolder); %I opened the sessionfolder

    trialsCSVFile = fullfile(currentObjectFolder, 'trials.csv'); %I read the csv file

    trialData = readtable(trialsCSVFile);

    trialDataObjects{i} = trialData; %this one is not clean

end

%Clean NaN variables for objects 
 trialRatingMatrixObject= {}; %this one is clean, without NaN 

for i = 1:numel(trialDataObjects)

    currentTrialObject = trialDataObjects{i};

    
    Object1Block1 = rmmissing(currentTrialObject.RowNumStim1(:)); %clean the NaN values
    Object2Block1 = rmmissing(currentTrialObject.RowNumStim2(:));
    % RowNumStim1 = Object ID 1 & RowNumStim2 = Object ID 2
    ObjectBlock1Ratings = rmmissing(currentTrialObject.ObjectSimilarityBlock1(:));

    ObjectMatrix1 = [Object1Block1,Object2Block1,ObjectBlock1Ratings]; % first block

    ObjectTable1 = array2table(ObjectMatrix1, 'VariableNames', {'Object1Block1', 'Object2Block1', 'RatingsBlock1'});

    Object1Block2 = rmmissing(currentTrialObject.RowObject1SecondBlock(:));
    Object2Block2 = rmmissing(currentTrialObject.RowObject2SecondBlock(:));
    ObjectBlock2Ratings = rmmissing(currentTrialObject.ObjectSimilarityBlock2);
   
    ObjectMatrix2 = [Object1Block2,Object2Block2,ObjectBlock2Ratings]; % second block
    ObjectTable2 = array2table(ObjectMatrix2,'VariableNames',{'Object1Block2','Object2Block2','RatingsBlock2'});

    trialRatingMatrixObject{i} = horzcat(ObjectTable1,ObjectTable2);

end

% Matching the pairs in 2 blocks 
RatingsCellObject = {};

for i= 1:numel(trialRatingMatrixObject)

    currentTable = trialRatingMatrixObject{i}; %open the first cell
    
    block1Pairs = currentTable {:,1:2};
    block2Pairs = currentTable{:,4:5};
    ratings1 = currentTable{:,3};
    ratings2 = currentTable{:,6};

    [~, idx] = ismember(block1Pairs, block2Pairs, 'rows'); %finding matching pairs

    matchingRatings = [block1Pairs,ratings1,ratings2(idx)];
    RatingTable = array2table(matchingRatings,'VariableNames',{'Object1','Object2','RatingBlock1','RatingBlock2'});
    
    RatingsCellObject{i} = RatingTable;

end

%Save the files as matlab
objectRatingFile = 'ratingObject.mat';
dataFile = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/DataFiles';
save(fullfile(dataFile,objectRatingFile),'RatingsCellObject');



%% Descriptive for gender and age 
clear
clc
folderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab';
cd(folderPath)
demographics = readtable("participantDemographics_DM.xlsx");

meanAge = mean(demographics.Age);
medianAge = median(demographics.Age);
sdAge = std(demographics.Age);
youngestAge = min(demographics.Age);
oldestAge = max(demographics.Age);

% You can use tabulate function to divide the excel based on participant
% sex 

%tabulate(demographics.Gender);

femaleAge = demographics.Age(strcmp(demographics.Gender,'F')); %take the ages if gender is F
maleAge = demographics.Age(strcmp(demographics.Gender,'M'));
ageTable = table({femaleAge},{maleAge},'VariableNames',{'Female Age','Male Age'});
% by using {} rather than [] I can put all the varibles inside the table
% even the row numbers are not equal. 

