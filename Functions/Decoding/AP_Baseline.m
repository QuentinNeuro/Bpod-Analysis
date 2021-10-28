function Analysis=AP_Baseline(Analysis)

BaselinePts=Analysis.Parameters.NidaqBaselinePoints;
Cutoff=Analysis.Parameters.BaselineHistoParam/100;
movBaseParam=Analysis.Parameters.BaselineMov;

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    BaselineAVG=nan(Analysis.AllData.nTrials,1);
    BaselineSTD=nan(Analysis.AllData.nTrials,1);
    for thisT=1:Analysis.AllData.nTrials
        Data=Analysis.Core.Photometry{thisT}{thisCh};
        DataBaseline=Data(BaselinePts(1):BaselinePts(2));
        if Analysis.Parameters.BaselineHisto
            DataBaselineSort=sort(DataBaseline);
            BaselinePtsHisto=round(length(DataBaseline)*Cutoff);
            BaselineAVG(thisT)=nanmean(DataBaseline(1:BaselinePtsHisto));
            BaselineSTD(thisT)=nanstd(DataBaseline(1:BaselinePtsHisto));
        else
        BaselineAVG(thisT)=nanmean(DataBaseline);
        BaselineSTD(thisT)=nanstd(DataBaseline);
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