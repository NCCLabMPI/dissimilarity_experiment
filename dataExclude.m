function [cleanData] = dataExclude(analysisData,subjectID)

%this function takes the analysis data and the subject ID that should be
%removed and returns the clean data. 


%find the data of the given participant

comparisonCol = string(analysisData.subjectNumber);

excludeIndex = strcmp(comparisonCol, subjectID);

%exclude the rows belongs to this participant

cleanData = analysisData(~excludeIndex, :);

end