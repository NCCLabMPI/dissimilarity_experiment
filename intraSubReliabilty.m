
%% Check test-retest reliability within subjects

% get the processed files 
clear
clc
config
addpath('./')
cd(processedDataPath);
load('FaceData.mat');
disp('Face')
face_correlationData = combinedFaceCells; 
faceIntraReliability = intra_rater_reliability(face_correlationData);

load('ObjectData.mat');
disp(' ')
disp('Object')
object_correlationData = combinedObjectCells; 
objectIntraReliability = intra_rater_reliability(object_correlationData);

% Save the tables:
save(fullfile(processedDataPath,"faceIntraRaterReliability.mat"),'faceIntraReliability');
save(fullfile(processedDataPath,"objectIntraRaterReliability.mat"),'objectIntraReliability');





