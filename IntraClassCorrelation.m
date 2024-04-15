% script aim : Intra-class correlation co-efficient & 95% confidence
% intervals on the mean rating scores

clear
clc
addpath('./')
config;
cd(processedDataPath)
addpath(genpath(processedDataPath));

% get the processed data
load('ObjectData.mat');
load('FaceData.mat');

objectAnalysisData = combinedObjectCells;
faceAnalysisData = combinedFaceCells;
intraClassCorrelationFunction(faceAnalysisData);
intraClassCorrelationFunction(objectAnalysisData)

