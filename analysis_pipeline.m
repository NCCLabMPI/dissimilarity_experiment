%% Analysis pipeline
% THis script does all the analyses

%% Housekeeping
clear
clc
close all
config
addpath('./')

%% Preprocessing
descriptiveStats

%% Intra subject reliablity
cd(processed_data_path);
load('FaceData.mat');
disp('Face')
face_correlationData = combinedFaceCells; % change here to do the same test for objects
intra_rater_reliability(face_correlationData)

load('ObjectData.mat');
disp('')
disp('Object')
object_correlationData = combinedObjectCells; % change here to do the same test for objects
intra_rater_reliability(object_correlationData)



%% Intra-class correlation


