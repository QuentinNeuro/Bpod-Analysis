function Analysis=AP_DataProcess_AOD(Analysis)

%% Parameters
smoothing=Analysis.Parameters.AOD_smooth; 
timeWindow=Analysis.Parameters.ReshapedTime; 
baselinePts=Analysis.Parameters.NidaqBaselinePoints; 
nCells=Analysis.Core.AOD.nCells;
nTrials=Analysis.Core.nTrials;
nSamples=Analysis.Core.AOD.nSamples;
offset=Analysis.Parameters.AOD_offset;
sampRate=Analysis.Core.AOD.sampRate;
% assumes cue and outcome always arrive at the same time once data have
% been zero-ed
CueTime=Analysis.AllData.Time.Cue(1,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(1,:)+Analysis.Parameters.OutcomeTimeReset;

%% Time
time=Analysis.Core.AOD.Time.*ones(nSamples,nTrials);
timeZ=time-Analysis.Core.AOD.Zero;
timeZ_IO=zeros(size(timeZ));
timeZ_IO=logical(timeZ_IO);
timeW=NaN(diff(timeWindow)*ceil(sampRate)+2,nTrials);
for thisT=1:nTrials
    timeZ_IO(timeZ(:,thisT)>=timeWindow(1) & timeZ(:,thisT)<=timeWindow(2),thisT)=true;
    timeW(1:sum(timeZ_IO(:,thisT)),thisT)=timeZ(timeZ_IO(:,thisT),thisT);
end
oneTime=timeW(:,1);
Analysis.AllData.AOD.time=timeW;
%% Data
for thisC=1:nCells
    thisC_Name=sprintf('cell%.0d',thisC);
    thisC_Index=thisC:nCells:nCells*nTrials;
    data=Analysis.Core.AOD.Data(:,thisC_Index);

    if Analysis.Parameters.AOD_raw
        data=data-offset;
        
        baseAVG=nanmean(data(baselinePts(1):baselinePts(2),:),1);
        baseSTD=nanstd(data(baselinePts(1):baselinePts(2),:),[],1);
        if Analysis.Parameters.BaselineMov
            movBaseParam=Analysis.Parameters.BaselineMov;
            baseAVG=movmean(baseAVG,movBaseParam,'omitnan');
            baseSTD=movmean(baseSTD,movBaseParam,'omitnan');
        end
        if Analysis.Parameters.Zscore
            data=(data-baseAVG)./baseSTD;
        else
            data=100*(data-baseAVG)./baseAVG;
        end
    end
    
    dataW=NaN(diff(timeWindow)*ceil(sampRate)+2,nTrials);
    
    for thisT=1:nTrials
        if smoothing
            data(:,thisT)=smooth(data(:,thisT));
        end
        dataW(1:sum(timeZ_IO(:,thisT)),thisT)=data(timeZ_IO(:,thisT),thisT);
    end
    
    Analysis.AllData.AOD.(thisC_Name).Data          =dataW;
    if Analysis.Parameters.AOD_raw
        Analysis.AllData.AOD.(thisC_Name).baselineAVG   =baseAVG;
        Analysis.AllData.AOD.(thisC_Name).baselineSTD   =baseSTD;
    end
    Analysis.AllData.AOD.(thisC_Name).CueAVG        =nanmean(dataW(oneTime>CueTime(1) & oneTime<CueTime(2),:),1);
    Analysis.AllData.AOD.(thisC_Name).CueMAX        =max(dataW(oneTime>CueTime(1) & oneTime<CueTime(2),:),[],1);
    Analysis.AllData.AOD.(thisC_Name).OutcomeAVG	=nanmean(dataW(oneTime>OutcomeTime(1) & oneTime<OutcomeTime(2),:),1);
    Analysis.AllData.AOD.(thisC_Name).OutcomeMAX	=max(dataW(oneTime>OutcomeTime(1) & oneTime<OutcomeTime(2),:),[],1);   
end
end