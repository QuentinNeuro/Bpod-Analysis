function Analysis=AP_Photometry_Baseline(Analysis)

BaselinePts=Analysis.Parameters.Data.NidaqBaselinePoints;
movBaseParam=Analysis.Parameters.Data.BaselineMov;
dt=1/Analysis.Parameters.Data.NidaqDecimatedSR;
stateToZero=Analysis.Parameters.Timing.StateToZero;
tw=Analysis.Parameters.Timing.PSTH;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);

for thisCh=1:nbOfChannels
    thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    BaselineAVG=nan(Analysis.AllData.nTrials,1);
    BaselineSTD=nan(Analysis.AllData.nTrials,1);
    for thisT=1:Analysis.AllData.nTrials
        try
        Data=Analysis.Core.Photometry{thisT}{thisCh};
        switch Analysis.Parameters.Data.BaselineBefAft
            case 1 % Baseline calculated from start of recording
                DataBaseline=Data(BaselinePts(1):BaselinePts(2));
            case 2 % Baseline calculated from start of time window
                time=[0:1:length(Data)-1]*dt;
                timeZ=time-Analysis.Core.States{1,thisT}.(stateToZero)(1);
                timeZ_IO=false(size(timeZ));
                timeZ_IO(timeZ>=tw(1) & timeZ<=tw(2))=true;
                dataTW=Data(timeZ_IO);
                DataBaseline=dataTW(BaselinePts(1):BaselinePts(2));
            if isnan(DataBaseline)
                nanIdx=~isnan(dataTW);
                DataBaseline=dataTW(find(nanIdx,diff(BaselinePts)));
            end
        end
        if Analysis.Parameters.Data.BaselineHisto
            Cutoff=Analysis.Parameters.Data.BaselineHisto/100;
            DataBaselineSort=sort(DataBaseline);
            BaselinePtsHisto=round(length(DataBaseline)*Cutoff);
            BaselineAVG(thisT)=mean(DataBaseline(1:BaselinePtsHisto),'omitnan');
            BaselineSTD(thisT)=std(DataBaseline(1:BaselinePtsHisto),'omitnan');
        else
        BaselineAVG(thisT)=mean(DataBaseline,'omitnan');
        BaselineSTD(thisT)=std(DataBaseline,'omitnan');
        end
        catch
            disp('error in photometry baseline calculation')
    end
    end
    
    if movBaseParam
    for thisS=1:max(Analysis.Core.Session)  
        BaselineAVG(Analysis.Core.Session==thisS)=movmean(BaselineAVG(Analysis.Core.Session==thisS),movBaseParam,'omitnan');
        BaselineSTD(Analysis.Core.Session==thisS)=movmean(BaselineSTD(Analysis.Core.Session==thisS),movBaseParam,'omitnan');
    end
    end
    Analysis.AllData.(thisChStruct).BaselineAVG=BaselineAVG;
    Analysis.AllData.(thisChStruct).BaselineSTD=BaselineSTD;
end
end