
%% Clear & open the file

clear
clc
cd('/Users/ece.ziya/Documents/GitHub/dissimilarity_experiment');

dataPath = ('/Users/ece.ziya/Desktop/testFiles/examplePilot');
cd(dataPath);
pilotTrial = 'trials.csv';
pilotSession = 'sessions.csv';

pilotTrial = readtable(pilotTrial);
pilotSession = readtable(pilotSession);




%% Pre-surprise

% also fixation onset & stim onset

% check the behavioral performance (80 % hit and 20% false alarm)

preSurpriseTask = pilotTrial(strcmp(pilotTrial.Task_Name,'facePre-surprise'),:);

preSurpriseCols = {'Trial_Nr','conditionFace','orientationFace','orientationFaceTarget','StimulusID','durationFace',...
   'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

preSurpriseTable = preSurpriseTask(:,preSurpriseCols);

% check whether they pressed space when it is target condition (RT full) 

% pre-surprise table 

% condition, duration , orientation, stim ID, pressed space (RT)



%% Critical Trial 

% which stimulus (stim ID & orientation) 
%take the data from pre-surprise + add probe order too ! 
criticalCols= {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical','criticalOrientation1','criticalOrientation2',...
    'CBcriticalOrientation1','CBcriticalOrientation2'};

criticalTable = (preSurpriseTask (:,criticalCols));

nan_rows = all(ismissing(criticalTable), 2);
cleanCritical = criticalTable(~nan_rows, :);


if strcmp (pilotSession.Group_Name,'GroupFace')
   


end
% Remove rows with all NaN values

% when it is shown (stim duration) 
% which probe came first ( orientation or duration)
% orientation options & which one is chosen
% duration options (which one is chosen)
% mindwandering --> which one is chosen 
% RT for all 
% confidence for all 

%% Post-surprise 

% which stim were shown for 4 trials 
% how long they were shown 
% options & answers given by participants 

postSurpriseTask = pilotTrial(strcmp(pilotTrial.Task_Name,'facePostSurprise'),:);

postSurpriseCols = {'confidenceDurationPostt','confidenceDurationRT','confidenceOrientationRT','congruencyCheck','durationConfidenceOnset',...
    'durationRT','emptyFramefixationOnset','fixationOnset','JitterTime','orientationConfidenceOnset','OrientationOnset',...
    'orientationRT','postDurationLong','postDurationShort','postOrientation1','postOrientation2','postOrientation1Stim','postOrientation2Stim','probeOrder','reactionTime',...
    'stimulusDurationPost','stimulusIDPost','stimulusOnset'};

postSurpriseTable = postSurpriseTask(:,postSurpriseCols);