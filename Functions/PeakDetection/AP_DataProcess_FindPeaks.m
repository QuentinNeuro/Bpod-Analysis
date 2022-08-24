function Analysis=AP_DataProcess_FindPeaks(Analysis)

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    thisPeakStruct=[thisChStruct '_peak'];
    for thisS=1:max(Analysis.AllData.Session)
        thisSession=Analysis.AllData.Session==thisS;
        thisData=Analysis.AllData.(thisChStruct).DFF(thisSession,:);
        thisTime=Analysis.AllData.(thisChStruct).Time(thisSession,:);
        thisPeaks=AP_FindPeak(thisData,thisTime,90,50);
        if thisS==1
            Analysis.AllData.(thisPeakStruct)=thisPeaks;
        else
            peakFields=fieldnames(thisPeaks);
            for thisF=1:size(peakFields,1)
                thisField=peakFields(thisF);
                Analysis.AllData.(thisPeakStruct).(thisField)=[Analysis.AllData.(thisPeakStruct).(thisField) thisPeaks.(thisField)];
            end
        end
    end
    
    peakTime=Analysis.AllData.Photo_470_peak.ptimes;
    peakAmp=Analysis.AllData.Photo_470_peak.pproms;
    peakTimeTest=peakTime>0 & peakTime<2;
% %     
%     baseAmp=nan()
%     baseTime
%     cueAmp
%     cueTime
%     outAmp
%     outTime
    

    % jitter ?
    % first peak after cue ?
    % randome peak during baseline ?
end
end