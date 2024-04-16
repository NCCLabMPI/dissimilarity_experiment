
function [ICCTable] = intraClassCorrelationFunction(analysisData,dataType)

config;

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
% this table is for seeing mean of how each participant rated pairs 

ratingsMatrix = [uniquePairs, cell2mat(meanRatingsperPair')];
meanRatingsTable = array2table(ratingsMatrix, 'VariableNames', ...
    [{'Stimulus1', 'Stimulus2'}, strcat(dataType,'Participant_', string(uniqueParticipantID'))]);

% save meanRatingsTable for future usage 

if strcmp(dataType, 'Object')
    filename = 'ObjectMeanRatingsTable.mat';
elseif strcmp(dataType, 'Face')
    filename = 'FaceMeanRatingsTable.mat';
end

fullPath = fullfile(processedDataPath, filename);

save(fullPath,'meanRatingsTable')

% calculate ICC 

%before calculating ICC, remove the identical pairs 

pairs = [meanRatingsTable{:, 1}, meanRatingsTable{:, 2}];
uniqueIdx = ~all(pairs(:, 1) == pairs(:, 2), 2);

ratingsData = table2array(meanRatingsTable(uniqueIdx, 3:end));


[r, LB, UB, F, df1, df2, p] = ICC(ratingsData, 'C-k', 0.05, 0);
ICCTable = array2table([dataType,r, LB, UB, F, df1, df2, p], ...
    'VariableNames', {'DataType','ICC', 'LowerBound', 'UpperBound', 'FValue', 'DF1', 'DF2', 'pValue'});
end