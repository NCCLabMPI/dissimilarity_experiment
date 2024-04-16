
clear
clc

addpath('./')
config;
cd(processedDataPath)
addpath(genpath(processedDataPath));

load("ObjectMeanRatingsTable.mat")

objectData = meanRatingsTable;

ratings = objectData{:,3:end};

randomRatings = [];
rValues = [];



for i = 1:1000

    % generate random indices 
    for j = 1: width(ratings)
    
    randomIndices = randperm(length(ratings));
    randomizedColumn = ratings(randomIndices, j);
    randomRatings(:, j) = randomizedColumn;

    [r, LB, UB, F, df1, df2, p] = ICC(randomRatings, 'C-k', 0.05, 0);
    end
    
    rValues(i)= r;
end
    

