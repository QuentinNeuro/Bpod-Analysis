function Analysis=AP_DataSort_Events(Analysis,thisType)
%% Parameters
nTrials=Analysis.AllData.nTrials;
trialNbs=Analysis.(thisType).TrialNumbers;
epochNames=Analysis.Parameters.EventEpochNames;
epochTW=Analysis.Parameters.EventEpochTW;

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    %% Structure path
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    thisPeakStruct=[thisChStruct '_peak'];
    thisPeakStats=Analysis.(thisType).(thisPeakStruct);
    
    thisTrialIdx=ismember(thisPeakStats.trials,trialNbs);
    
    peakField=fieldnames(thisPeakStats);
    for thisF=1:size(peakField,1)
        thisField=peakField{thisF};
        if size(thisPeakStats.(thisField),2)==length(thisTrialIdx)
            thisPeakStats.(thisField)=thisPeakStats.(thisField)(:,thisTrialIdx);
        end
    end

    thisPeakStats.trials_OG=thisPeakStats.trials;
    trialNbs=unique(thisPeakStats.trials);
    for t=1:length(trialNbs)
        thisPeakStats.trials(thisPeakStats.trials_OG==trialNbs(t))=t;
    end

    thisPeakStats=AP_Events_Epochs(thisPeakStats,epochTW,epochNames);

    Analysis.(thisType).(thisPeakStruct)=thisPeakStats;
end      
end