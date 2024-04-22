
clear
clc
config
addpath('./')
cd(processedDataPath)

load("faceIntraRaterReliability.mat")
load("objectIntraRaterReliability.mat")

faceIntraRater = cell2mat(faceIntraReliability(:,2));
objectIntraRater = cell2mat(objectIntraReliability (:,2));

[f,xi]= ksdensity(faceIntraRater);
figure;
plot(xi,f,'LineWidth',1.5,'Color','green');
xlabel('Intra-subject correlation')
ylabel('Density')
title('Face Group Intra-Subject Correlation Kernel Density Estimate');

mean(faceIntraRater);

%% ICC tables 

load("FaceICC.mat")
load("ObjectICC.mat")
ICCcombinedTable = [faceICCTable;objectICCTable];