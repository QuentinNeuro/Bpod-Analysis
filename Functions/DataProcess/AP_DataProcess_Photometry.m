 function Analysis=AP_DataProcess_Photometry(Analysis)

%% Parameters
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
nTrials=Analysis.Parameters.Behavior.nTrials;

testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselinePts=Analysis.Parameters.Data.NidaqBaselinePoints;

%% PSTH and baseline extraction
for c=1:nbOfChannels
    dataTrial=[];
    timeTrial=[];
    dataBaseline=[];
    thisC_Name=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    for t=1:nTrials
        data=Analysis.Core.Photometry{t}{thisCh};
        % PSTHs
        [timeTW,dataTW]=AP_PSTH(data,PSTH_TW,timeToZero(t),sampRate);
        dataTrial(t,:)=dataTW;
        timeTrial(t,:)=timeTW;

        % baseline
        switch testBaseline
            case 1
                dataBaseline(t,:)=data(baselinePts(1):baselinePts(2));
            case 2
                dataBaseline(t,:)=dataTW(baselinePts(1):baselinePts(2));
        end
    end
    %% Statistics for Analysis Structure
    Analysis.AllData.(thisC_Name).Name                   =Analysis.Parameters.Data.Label{thisCh};
    Analysis.AllData.(thisC_Name).Time                   =timeTrial;          
    Analysis.AllData.(thisC_Name).Data                   =dataTrial;
    Analysis.AllData.(thisC_Name).DataBaseline           =dataBaseline;
end
end