function Analysis=AP_DataProcess_AOD(Analysis)

%% Parameters
nCells=Analysis.Parameters.AOD.nCells;
nTrials=Analysis.Core.nTrials;
nSamples=Analysis.Parameters.AOD.nSamples;
% offset
offset=Analysis.Parameters.AOD.offset;
if ischar(offset)
    offset=floor(min(min(Analysis.Core.AOD.Data)))-1;
end
Analysis.Parameters.AOD.offset=offset;
% sampling rate
sampRateRec=Analysis.Parameters.AOD.sampRateRec;
dsampRate=Analysis.Parameters.AOD.decimateSR;
if dsampRate
    decimateFactor=floor(sampRateRec/dsampRate);
    sampRate=dsampRate;
else
    sampRate=sampRateRec;
end
Analysis.Parameters.AOD.sampRate=sampRate;
baselinePts=ceil(Analysis.Parameters.NidaqBaseline*sampRate); 

%% Preprocessing
coreTime=Analysis.Core.AOD.time;
if dsampRate
    time=decimate(coreTime,decimateFactor);
else
    time=coreTime;
end
coreData=Analysis.Core.AOD.Data;
if Analysis.Parameters.AOD.smoothing || dsampRate
    data=nan(length(time),size(coreData,2));
    for thisCT=1:size(coreData,2)
        thisData=coreData(:,thisCT);
        if Analysis.Parameters.AOD.smoothing
            thisData=smooth(thisData);
        end
        if dsampRate
            thisData=decimate(thisData,decimateFactor);
        end
        data(:,thisCT)=thisData;
    end
else
    data=coreData;
end
%% Timing
% assumes cue and outcome always arrive at the same time once data have
% been zero-ed
timeWindow=Analysis.Parameters.ReshapedTime; 
CueTime=Analysis.AllData.Time.Cue+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome+Analysis.Parameters.OutcomeTimeReset;

time=time.*ones(nSamples,nTrials);
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
Analysis.AllData.AOD.Time=timeW;

%% Data
for thisC=1:nCells
    thisC_Name=sprintf('cell%.0d',thisC);
    thisC_Index=thisC:nCells:nCells*nTrials;
    thisData=data(:,thisC_Index);
    dataW=NaN(mTlength,nTrials);
    if Analysis.Parameters.AOD.raw
        thisData=thisData-offset;
        baseAVG=mean(thisData(baselinePts(1):baselinePts(2),:),1,'omitnan');
        baseSTD=std(thisData(baselinePts(1):baselinePts(2),:),[],1,'omitnan');
        if Analysis.Parameters.BaselineMov
            movBaseParam=Analysis.Parameters.BaselineMov;
            baseAVG=movmean(baseAVG,movBaseParam,'omitnan');
            baseSTD=movmean(baseSTD,movBaseParam,'omitnan');
        end
        if Analysis.Parameters.Zscore
            thisData=(thisData-baseAVG)./baseSTD;
        else
            thisData=100*(thisData-baseAVG)./baseAVG;
        end
    else
        baseAVG=nan(1,nTrials);
        baseSTD=nan(1,nTrials);
    end
      
    for thisT=1:nTrials
        dataW(1:sum(timeZ_IO(:,thisT)),thisT)=thisData(timeZ_IO(:,thisT),thisT);
        preCueAVG(thisT)    = mean(dataW(timeW(:,thisT)>CueTime(thisT,1)-2 & timeW(:,thisT)<CueTime(thisT,1)-1,thisT),1,'omitnan');
        cueAVG(thisT)       = mean(dataW(timeW(:,thisT)>CueTime(thisT,1) & timeW(:,thisT)<CueTime(thisT,2),thisT),1,'omitnan');
        cueMAX(thisT)       = max(dataW(timeW(:,thisT)>CueTime(thisT,1) & timeW(:,thisT)<CueTime(thisT,2),thisT),[],1);
        outcomeAVG(thisT)   = mean(dataW(timeW(:,thisT)>OutcomeTime(thisT,1) & timeW(:,thisT)<OutcomeTime(thisT,2),thisT),1,'omitnan');
        outcomeMAX(thisT)   = max(dataW(timeW(:,thisT)>OutcomeTime(thisT,1) & timeW(:,thisT)<OutcomeTime(thisT,2),thisT),[],1);
    end
   
    if Analysis.Parameters.ZeroAtZero
        dataW=dataW-preCueAVG;
    end
    
%% Save in structure
    Analysis.AllData.AOD.CellName{thisC}=thisC_Name;
    Analysis.AllData.AOD.(thisC_Name).Data          =dataW;
    Analysis.AllData.AOD.(thisC_Name).baselineAVG   =baseAVG;
    Analysis.AllData.AOD.(thisC_Name).baselineSTD   =baseSTD;
    Analysis.AllData.AOD.(thisC_Name).preCueAVG     =preCueAVG;
    Analysis.AllData.AOD.(thisC_Name).CueAVG        =cueAVG;
    Analysis.AllData.AOD.(thisC_Name).CueMAX        =cueMAX;
    Analysis.AllData.AOD.(thisC_Name).OutcomeAVG	=outcomeAVG;
    Analysis.AllData.AOD.(thisC_Name).OutcomeMAX	=outcomeMAX;
    
end
end