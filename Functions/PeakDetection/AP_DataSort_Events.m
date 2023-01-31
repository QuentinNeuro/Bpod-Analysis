function Analysis=AP_DataSort_Events(Analysis,thisType)
%% Parameters
nTrials=Analysis.AllData.nTrials;
trialNbs=Analysis.(thisType).TrialNumbers;

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    %% Structure path
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    thisPeakStruct=[thisChStruct '_peak'];
    thisPeakStats=Analysis.(thisType).(thisPeakStruct);
    thisTrialIdx=ismember(thisPeakStats.trials,trialNbs);
    
    peakField1=fieldnames(thisPeakStats);
    for thisF1=1:size(peakField1,1)
        thisField1=peakField1{thisF1};
        if size(thisPeakStats.(thisField1),2)==length(thisTrialIdx)
            thisPeakStats.(thisField1)=thisPeakStats.(thisField1)(:,thisTrialIdx);
        elseif size(thisPeakStats.(thisField1))==[1 1]
            peakField2=fieldnames(thisPeakStats.(thisField1));
                for thisF2=1:size(peakField2,1)
                    thisField2=peakField2{thisF2};
                    switch size(thisPeakStats.(thisField1).(thisField2),2)
                        case length(thisTrialIdx)
                            thisPeakStats.(thisField1).(thisField2)=thisPeakStats.(thisField1).(thisField2)(:,thisTrialIdx);
                        case nTrials
                            thisPeakStats.(thisField1).(thisField2)=thisPeakStats.(thisField1).(thisField2)(:,trialNbs);
                    end
                end
        end
    end
    Analysis.(thisType).(thisPeakStruct)=thisPeakStats;
end      
end