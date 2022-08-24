 function Analysis=AP_DataProcess_Photometry(Analysis,thisTrial)

%% Timing
TimeToZero=Analysis.AllData.Time.Zero(thisTrial);
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
BaselinePts=Analysis.Parameters.NidaqBaselinePoints;

TimeWindow=Analysis.Parameters.ReshapedTime;
SamplingRate=Analysis.Parameters.NidaqDecimatedSR;

%% Data processing
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    Data=Analysis.Core.Photometry{thisTrial}{thisCh};
        
    % Extract desired time window
    [Time,Data]=AP_TimeReshaping(Data,TimeWindow,TimeToZero,SamplingRate);
    
    if Analysis.Parameters.BaselineBefAft==2
        Analysis.AllData.(thisChStruct).BaselineAVG(thisTrial)=mean(Data(BaselinePts(1):BaselinePts(2)),'omitnan');
        Analysis.AllData.(thisChStruct).BaselineSTD(thisTrial)=std(Data(BaselinePts(1):BaselinePts(2)),'omitnan');
    end
    
    BaselineAVG=Analysis.AllData.(thisChStruct).BaselineAVG(thisTrial);
    BaselineSTD=Analysis.AllData.(thisChStruct).BaselineSTD(thisTrial);
    
    
    Data=Data-BaselineAVG;
    if Analysis.Parameters.Zscore
        Data=Data/BaselineSTD;
    else
        Data=100*Data/BaselineAVG;
    end
    switch Analysis.Parameters.ZeroAt
        case 'Zero'
            Data=Data-mean(Data(Time>-0.1 & Time<=0),'omitnan');
        case 'Start'
            Data=Data-mean(Data(BaselinePts(1):BaselinePts(2)),'omitnan');
    end  

%% Statistics for Analysis Structure
    Analysis.AllData.(thisChStruct).Name                                =Analysis.Parameters.PhotoChNames{thisCh};
    Analysis.AllData.(thisChStruct).Time(thisTrial,:)                   =Time;          
    Analysis.AllData.(thisChStruct).DFF(thisTrial,:)                    =Data;
%     Analysis.AllData.(thisChStruct).Baseline(thisTrial)                 =DFFBaseline;
    % AVG/MAX
    Analysis.AllData.(thisChStruct).CueAVG(thisTrial)      =mean(Data(Time>CueTime(1) & Time<CueTime(2)),'omitnan');
    Analysis.AllData.(thisChStruct).CueMAX(thisTrial)      =max(Data(Time>CueTime(1) & Time<CueTime(2)));
    Analysis.AllData.(thisChStruct).OutcomeAVG(thisTrial)  =mean(Data(Time>OutcomeTime(1) & Time<OutcomeTime(2)),'omitnan');
    Analysis.AllData.(thisChStruct).OutcomeMAX(thisTrial)  =max(Data(Time>OutcomeTime(1) & Time<OutcomeTime(2)));    
    % Zero
    Analysis.AllData.(thisChStruct).Z4Cue(thisTrial)        =mean(Data(Time>CueTime(1)-0.2 & Time<CueTime(1)-0.01),'omitnan');
    Analysis.AllData.(thisChStruct).Z4Outcome(thisTrial)    =mean(Data(Time>OutcomeTime(1)-0.2 & Time<OutcomeTime(1)-0.01),'omitnan');
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