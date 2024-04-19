
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
MDSface = MDSFunction(faceMeanRatingData,'Face');

load("ObjectMeanRatingsTable.mat");
objectMeanRatingData = meanRatingsTable;
MDSobject = MDSFunction(objectMeanRatingData,'Object');


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





 