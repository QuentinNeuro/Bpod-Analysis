function Analysis=AP_DataProcess_Events(Analysis)

%% Parameters
if ~ischar(Analysis.Parameters.EventMinTW)
    thisTW=Analysis.Parameters.EventMinTW*Analysis.Parameters.NidaqDecimatedSR;
else
    thisTW=Analysis.Parameters.EventMinTW;
end
thisTW_WV=Analysis.Parameters.NidaqDecimatedSR*Analysis.Parameters.EventWV;

%% Loop over channels and sessions
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    thisPeakStruct=[thisChStruct '_peak'];
    for thisS=1:max(Analysis.AllData.Session)
        thisSession=Analysis.AllData.Session==thisS;
        thisData=Analysis.AllData.(thisChStruct).DFF(thisSession,:);
        thisTime=Analysis.AllData.(thisChStruct).Time(thisSession,:);
        thisThreshold=std(thisData(:),'omitnan')*Analysis.Parameters.EventThreshFactor;
% Peak detection
        thisPeaks=AP_Events(thisTime,thisData,'miniLocal',thisThreshold,thisThreshold*Analysis.Parameters.EventMinFactor,thisTW,thisTW_WV,0);

        if thisS==1
            Analysis.AllData.(thisPeakStruct)=thisPeaks;
        else
            thisPeaks.trials=thisPeaks.trials+max(Analysis.AllData.(thisPeakStruct).trials);
            thisPeaks.session=thisPeaks.session+max(Analysis.AllData.(thisPeakStruct).session);
            peakFields=fieldnames(thisPeaks);
            for thisF=1:size(peakFields,1)
                thisField=peakFields{thisF};
                Analysis.AllData.(thisPeakStruct).(thisField)=[Analysis.AllData.(thisPeakStruct).(thisField) thisPeaks.(thisField)];
            end
        end
    end
end
end