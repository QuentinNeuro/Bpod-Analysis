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
modTest=Analysis.Parameters.Photometry.Modulation;
if Analysis.Parameters.Photometry.Archive && modTest
    modTest=0;
end
multiplex=Analysis.Parameters.Photometry.Multiplex; %used for 405 and archived data

%  Sampling Rate
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
    thisDataField=Analysis.Parameters.Photometry.DataField{c};
for t=1:nTrials
% Trial specific parameters    
    duration=SessionData.TrialSettings(t).GUI.NidaqDuration;
    thisAmp=SessionData.TrialSettings(t).GUI.(ampField{c});
    thisFreq=SessionData.TrialSettings(t).GUI.(freqField{c});
% Access date in sessionData file : deal with modulation, archived etc.
    if thisAmp
        switch modTest
            case 1
                if Analysis.Parameters.Photometry.Version<2
                    thisData=SessionData.(thisDataField){t}(:,1);
                else
                    thisData=SessionData.Photometry.Data.(thisDataField){t}(:,1);
                end
                    thisData=AB_Demodulation(thisData,sampRate,thisFreq,15,phase);
                    thisData=decimate(thisData,decimateFactor);
            case 0
                if Analysis.Parameters.Photometry.Version<2
                    thisData=SessionData.(thisDataField){t}(:,multiplex(c));
                else
                    thisData=SessionData.Photometry.Data.(thisDataField){t}(:,multiplex(c));
                end
        end
    else
        thisData=NaN(1,duration*sampRate/decimateFactor);
    end
    dataTrial{t+nTrialsOffset}(c,:)=thisData;
end
end
end 
%% Save in Analysis structure
Analysis.Core.Photometry=dataTrial;
end