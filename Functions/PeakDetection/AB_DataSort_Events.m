function Analysis=AB_DataSort_Events(Analysis,thisType)
%% Parameters
trialNbs=Analysis.(thisType).TrialNumbers;
epochNames=Analysis.Parameters.EventDetection.EpochNames;
epochTW=Analysis.Parameters.EventDetection.EpochTW;
cellID=Analysis.Parameters.Photometry.CellID;
nCells=size(cellID,2);

for c=1:nCells
    thisID=cellID{c};
    thisPeakStruct=[thisID '_events'];
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

    thisPeakStats=AB_Events_Epochs(thisPeakStats,epochTW,epochNames);

    Analysis.(thisType).(thisPeakStruct)=thisPeakStats;
end      
end