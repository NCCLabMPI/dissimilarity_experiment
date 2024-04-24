
% This script computes multidimensional scaling (MDS)
% classic MDS applied on non-spatial distances

clear
clc
addpath('./');
config;

cd(processedDataPath)
addpath(genpath(processedDataPath));

%load data and compute MDS

load("FaceMeanRatingsTable.mat");
faceMeanRatingData = meanRatingsTable;
[faceDM, MDSface] = MDSFunction(faceMeanRatingData,'Face');

load("ObjectMeanRatingsTable.mat");
objectMeanRatingData = meanRatingsTable;
[objectDM, MDSobject] = MDSFunction(objectMeanRatingData,'Object');


%% MDS check for number of eigenvalues and error rate before plotting the graphs
   %check how many eigenvalues are high and how many of them are negative
   %it should be first 2 values significantly higher than others 
   eigenCheckObject = [MDSobject{2} MDSobject{2}/max(abs(MDSobject{2}))]; 
   eigenCheckFace = [MDSface{2} MDSface{2}/max(abs(MDSface{2}))];  
   
   %check the error rate --> 'error in the distances between the 2D configuration and the original distances'
   load("FaceDistanceMatrix.mat")
   faceDistanceMatrix = distanceTable;
   
   load("ObjectDistanceMatrix.mat")
   objectDistanceMatrix = distanceTable;
   
   maxrelerrFace = max(abs(table2array(faceDistanceMatrix) - squareform(pdist(MDSface{1}(:,1:2))))) / max(table2array(faceDistanceMatrix));
   maxrelerrObject = max(abs(table2array(objectDistanceMatrix) - squareform(pdist(MDSobject{1}(:,1:2))))) / max(table2array(objectDistanceMatrix));
%% Plot and save the MDS 
MDSPlot(MDSface{1},'Face');
faceMDSFigure = gcf;
filename = fullfile(plotPath, 'faceMDSFigure.png');
saveas(faceMDSFigure,filename);

MDSPlot(MDSobject{1},'Object');
objectMDSFigure = gcf;
filename = fullfile(plotPath, 'objectMDSFigure.png');
saveas(objectMDSFigure, filename);

%% Select the 2 faces and objects that have the largest distance to all other stimuli:

% Set the diagonal to Nan:
faceDM(eye(length(faceDM))==1) = nan;
objectDM(eye(length(objectDM))==1) = nan;

% Compute the mean distance from each stimulus to all other:
meanFaceDist = mean(faceDM, 1, "omitnan");
meanObjectDist = mean(objectDM, 1, "omitnan");

% Find the two faces which are the furthest from the rest:
% Faces:
[~, sortedIndices] = sort(meanFaceDist, 'descend');
highestIndices = sortedIndices(1:2);
target_01 = sprintf('face_%d\n',  highestIndices(1));
target_02 = sprintf('face_%d\n',  highestIndices(2));
fprintf(target_01)
fprintf(target_02)
% Objects:
[~, sortedIndices] = sort(meanObjectDist, 'descend');
highestIndices = sortedIndices(1:2);
target_01 = sprintf('object_%d\n',  highestIndices(1));
target_02 = sprintf('object_%d\n',  highestIndices(2));
fprintf(target_01)
fprintf(target_02)

 