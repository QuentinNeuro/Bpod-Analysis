 function Analysis=AP_DataProcess_Photometry(Analysis,thisTrial)

%% Timing
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
cueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.Timing.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.Timing.OutcomeTimeReset;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;
fitTest=Analysis.Parameters.Photometry.Fit_470405;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);

%% Data processing
for thisCh=1:nbOfChannels
    thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    data=Analysis.Core.Photometry{thisTrial}{thisCh};
    baselineAVG=Analysis.AllData.(thisChStruct).BaselineAVG(thisTrial);
    baselineSTD=Analysis.AllData.(thisChStruct).BaselineSTD(thisTrial);    
    % Extract desired time window
    [time,data]=AP_PSTH(data,PSTH_TW,timeToZero,sampRate);
    % DFF / z-scoring
    if fitTest && thisCh==1
        try
        [time,data405]=AP_PSTH(Analysis.Core.Photometry{thisTrial}{2},PSTH_TW,timeToZero,sampRate);
        p=Analysis.Parameters.PhotometryFit;
        data405=data405*p(1)+p(2);
        data=100*(data-data405)./data405;
        catch
            data=100*(data-baselineAVG)/baselineAVG;
        end
    else
    data=data-baselineAVG;
    if Analysis.Parameters.Data.Zscore
        data=data/baselineSTD;
    else
        data=100*data/baselineAVG;
    end
    end
    switch Analysis.Parameters.Timing.ZeroAt
        case 'Zero'
            data=data-mean(data(time>-0.1 & time<0),'omitnan');
        case '2sBefCue'
            data=data-mean(data(time>cueTime(1)-2.2 & time<=cueTime(1)-1.8),'omitnan');
        otherwise
            if isnumeric(Analysis.Parameters.Timing.ZeroAt)
                thisZeroTime=Analysis.Parameters.Timing.ZeroAt;
                data=data-mean(data(time>thisZeroTime-0.1 & time<=thisZeroTime+0.1),'omitnan');
            end
    end  

%% Statistics for Analysis Structure
    Analysis.AllData.(thisChStruct).Name                                =Analysis.Parameters.Data.Label{thisCh};
    Analysis.AllData.(thisChStruct).Time(thisTrial,:)                   =time;          
    Analysis.AllData.(thisChStruct).Data(thisTrial,:)                   =data;
    % Analysis.AllData.(thisChStruct).Baseline(thisTrial)                 =DFFBaseline;
    % AVG/MAX
    Analysis.AllData.(thisChStruct).CueAVG(thisTrial)      =mean(data(time>cueTime(1) & time<cueTime(2)),'omitnan');
    Analysis.AllData.(thisChStruct).CueMAX(thisTrial)      =max(data(time>cueTime(1) & time<cueTime(2)));
    Analysis.AllData.(thisChStruct).OutcomeAVG(thisTrial)  =mean(data(time>outcomeTime(1) & time<outcomeTime(2)),'omitnan');
    Analysis.AllData.(thisChStruct).OutcomeMAX(thisTrial)  =max(data(time>outcomeTime(1) & time<outcomeTime(2)));    
    % Zero
    Analysis.AllData.(thisChStruct).Z4Cue(thisTrial)        =mean(data(time>cueTime(1)-0.2 & time<cueTime(1)-0.01),'omitnan');
    Analysis.AllData.(thisChStruct).Z4Outcome(thisTrial)    =mean(data(time>outcomeTime(1)-0.2 & time<outcomeTime(1)-0.01),'omitnan');
    Analysis.AllData.(thisChStruct).CueAVGZ(thisTrial)                     =Analysis.AllData.(thisChStruct).CueAVG(thisTrial)...
                                                         - Analysis.AllData.(thisChStruct).Z4Cue(thisTrial);
    Analysis.AllData.(thisChStruct).CueMAXZ(thisTrial)                     =Analysis.AllData.(thisChStruct).CueMAX(thisTrial)...
                                                         -Analysis.AllData.(thisChStruct).Z4Cue(thisTrial);
    Analysis.AllData.(thisChStruct).OutcomeAVGZ(thisTrial)                 =Analysis.AllData.(thisChStruct).OutcomeAVG(thisTrial)...
                                                        -Analysis.AllData.(thisChStruct).Z4Outcome(thisTrial);
    Analysis.AllData.(thisChStruct).OutcomeMAXZ(thisTrial)                 =Analysis.AllData.(thisChStruct).OutcomeMAX(thisTrial)...
                                                        -Analysis.AllData.(thisChStruct).Z4Outcome(thisTrial);
                                                                                       
end
end