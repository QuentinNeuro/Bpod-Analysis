function Analysis=AB_DataCore_Photometry(Analysis,SessionData)
%% Parameters  
% Trial Nbs
nSessions=Analysis.Parameters.Behavior.nSessions;
nTrials=Analysis.Parameters.Behavior.nTrials(nSessions);
nTrialsOffset=0;
if nSessions>1
    nTrialsOffset=sum(Analysis.Parameters.Behavior.nTrials)-nTrials;
end
if isfield(Analysis.Core,'Photometry')
    dataTrial=Analysis.Core.Photometry;
end

% Data
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
phase=Analysis.Parameters.Photometry.Phase;
ampField=Analysis.Parameters.Photometry.AmpField;
freqField=Analysis.Parameters.Photometry.FreqField;
nidaqField=Analysis.Parameters.Photometry.NidaqField;

% Sampling Rate
sampRate=Analysis.Parameters.Photometry.SamplingRate;
sampRateDecimated=Analysis.Parameters.Data.SamplingRateDecimated;
if sampRate<sampRateDecimated
    disp('Error in decimating core photometry data : sampling Rate is lower than requested decimated sampling rate')
    sampRateDecimated=sampRate;
end
Analysis.Parameters.Photometry.SamplingRateDecimated=sampRateDecimated;
decimateFactor=ceil(sampRate/sampRateDecimated);

%% Data extraction
if Analysis.Parameters.Photometry.Photometry(nSessions)
for c=1:nbOfChannels
    thisNidaqField=Analysis.Parameters.Photometry.PhotoField{c};
for t=1:nTrials
    duration=SessionData.TrialSettings(t).GUI.NidaqDuration;
    thisData=NaN(1,duration*sampRate/decimateFactor);
    if Analysis.Parameters.Photometry.Modulation 
        thisAmp=SessionData.TrialSettings(t).GUI.(ampField{c});
        if thisAmp
            thisFreq=SessionData.TrialSettings(t).GUI.(freqField{c});
            thisRawData=SessionData.(thisNidaqField){1,t}(:,1);
            thisData=AB_Demodulation(thisRawData,sampRate,thisFreq,15,phase);
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
    dataTrial{t+nTrialsOffset}(c,:)=thisData;
end  
end

%% Save in Analysis structure
Analysis.Core.Photometry=dataTrial;
end
end