function Analysis=AB_DataProcess_Events(Analysis)

%% Parameters
cellID=Analysis.Parameters.Photometry.CellID;
nCells=size(cellID,2);

if ~ischar(Analysis.Parameters.EventDetection.MinTW)
    thisTW=Analysis.Parameters.EventDetection.MinTW*Analysis.Parameters.Photometry.SamplingRateDecimated;
else
    thisTW=Analysis.Parameters.EventDetection.MinTW;
end
thisTW_WV=Analysis.Parameters.Photometry.SamplingRateDecimated*Analysis.Parameters.EventDetection.waveform_TW;
localMiniFactor=Analysis.Parameters.EventDetection.MinFactor;

%% Loop over channels and sessions
for c=1:nCells
    thisID=cellID{c};
    thisPeakStruct=[thisID '_events'];
    for thisS=1:max(Analysis.AllData.Session)
        thisSession=Analysis.AllData.Session==thisS;
        thisData=Analysis.AllData.(thisID).Data(thisSession,:);
        thisTime=Analysis.AllData.(thisID).Time(thisSession,:);
        thisThreshold=std(thisData(:),'omitnan')*Analysis.Parameters.EventDetection.ThreshFactor;
% Peak detection
        thisPeaks=AB_Events(thisTime,thisData,'miniLocal',thisThreshold,thisThreshold*localMiniFactor,thisTW,thisTW_WV,0);
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