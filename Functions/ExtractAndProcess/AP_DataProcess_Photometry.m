 function Analysis=AP_DataProcess_Photometry(Analysis,thisTrial)

%% Timing
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
cueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;

timeWindow=Analysis.Parameters.ReshapedTime;
sampRate=Analysis.Parameters.NidaqDecimatedSR;

%% Data processing
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    data=Analysis.Core.Photometry{thisTrial}{thisCh};
    baselineAVG=Analysis.AllData.(thisChStruct).BaselineAVG(thisTrial);
    baselineSTD=Analysis.AllData.(thisChStruct).BaselineSTD(thisTrial);    
    % Extract desired time window
    [time,data]=AP_PSTH(data,timeWindow,timeToZero,sampRate);
    % DFF / z-scoring
    data=data-baselineAVG;
    if Analysis.Parameters.Zscore
        data=data/baselineSTD;
    else
        data=100*data/baselineAVG;
    end
    switch Analysis.Parameters.ZeroAt
        case 'Zero'
            data=data-mean(data(time>-0.1 & time<=0),'omitnan');
        case '2sBefCue'
            data=data-mean(data(time>cueTime(1)-2.2 & time<=cueTime(1)-1.8),'omitnan');
        otherwise
            if isnumeric(Analysis.Parameters.ZeroAt)
                thisZeroTime=Analysis.Parameters.ZeroAt;
                data=data-mean(data(time>thisZeroTime-0.2 & time<=thisZeroTime+0.2),'omitnan');
            end
    end  

%% Statistics for Analysis Structure
    Analysis.AllData.(thisChStruct).Name                                =Analysis.Parameters.PhotoChNames{thisCh};
    Analysis.AllData.(thisChStruct).Time(thisTrial,:)                   =time;          
    Analysis.AllData.(thisChStruct).DFF(thisTrial,:)                    =data;
%     Analysis.AllData.(thisChStruct).Baseline(thisTrial)                 =DFFBaseline;
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
    switch Analysis.Parameters.CueStats
        case 'AVG';     CueStat=Analysis.AllData.(thisChStruct).CueAVG; 
        case 'AVGZ';    CueStat=Analysis.AllData.(thisChStruct).CueAVGZ; 
        case 'MAX';     CueStat=Analysis.AllData.(thisChStruct).CueMAX; 
        case 'MAXZ';    CueStat=Analysis.AllData.(thisChStruct).CueMAXZ; 
        otherwise
            disp('unrecognized parameter for cue statistics')
            return
    end
    Analysis.AllData.(thisChStruct).CueStat=CueStat;
    switch Analysis.Parameters.OutcomeStats
        case 'AVG';     OutcomeStat=Analysis.AllData.(thisChStruct).OutcomeAVG; 
        case 'AVGZ';    OutcomeStat=Analysis.AllData.(thisChStruct).OutcomeAVGZ; 
        case 'MAX';     OutcomeStat=Analysis.AllData.(thisChStruct).OutcomeMAX; 
        case 'MAXZ';    OutcomeStat=Analysis.AllData.(thisChStruct).OutcomeMAXZ; 
        otherwise
            disp('unrecognized parameter for cue statistics')
            return
    end
    Analysis.AllData.(thisChStruct).OutcomeStat=OutcomeStat;                                                                                         
end
end