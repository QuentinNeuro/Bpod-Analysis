function Analysis=AP_DataProcess_Photometry(Analysis,thisTrial)

%% Timing
TimeToZero=Analysis.AllData.Time.Zero(thisTrial);
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;

TimeWindow=Analysis.Parameters.ReshapedTime;
SamplingRate=Analysis.Parameters.NidaqDecimatedSR;
Baseline=Analysis.Parameters.NidaqBaselinePoints; 

%% Data processing
for thisCh=1:length(Analysis.Parameters.PhotoCh)
Data=Analysis.Core.Photometry{thisTrial}{thisCh};
if Analysis.Parameters.BaselineBefAft==1
    DFFBaseline=AP_Baseline(Analysis,Data,Baseline);
    DFFSTD=std(Data(Baseline(1):Baseline(2)));    
end
% Extract desired time window
[Time,Data]=AP_TimeReshaping(Data,TimeWindow,TimeToZero,SamplingRate);
if Analysis.Parameters.BaselineBefAft==2
    DFFBaseline=AP_Baseline(Analysis,Data,Baseline);
    DFFSTD=std(Data(Baseline(1):Baseline(2)));    
end
% Zscore or DFF
if Analysis.Parameters.Zscore
    DFF=(Data-DFFBaseline)/DFFSTD;
else
DFF=100*(Data-DFFBaseline)/DFFBaseline;
end
if Analysis.Parameters.ZeroAtZero
    DFF=DFF-mean(DFF(Time>-0.1 & Time<=0));
end  

%% Statistics for Analysis Structure
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    Analysis.AllData.(thisChStruct).Name                                =Analysis.Parameters.PhotoChNames{thisCh};
    Analysis.AllData.(thisChStruct).Time(thisTrial,:)                   =Time;          
    Analysis.AllData.(thisChStruct).DFF(thisTrial,:)                    =DFF;
    Analysis.AllData.(thisChStruct).Baseline(thisTrial)                 =DFFBaseline;
    % AVG/MAX
    Analysis.AllData.(thisChStruct).CueAVG(thisTrial)      =nanmean(DFF(Time>CueTime(1) & Time<CueTime(2)));
    Analysis.AllData.(thisChStruct).CueMAX(thisTrial)      =max(DFF(Time>CueTime(1) & Time<CueTime(2)));
    Analysis.AllData.(thisChStruct).OutcomeAVG(thisTrial)  =nanmean(DFF(Time>OutcomeTime(1) & Time<OutcomeTime(2)));
    Analysis.AllData.(thisChStruct).OutcomeMAX(thisTrial)  =max(DFF(Time>OutcomeTime(1) & Time<OutcomeTime(2)));    
    % Zero
    Analysis.AllData.(thisChStruct).Z4Cue(thisTrial)        =nanmean(DFF(Time>CueTime(1)-0.2 & Time<CueTime(1)-0.01));
    Analysis.AllData.(thisChStruct).Z4Outcome(thisTrial)    =nanmean(DFF(Time>OutcomeTime(1)-0.2 & Time<OutcomeTime(1)-0.01));
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