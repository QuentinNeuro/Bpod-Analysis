function Analysis=AP_DataCore_Photometry(Analysis,SessionData)

%% Parameters  
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
nTrials=Analysis.Parameters.Behavior.nTrials;
decimateFactor=Analysis.Parameters.Data.NidaqDecimateFactor;
sampRate=Analysis.Parameters.Data.NidaqSamplingRate;
duration=SessionData.TrialSettings(1).GUI.NidaqDuration;
phase=Analysis.Parameters.Photometry.Phase;

%% Data extraction
for t=1:nTrials
for c=1:nbOfChannels
    thisData=NaN(1,duration*sampRate/decimateFactor);
    thisNidaqField=Analysis.Parameters.Photometry.NidaqField{c};

    if Analysis.Parameters.Photometry.Modulation 
        thisAmp=SessionData.TrialSettings(t).GUI.(Analysis.Parameters.Photometry.AmpField{c});
        if thisAmp
            thisFreq=SessionData.TrialSettings(t).GUI.(Analysis.Parameters.Photometry.FreqField{c});
            thisRawData=SessionData.(thisNidaqField){1,t}(:,1);
            thisData=AP_Demodulation(thisRawData,sampRate,thisFreq,15,phase);
        end
    else        % no modulation of this channel for this trial
        if ~isfield(SessionData,'DecimatedSampRate')
            thisData=SessionData.(thisNidaqField){1,t}(:,1);
        else % Archived file
            thisData=SessionData.(thisNidaqField){1,t}(:,Analysis.Parameters.Photometry.ModulData(c)-1)';
            if size(thisData,2)==1
                thisData=SessionData.(thisNidaqField){1,t}(Analysis.Parameters.Photometry.ModulData(c)-1,:);
            end
        end
    end
    if ~isnan(thisData)
    thisData=decimate(thisData,decimateFactor);
    end
    dataTrial{t}(c,:)=thisData;
end  
end

%% Save in Analysis structure
Analysis.Core.Photometry=dataTrial;
end