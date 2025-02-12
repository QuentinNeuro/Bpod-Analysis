 function Analysis=AP_DataProcess_Photometry(Analysis)

%% Timing
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
nTrials=Analysis.Parameters.Behavior.nTrials;

%% Data processing
for c=1:nbOfChannels
    dataTrial=[];
    timeTrial=[];
    thisC_Name=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    for t=1:nTrials
        data=Analysis.Core.Photometry{t}{thisCh};
        % PSTHs
        [time,data]=AP_PSTH(data,PSTH_TW,timeToZero(t),sampRate);
        dataTrial(t,:)=data;
        timeTrial(t,:)=time;
    end
    %% Statistics for Analysis Structure
    Analysis.AllData.(thisC_Name).Name                   =Analysis.Parameters.Data.Label{thisCh};
    Analysis.AllData.(thisC_Name).Time                   =timeTrial;          
    Analysis.AllData.(thisC_Name).Data                   =dataTrial;
end
end