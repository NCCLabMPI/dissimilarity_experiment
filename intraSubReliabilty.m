
%% Check test-retest reliability within subjects

% get the processed files 
clear
clc

filePath = '/Users/ece.ziya/Desktop/Dissimilarity/Matlab/DataFiles';
cd(filePath);
load('FaceData.mat');
%load("ObjectData.mat")
correlationData = combinedFaceCells; % change here to do the same test for objects


%% Spearman Correlation Coefficient

% identify unique subject IDs for calculating test-retest reliability for
% each
 
correlationData.subjectNumber = cellfun(@char, correlationData.subjectNumber, 'UniformOutput', false);
subjects = unique(string(correlationData.subjectNumber)); % get unique subject numbers 

ratingPerSub = {};
spearmanCorrelation = {};
 
for i = 1:numel(subjects) % for each subject there are 210 comparisons 
    % get specific subject data 
    
    subjectData = correlationData(strcmp(correlationData.subjectNumber,subjects{i}),{'RatingBlock1', 'RatingBlock2'});
    ratingPerSub{i} = subjectData;
    
    %get specific ratings 
    Ratings = ratingPerSub{i};
    %calculate spearmanCorrelation
    correlationCoefficient = corr(Ratings.RatingBlock1,Ratings.RatingBlock2, 'Type', 'Spearman');
    spearmanCorrelation{i} = {subjects{i}, correlationCoefficient};

end

%% Fischer's Transformation 

fishtrans = {};
for i = 1:numel(spearmanCorrelation)
    coefficentValue = spearmanCorrelation{i}{2};
    z = 0.5 * log((1 + coefficentValue) / (1 - coefficentValue));% fischer transform code
    fishtrans{i} = {spearmanCorrelation{i}{1}, z};
end 

%% one sample t-test

pValues = {}; % p< .05 will be excluded

for i = 1:numel(subjects)
    
   currentFish = fishtrans{i}{2};
    
  [h,p] = ttest(currentFish); %two-tailed one sample t-test against 0

   pValues{i} = p;

end
