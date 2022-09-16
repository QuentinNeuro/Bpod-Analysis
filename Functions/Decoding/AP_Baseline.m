function Analysis=AP_Baseline(Analysis)

BaselinePts=Analysis.Parameters.NidaqBaselinePoints;
movBaseParam=Analysis.Parameters.BaselineMov;

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    BaselineAVG=nan(Analysis.AllData.nTrials,1);
    BaselineSTD=nan(Analysis.AllData.nTrials,1);
    for thisT=1:Analysis.AllData.nTrials
        Data=Analysis.Core.Photometry{thisT}{thisCh};
        DataBaseline=Data(BaselinePts(1):BaselinePts(2));
        if Analysis.Parameters.BaselineHisto
            Cutoff=Analysis.Parameters.BaselineHisto/100;
            DataBaselineSort=sort(DataBaseline);
            BaselinePtsHisto=round(length(DataBaseline)*Cutoff);
            BaselineAVG(thisT)=mean(DataBaseline(1:BaselinePtsHisto),'omitnan');
            BaselineSTD(thisT)=std(DataBaseline(1:BaselinePtsHisto),'omitnan');
        else
        BaselineAVG(thisT)=mean(DataBaseline,'omitnan');
        BaselineSTD(thisT)=std(DataBaseline,'omitnan');
        end
    end
    
    if Analysis.Parameters.BaselineMov
    for thisS=1:max(Analysis.Core.Session)  
        BaselineAVG(Analysis.Core.Session==thisS)=movmean(BaselineAVG(Analysis.Core.Session==thisS),movBaseParam,'omitnan');
        BaselineSTD(Analysis.Core.Session==thisS)=movmean(BaselineSTD(Analysis.Core.Session==thisS),movBaseParam,'omitnan');
    end
    end
    Analysis.AllData.(thisChStruct).BaselineAVG=BaselineAVG;
    Analysis.AllData.(thisChStruct).BaselineSTD=BaselineSTD;
end
end