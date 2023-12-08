function Analysis=AP_DataProcess_Miniscope(Analysis)

%% Load Parameters and data
SR=Analysis.Parameters.Miniscope.SR;
nTrials=Analysis.Parameters.nTrials;
nCells=Analysis.Parameters.nCells;
baselinePts=ceil(Analysis.Parameters.NidaqBaseline*SR); 
timeWindow=Analysis.Parameters.ReshapedTime;
CueTime=Analysis.AllData.Time.Cue+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome+Analysis.Parameters.OutcomeTimeReset;

data=Analysis.Core.Miniscope;

%% Check timing between miniscope and bpod
startToZero_mini=Analysis.Core.TS_mini;
startToZero_Bpod=Analysis.AllData.Time.Zero';
zeroComp_mini_Bpod=startToZero_mini-startToZero_Bpod;
if max(abs(zeroComp_mini_Bpod))>2/SR
    countMax=sum(abs(zeroComp_mini_Bpod)>2/SR);
    thisMax=max(abs(zeroComp_mini_Bpod));
    sprintf('%.0d trials have a jitter superior to 2 images, with a maximum of %.0d sec',countMax,thisMax)
end

%% Process data
    % Baseline Calculation
for t=1:nTrials
    for c=1:nCells
        baseAVG(t,c)=mean(data{t}(baselinePts(1):baselinePts(2),c),'omitnan');
        baseSTD(t,c)=std(data{t}(baselinePts(1):baselinePts(2),c),'omitnan');
    end
end
if Analysis.Parameters.BaselineMov
    baseAVG=movmean(baseAVG,Analysis.Parameters.BaselineMov,1,'omitnan');
    baseSTD=movmean(baseSTD,Analysis.Parameters.BaselineMov,1,'omitnan');
end
    % Data Normalization
if ~Analysis.Parameters.Miniscope.raw
    for t=1:nTrials
        if Analysis.Parameters.Zscore
            data{t}=(data{t}-baseAVG(t,:))./baseSTD(t,:);
        else
            data{t}=(data{t}-baseAVG(t,:))./baseAVG(t,:);
        end
    end
end

%% make PSTH for each trial
for t=1:nTrials
    timeToZero=Analysis.AllData.Time.Zero(t);
    for c=1:nCells
        [thisTime,thisData]=AP_PSTH(data{t}(:,c),timeWindow,timeToZero,SR);
        dataTrial{t}(c,:)=thisData;
        dataCells{c}(t,:)=thisData;
    end
    timeTrial(t,:)=thisTime;
end

%% Generate some metrics and save in structure
% Per trial
for t=1:nTrials
    Analysis.AllData.AllCells.Time=timeTrial;
    Analysis.AllData.AllCells.Data(t,:)=mean(dataTrial{t},1,'omitnan');
end
    dataTrialAVG=Analysis.AllData.AllCells.Data;
    Analysis.AllData.AllCells.preCueAVG       =mean(dataTrialAVG(:,timeTrial(t,:)>CueTime(t,1)-2 & timeTrial(t,:)<CueTime(t,1)-1),2,'omitnan');
    Analysis.AllData.AllCells.CueAVG          =mean(dataTrialAVG(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),2,'omitnan');
    Analysis.AllData.AllCells.CueMAX          =max(dataTrialAVG(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),[],2,'omitnan');
    Analysis.AllData.AllCells.OutcomeAVG	  =mean(dataTrialAVG(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),2,'omitnan');
    Analysis.AllData.AllCells.OutcomeMAX	  =max(dataTrialAVG(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),[],2,'omitnan');

% Per cell
for c=1:nCells
    thisC_Name=sprintf('cell%.0d',c);
    Analysis.AllData.AllCells.CellName{c}       =thisC_Name;
    Analysis.AllData.(thisC_Name).Time          =timeTrial;
    Analysis.AllData.(thisC_Name).Data          =dataCells{c};
    Analysis.AllData.(thisC_Name).baselineAVG   =baseAVG(:,c);
    Analysis.AllData.(thisC_Name).baselineSTD   =baseSTD(:,c);
    
    for t=1:nTrials
        Analysis.AllData.(thisC_Name).preCueAVG      =mean(dataCells{c}(:,timeTrial(t,:)>CueTime(t,1)-2 & timeTrial(t,:)<CueTime(t,1)-1),2,'omitnan');
        Analysis.AllData.(thisC_Name).CueAVG         =mean(dataCells{c}(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),2,'omitnan');
        Analysis.AllData.(thisC_Name).CueMAX         =max(dataCells{c}(:,timeTrial(t,:)>CueTime(t,1) & timeTrial(t,:)<CueTime(t,2)),[],2,'omitnan');
        Analysis.AllData.(thisC_Name).OutcomeAVG	  =mean(dataCells{c}(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),2,'omitnan');
        Analysis.AllData.(thisC_Name).OutcomeMAX	  =max(dataCells{c}(:,timeTrial(t,:)>OutcomeTime(t,1) & timeTrial(t,:)<OutcomeTime(t,2)),[],2,'omitnan');
   end
end
end