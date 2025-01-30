function Analysis=AP_DataSort_Photometry(Analysis,thistype)

%% Parameters
CueTime=Analysis.(thistype).Time.Cue(1,:)+Analysis.Parameters.Timing.CueTimeReset;
OutcomeTime=Analysis.(thistype).Time.Outcome(1,:)+Analysis.Parameters.Timing.OutcomeTimeReset;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
avgStats={'CueAVG','CueAVGZ','CueMAX','CueMAXZ','OutcomeAVG','OutcomeAVGZ','OutcomeMAX','OutcomeMAXZ'};
idxSession=Analysis.(thistype).Session;
%% Data
for thisCh=1:nbOfChannels
    thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    Time=Analysis.(thistype).(thisChStruct).Time(1,:);
% Average
    Analysis.(thistype).(thisChStruct).DataAVG       =mean(Analysis.(thistype).(thisChStruct).Data,1,'omitnan'); 
    Analysis.(thistype).(thisChStruct).DataSEM       =std(Analysis.(thistype).(thisChStruct).Data,0,1,'omitnan')/sqrt(Analysis.(thistype).nTrials);
    
    for thisAS=avgStats
        charAS=char(thisAS);
        Analysis.(thistype).(thisChStruct).(strcat(charAS,'_AVG'))=mean(Analysis.(thistype).(thisChStruct).(charAS),2,'omitnan');
        Analysis.(thistype).(thisChStruct).(strcat(charAS,'_SEM'))=std(Analysis.(thistype).(thisChStruct).(charAS),0,2,'omitnan')/sqrt(Analysis.(thistype).nTrials);
        if length(idxSession)>1
        for thisS=1:max(idxSession)
        Analysis.(thistype).(thisChStruct).(strcat(charAS,'_AVG_S'))(thisS)=mean(Analysis.(thistype).(thisChStruct).(charAS)(idxSession==thisS),2,'omitnan');
        Analysis.(thistype).(thisChStruct).(strcat(charAS,'_SEM_S'))(thisS)=std(Analysis.(thistype).(thisChStruct).(charAS)(idxSession==thisS),0,2,'omitnan')/sqrt(sum(idxSession==thisS));
        end
        else
            Analysis.(thistype).(thisChStruct).(strcat(charAS,'_AVG_S'))=Analysis.(thistype).(thisChStruct).(charAS);
            Analysis.(thistype).(thisChStruct).(strcat(charAS,'_SEM_S'))=0;
        end
    end
    Analysis.(thistype).(thisChStruct).CueAVG_MAX       =max(Analysis.(thistype).(thisChStruct).DataAVG(Time>CueTime(1) & Time<CueTime(2)));
    Analysis.(thistype).(thisChStruct).CueAVG_MAXZ      =Analysis.(thistype).(thisChStruct).CueAVG_MAX-mean(Analysis.(thistype).(thisChStruct).DataAVG(Time>CueTime(1)-0.2 & Time<CueTime(1)-0.01),'omitnan'); 
    Analysis.(thistype).(thisChStruct).OutcomeAVG_MAX   =max(Analysis.(thistype).(thisChStruct).DataAVG(Time>OutcomeTime(1) & Time<OutcomeTime(2))); 
    Analysis.(thistype).(thisChStruct).OutcomeAVG_MAXZ  =Analysis.(thistype).(thisChStruct).OutcomeAVG_MAX-mean(Analysis.(thistype).(thisChStruct).DataAVG(Time>OutcomeTime(1)-0.2 & Time<OutcomeTime(1)-0.01),'omitnan'); 

    % Fit
if Analysis.Parameters.Plot.FiltersBehavior 
     model=fitlm(Analysis.(thistype).(thisChStruct).OutcomeStat,Analysis.(thistype).(thisChStruct).CueStat);
%        Analysis.(thistype).(thisChStruct).Fit.XData=Analysis.(thistype).(thisChStruct).OutcomeStat;
     Analysis.(thistype).(thisChStruct).Fit.YFit=model.Fitted;
     Analysis.(thistype).(thisChStruct).Fit.Function=model.Coefficients.Estimate;
     Analysis.(thistype).(thisChStruct).Fit.Rsquared=model.Rsquared.Ordinary;
     Analysis.(thistype).(thisChStruct).Fit.Pvalue=model.Coefficients.pValue(2); 
% Cumulatives
     Analysis.(thistype).(thisChStruct).Cumul.Prob=(1:Analysis.(thistype).nTrials)/Analysis.(thistype).nTrials; 
     Analysis.(thistype).(thisChStruct).Cumul.CueSort=sort(Analysis.(thistype).(thisChStruct).CueStat);
     Analysis.(thistype).(thisChStruct).Cumul.OutcomeSort=sort(Analysis.(thistype).(thisChStruct).OutcomeStat);    
end
%
end