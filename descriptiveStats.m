%% Clear and go to the folder
clear
clc
folderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/FirstPilotData';
cd(folderPath)

%% Subject File & trial files 
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

folderName = sprintf('sessionNumber is: %s\n',currentFaceFolder);
folderNames{i} = folderName; %here I put it to check whether I see all the folders. 

faceFolderContent = dir(currentFaceFolder); %I opened the sessionfolder

trialsCSVFile = fullfile(currentFaceFolder, 'trials.csv'); %I read the csv file

trialData = readtable(trialsCSVFile);

trialDataFaces{i} = trialData;

end

%% clean NaN variables in the trial data
% loop through each trial data 

    trialRatingMatrix = {};

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

    trialRatingMatrix{i} = horzcat(FaceTable1,FaceTable2);



end
    
%% Object File

%% Descriptive for gender and age 
clear
clc
folderPath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab';
cd(folderPath)
demographics = readtable("participantDemographics_DM.xlsx");

meanAge = median(demographics.Age);
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



