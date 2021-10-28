function Analysis=AP_DataProcess_AOD(Analysis)

%% Parameters
timeWindow=Analysis.Parameters.ReshapedTime; 
nCells=Analysis.Parameters.AOD.nCells;
nTrials=Analysis.Core.nTrials;
nSamples=Analysis.Parameters.AOD.nSamples;
offset=Analysis.Parameters.AOD.offset;
if ischar(offset)
    offset=floor(min(min(Analysis.Core.AOD.Data)))-1;
end
Analysis.Parameters.AOD.offset=offset;
sampRate=Analysis.Parameters.AOD.sampRate;
baselinePts=ceil(Analysis.Parameters.NidaqBaseline*sampRate); 
% assumes cue and outcome always arrive at the same time once data have
% been zero-ed
CueTime=Analysis.AllData.Time.Cue(1,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(1,:)+Analysis.Parameters.OutcomeTimeReset;

%% Time
time=Analysis.Core.AOD.Time.*ones(nSamples,nTrials);
timeZ=time-Analysis.Core.AOD.Zero-Analysis.AllData.Time.Outcome(:,1)';
timeZ_IO=false(size(timeZ));
timeW=NaN(diff(timeWindow)*ceil(sampRate)+2,nTrials);
for thisT=1:nTrials
    timeZ_IO(timeZ(:,thisT)>=timeWindow(1) & timeZ(:,thisT)<=timeWindow(2),thisT)=true;
end
mTlength=max(sum(timeZ_IO));
timeW=NaN(mTlength,nTrials);
for thisT=1:nTrials
    timeW(1:sum(timeZ_IO(:,thisT)),thisT)=timeZ(timeZ_IO(:,thisT),thisT);
end
oneTime=timeW(:,1);
Analysis.AllData.AOD.Time=timeW;

%% Data
for thisC=1:nCells
    thisC_Name=sprintf('cell%.0d',thisC);
    thisC_Index=thisC:nCells:nCells*nTrials;
    data=Analysis.Core.AOD.Data(:,thisC_Index);
    dataW=NaN(mTlength,nTrials);
    if Analysis.Parameters.AOD.raw
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
    else
        baseAVG=nan(1,nTrials);
        baseSTD=nan(1,nTrials);
    end
      
    for thisT=1:nTrials
        dataW(1:sum(timeZ_IO(:,thisT)),thisT)=data(timeZ_IO(:,thisT),thisT);
    end
    preCueAVG=nanmean(dataW(oneTime>CueTime(1)-2 & oneTime<CueTime(1)-1,:),1);
    if Analysis.Parameters.ZeroAtZero
        dataW=dataW-preCueAVG;
    end
    
%% Save in structure
    Analysis.AllData.AOD.(thisC_Name).Data          =dataW;
    Analysis.AllData.AOD.(thisC_Name).baselineAVG   =baseAVG;
    Analysis.AllData.AOD.(thisC_Name).baselineSTD   =baseSTD;
    Analysis.AllData.AOD.(thisC_Name).preCueAVG     =nanmean(dataW(oneTime>CueTime(1)-2 & oneTime<CueTime(1)-1,:),1);
    Analysis.AllData.AOD.(thisC_Name).CueAVG        =nanmean(dataW(oneTime>CueTime(1) & oneTime<CueTime(2),:),1);
    Analysis.AllData.AOD.(thisC_Name).CueMAX        =max(dataW(oneTime>CueTime(1) & oneTime<CueTime(2),:),[],1);
    Analysis.AllData.AOD.(thisC_Name).OutcomeAVG	=nanmean(dataW(oneTime>OutcomeTime(1) & oneTime<OutcomeTime(2),:),1);
    Analysis.AllData.AOD.(thisC_Name).OutcomeMAX	=max(dataW(oneTime>OutcomeTime(1) & oneTime<OutcomeTime(2),:),[],1);  
    
end
end