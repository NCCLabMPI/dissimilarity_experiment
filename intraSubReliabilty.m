
%% Check test-retest reliability within subjects

% get the processed files 
clear
clc
config
addpath('./')
cd(processedDataPath);
load('FaceData.mat');
disp('Face')
face_correlationData = combinedFaceCells; % change here to do the same test for objects
intra_rater_reliability(face_correlationData)

load('ObjectData.mat');
disp(' ')
disp('Object')
object_correlationData = combinedObjectCells; % change here to do the same test for objects
intra_rater_reliability(object_correlationData)





