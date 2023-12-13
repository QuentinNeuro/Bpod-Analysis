function Analysis=AP_DataProcess_AOD(Analysis)

%% Load Parameters and data
SR=Analysis.Parameters.AOD.sampRate;
dSR=Analysis.Parameters.AOD.decimateSR;
if dSR>=SR || dSR==0
    dSR=floor(SR);
    Analysis.Parameters.AOD.decimateSR=dSR;
    disp('Cannot decimate AOD date to the requested sampling rate')
end 
decimateFactor=floor(dSR/SR);
offset=Analysis.Parameters.AOD.offset;
nTrials=Analysis.Parameters.nTrials;
nCells=Analysis.Parameters.nCells;
baselinePts=ceil(Analysis.Parameters.NidaqBaseline*dSR); 
timeWindow=Analysis.Parameters.ReshapedTime;
CueTime=Analysis.AllData.Time.Cue+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome+Analysis.Parameters.OutcomeTimeReset;

data=Analysis.Core.AOD;
zeroTS=Analysis.Core.AOD_TS;

%% Preprocessing - smoothing and decimate
% offset
if ischar(offset)
    switch offset
        case 'auto'
            m = cellfun(@(x) min(x,[],'all'),data);
            offset=min(m,[],'all')-1;
        otherwise
            offset=0;
    end
end
if offset>0
    data = cellfun(@(x) x-offset,data,'UniformOutput',false);
end
% smoothing
if Analysis.Parameters.AOD.smoothing
    data = cellfun(@(x) smoothdata(x,2),data,'UniformOutput',false);
end
% decimate
if decimateFactor>1
    decData={};
    for t=1:nTrials
        for c=1:nCells
        decData{t}(c,:)=decimate(data{t}(c,:),decimateFactor);
        end
    end
    data=decData;
end

%% Process data
% Baseline Calculation
for t=1:nTrials
        baseAVG(:,t)=mean(data{t}(:,baselinePts(1):baselinePts(2)),2,'omitnan');
        baseSTD(:,t)=std(data{t}(:,baselinePts(1):baselinePts(2)),[],2,'omitnan');
end
if Analysis.Parameters.BaselineMov
    baseAVG=movmean(baseAVG,Analysis.Parameters.BaselineMov,2,'omitnan');
    baseSTD=movmean(baseSTD,Analysis.Parameters.BaselineMov,2,'omitnan');
end
% Data Normalization
if Analysis.Parameters.AOD.raw
    for t=1:nTrials
        if Analysis.Parameters.Zscore
            data{t}=(data{t}-baseAVG(:,t))./baseSTD(:,t);
        else
            data{t}=100*(data{t}-baseAVG(:,t))./baseAVG(:,t);
        end
    end
end

%% make PSTH for each trial
for t=1:nTrials
    for c=1:nCells
        [thisTime,thisData]=AP_PSTH(data{t}(c,:),timeWindow,zeroTS(t),dSR);
        thisData=thisData-mean(thisData(1:dSR),'omitnan');
        dataTrial{t}(c,:)=thisData;
        dataCells{c}(t,:)=thisData;
    end
    timeTrial(t,:)=thisTime;
end

%% Generate some metrics and save in structure
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');

for c=1:nCells
    thisC_Name=sprintf('cell%.0d',c);
    thisCData=dataCells{c};
    Analysis.AllData.AllCells.CellName{c}     =thisC_Name;
    Analysis.AllData.AllCells.preCueAVG(c,:)  =mean(thisCData(:,timeTrial(t,:)>CueTime(t,1)-2 & timeTrial(t,:)<CueTime(t,1)-1),2,'omitnan');
    Analysis.AllData.AllCells.preCueSTD(c,:)  =std(thisCData(:,timeTrial(t,:)>CueTime(t,1)-2 & timeTrial(t,:)<CueTime(t,1)-1),[],2,'omitnan');
    Analysis.AllData.AllCells.CueAVG(c,:)     =mean(thisCData(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),2,'omitnan');
    Analysis.AllData.AllCells.CueMAX(c,:)     =max(thisCData(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),[],2,'omitnan');
    Analysis.AllData.AllCells.OutcomeAVG(c,:) =mean(thisCData(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),2,'omitnan');
    Analysis.AllData.AllCells.OutcomeMAX(c,:) =max(thisCData(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),[],2,'omitnan');
    
    Analysis.AllData.(thisC_Name).Time          =timeTrial;
    Analysis.AllData.(thisC_Name).Data          =dataCells{c};
    Analysis.AllData.(thisC_Name).baselineAVG   =baseAVG(c,:)';
    Analysis.AllData.(thisC_Name).baselineSTD   =baseSTD(c,:)';
    Analysis.AllData.(thisC_Name).preCueAVG     =Analysis.AllData.AllCells.preCueAVG(c,:);
    Analysis.AllData.(thisC_Name).preCueAVG     =Analysis.AllData.AllCells.preCueSTD(c,:);
    Analysis.AllData.(thisC_Name).CueAVG        =Analysis.AllData.AllCells.CueAVG(c,:);
    Analysis.AllData.(thisC_Name).CueMAX        =Analysis.AllData.AllCells.CueMAX(c,:);
    Analysis.AllData.(thisC_Name).OutcomeAVG    =Analysis.AllData.AllCells.OutcomeAVG(c,:);
    Analysis.AllData.(thisC_Name).OutcomeMAX    =Analysis.AllData.AllCells.OutcomeMAX(c,:);
    Analysis.AllData.(thisC_Name).baselineAVG   =baseAVG(c,:);
    Analysis.AllData.(thisC_Name).baselineSTD   =baseSTD(c,:);
end    
% %% remove trials with too many missing points
%     nanCount=sum(isnan(Analysis.AllData.cell1.Data))<SR*2;
%     Analysis.Filters.ignoredTrials=Analysis.Filters.ignoredTrials.*nanCount;
%% Adjust behavior type - should be moved later on
    switch Analysis.Parameters.Behavior
        case 'AOD_AudPav'
            Analysis.Parameters.Behavior='CuedOutcome';
    end
end