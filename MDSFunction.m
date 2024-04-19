
function [MDScell] = MDSFunction(MeanData,Datatype)

config;
meanRatingsTable = MeanData;
%Aggregate ratings into one rating with mean score given to given pair
%across participants

 rowMeans = {}; % each row consist of all the ratings given to the each pair

for i = 1:height(meanRatingsTable)
    rowMean = mean(meanRatingsTable(i,3:17),"all");
    rowMeans{i} = rowMean;
end
    rowMeans = vertcat(rowMeans{:});

% generate a table for MDS 

 stimulusTable = array2table([meanRatingsTable.Stimulus1,meanRatingsTable.Stimulus2],"VariableNames",{'Stimulus1','Stimulus2'});
 MDStable = [stimulusTable,rowMeans];

 %generate dissimilarity matrix

    stimuliIDs = unique([meanRatingsTable.Stimulus1; meanRatingsTable.Stimulus2]); % get unique stimulus IDs
    
    dissimilarityMatrix = []; % 20X20 matrix

    for i= 1:height(meanRatingsTable)

        % go through all the rows, get stimuli and their dissimilarity
        % score

        stimulus1 = MDStable.Stimulus1(i);
        stimulus2 = MDStable.Stimulus2(i);
        dissimilarityScore = MDStable.mean(i);

        % find which unique stimuli ID 

        stim1 = find(stimuliIDs == stimulus1);
        stim2 = find(stimuliIDs == stimulus2);

        dissimilarityMatrix(stim1, stim2) = dissimilarityScore;
        dissimilarityMatrix(stim2, stim1) = dissimilarityScore; % for the symetric matrix
    end

    % convert your matrix into a distance matrix 
    % higher values = longer the distance & lower values = closer the
    % distance 

 constant = max(dissimilarityMatrix(:)); % highest value 
 distanceMatrix = constant - dissimilarityMatrix;  

  coloumnNames = {};
  rowNames = {};

        for i = 1: height(distanceMatrix)
            coloumnNames{i} = ['Stimulus',num2str(i)];
            rowNames{i}=['Stimulus',num2str(i)];
        end

distanceTable = array2table(distanceMatrix,'VariableNames',coloumnNames,'RowNames',rowNames);

%save your original distance matrices

if strcmp(Datatype,'Object')
    filename = 'ObjectDistanceMatrix.mat';
elseif strcmp(Datatype,'Face')
    filename = 'FaceDistanceMatrix.mat';
end

fullPath = fullfile(processedDataPath, filename);

save(fullPath,'distanceTable')

% before computing MDS, be sure that distance between the same stimuli is 0

for i = 1:height(distanceMatrix)
            distanceMatrix(i, i) = 0;
end

%compute classic metric MDS 

MDScell = {};

if strcmp(Datatype,'Object')
    [Y, eigvals] = cmdscale(distanceMatrix); %Y = coordinates
    MDScell = {Y,eigvals,Datatype};
    
elseif strcmp(Datatype,'Face')
    [Y, eigvals] = cmdscale(distanceMatrix);
    MDScell = {Y,eigvals,Datatype};
end
    
end
