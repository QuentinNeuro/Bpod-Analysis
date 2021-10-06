function Analysis=AP_Event_Detection(Analysis)
% Identify and analyze photometry events for single sessions. Concatenate 
% across sessions to store back into Analysis.AllData structure.

%% Event Detection
trialNames          =Analysis.Parameters.TrialNames;
subFilters          =Analysis.Filters;
for thisCh          =1:length(Analysis.Parameters.PhotoCh)
    thisChStruct    =sprintf('Photo_%s',                                ...
                     char(Analysis.Parameters.PhotoCh{thisCh}));
    for session     =1:max(Analysis.Core.Session)
        thisSesh    =find(Analysis.Core.Session==session);
        thisCue     =Analysis.AllData.Time.Cue(thisSesh(1),1);
        thisData    =AP_Find_Peaks(Analysis.AllData.(thisChStruct),thisSesh);
        thisData    =AP_Analyze_Peaks(thisData,thisCue,trialNames,subFilters,thisSesh);
        if session  ==1
        concatData  =[];
        end
        concatData  =AP_Concat_Sessions(thisData,concatData,session);
    end
    Analysis.AllData.(thisChStruct) =concatData;
end