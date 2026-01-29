function Analysis=AB_DataCore_Wheel(Analysis,SessionData)

%% Create Filter
Analysis=AB_FilterWheel(Analysis);
if isfield(Analysis.Parameters,'Prime')
    testPrime=Analysis.Parameters.Prime.Wheel;
end
if Analysis.Parameters.Wheel.Wheel(end) && ~Analysis.Parameters.Prime.Wheel
%% Parameters
% Trial Nbs
nSessions=Analysis.Parameters.Behavior.nSessions;
nTrials=Analysis.Parameters.Behavior.nTrials(nSessions);
nTrialsOffset=0;
if nSessions>1
    sessionIdx=Analysis.Core.Session;
    nTrialsOffset=length(sessionIdx)-sum(sessionIdx==max(sessionIdx));
end
if isfield(Analysis.Core,'Wheel')
    dataTrial=Analysis.Core.Wheel;
end
% Data
dataField=Analysis.Parameters.Wheel.DataField;
counterNBits=Analysis.Parameters.Wheel.CounterNbits;
encoderCPR=Analysis.Parameters.Wheel.EncoderCPR;
% Sampling Rate
sampRate=Analysis.Parameters.Wheel.SamplingRate;
sampRateDecimated=Analysis.Parameters.Data.SamplingRateDecimated;
if sampRate<sampRateDecimated
    disp('Error in decimating Wheel data : sampling Rate is lower than requested decimated sampling rate')
    sampRateDecimated=sampRate;
end
Analysis.Parameters.Wheel.SamplingRateDecimated=sampRateDecimated;
decimateFactor=ceil(sampRate/sampRateDecimated);   

%% Data extraction
if Analysis.Parameters.Wheel.Version>=2
    dataSession=SessionData.Wheel.Data;
else
    dataSession=SessionData.(dataField);
end
for t=1:nTrials
    if ~isempty(dataSession{t})
        thisData=dataSession{t};
        if ~Analysis.Parameters.Wheel.Archive
            signedThreshold = 2^(counterNBits-1);
            thisData(thisData > signedThreshold) = thisData(thisData > signedThreshold) - 2^counterNBits;
            thisData  = thisData * 360/encoderCPR;
        end
    dataTrial{t+nTrialsOffset}=decimate(thisData,decimateFactor);
    else
    Analysis.Filters.RecWheel(t)=0;
    dataTrial{t+nTrialsOffset}=[];
    end
end
%% Save in Analysis structure
Analysis.Core.Wheel=dataTrial;
end
end