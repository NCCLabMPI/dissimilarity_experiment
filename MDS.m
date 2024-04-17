
% This script is for multidimensional scaling (MDS)
%classic MDS applied on non-spatial distances

clear
clc
addpath('./');
config;

cd(processedDataPath)
addpath(genpath(processedDataPath));

load("FaceMeanRatingsTable.mat")

% aggregate ratings into one rating

% mean score per row

    rowMeans = {}; 

for i = 1:height(meanRatingsTable)
    rowMean = mean(meanRatingsTable(i,3:end),"all");
    rowMeans{i} = rowMean;
end

    rowMeans = vertcat(rowMeans{:});

% MDS suitable table 
    
    stimulusTable = array2table([meanRatingsTable.Stimulus1,meanRatingsTable.Stimulus2],"VariableNames",{'Stimulus1','Stimulus2'});
    MDStable = [stimulusTable,rowMeans];
    
% compute dissimilarity matrix
  