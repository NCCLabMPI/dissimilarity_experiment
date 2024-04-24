
clear
clc
config
addpath('./')
cd(processedDataPath)

load("faceIntraRaterReliability.mat")
load("objectIntraRaterReliability.mat")

faceIntraRater = cell2mat(faceIntraReliability(:,2));
objectIntraRater = cell2mat(objectIntraReliability (:,2));

figure;

histogram(objectIntraRater,'FaceColor',objectColor);
xlabel('Intra-subject correlation (fisher transformed')
ylabel('Number of subjects')
title('Object Group Intra-Subject Correlation');

mean(faceIntraRater);

%% ICC tables 

load("FaceICC.mat")
load("ObjectICC.mat")
ICCcombinedTable = [faceICCTable;objectICCTable];