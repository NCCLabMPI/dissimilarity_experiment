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

%clean the excluded participant data before calling the function

faceAnalysisData = dataExclude(combinedFaceCells,'Sub-119');
objectAnalysisData = combinedObjectCells;

%call the intra-class correlation function

faceICCTable = intraClassCorrelationFunction(faceAnalysisData,"Face");
objectICCTable =intraClassCorrelationFunction(combinedObjectCells,"Object");

% save the files
faceICCFile = 'FaceICC.mat';
objectICCFile = 'ObjectICC.mat';

save(fullfile(processedDataPath, faceICCFile), 'faceICCTable');
save(fullfile(processedDataPath, objectICCFile), 'objectICCTable');




