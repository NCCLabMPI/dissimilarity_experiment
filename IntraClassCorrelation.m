% script aim : Intra-class correlation co-efficient & 95% confidence
% intervals on the mean rating scores

clear
clc
addpath('./')
config;
cd(processedDataPath)
addpath(genpath(processedDataPath));

% get the processed data
load("ObjectData.mat");
%load(FaceData.mat);

analysisData = combinedObjectCells;

meanRatings = array2table(mean([analysisData.RatingBlock1,analysisData.RatingBlock2],2),"VariableNames",{'meanRatings'});
meanTable = [analysisData,meanRatings];

%combine the pairs of stimulus 

stimulusPairs = [analysisData.Stimulus1,analysisData.Stimulus2];

% Get unique pairs
uniquePairs = unique(stimulusPairs, 'rows');


pairRatings = [];

for i= 1: height(uniquePairs)
    pairIndices = all((meanTable.Stimulus1 == uniquePairs(i, 1)) & (meanTable.Stimulus2 == uniquePairs(i, 2)),2);%find the unique pairs
    pairMeanRatings = meanTable.meanRatings(pairIndices); % get the ratings for unique pairs
    pairRatings{i} = (pairMeanRatings)';
end

uniqueParticipantID =  unique(string(analysisData.subjectNumber)); 

meanRatingsperPair ={};

for i = 1:height(uniquePairs)
    
    currentRating = pairRatings{i};
    meanRatingsperPair{i}=currentRating;

end
    
% create a table that has participant ID and mean ratings given per each. 

ratingsMatrix = [uniquePairs, cell2mat(meanRatingsperPair')];
meanRatingsTable = array2table(ratingsMatrix, 'VariableNames', [{'Stimulus1', 'Stimulus2'}, strcat('Participant_', string(uniqueParticipantID'))]);

