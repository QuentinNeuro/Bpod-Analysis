function Analysis=AP_DataProcess_SingleCells(Analysis,baseAVG,baseSTD)

%% Parameters
nTrials=Analysis.Parameters.nTrials;
nCells=Analysis.Parameters.nCells;
cellID=Analysis.AllData.AllCells.CellName;

CueTime=Analysis.AllData.Time.Cue+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome+Analysis.Parameters.OutcomeTimeReset;

if nargin==1
    baseAVG=NaN(nCells,nTrials);
    baseSTD=NaN(nCells,nTrials);
end

%% Process
for c=1:nCells
    thisID=cellID{c};
    thisData=Analysis.AllData.(thisID).Data;
    thisTime=Analysis.AllData.(thisID).Time;
    for t=1:nTrials
        Analysis.AllData.AllCells.preCueAVG(c,:)  =mean(thisData(:,thisTime(t,:)>CueTime(t,1)-2 & thisTime(t,:)<CueTime(t,1)-1),2,'omitnan');
        Analysis.AllData.AllCells.preCueSTD(c,:)  =std(thisData(:,thisTime(t,:)>CueTime(t,1)-2 & thisTime(t,:)<CueTime(t,1)-1),[],2,'omitnan');
        Analysis.AllData.AllCells.CueAVG(c,:)     =mean(thisData(:,thisTime(t,:)>CueTime(t,1) & thisTime(t,:)<CueTime(t,2)),2,'omitnan');
        Analysis.AllData.AllCells.CueMAX(c,:)     =max(thisData(:,thisTime(t,:)>CueTime(t,1) & thisTime(t,:)<CueTime(t,2)),[],2,'omitnan');
        preOutcome=mean(thisData(:,thisTime(t,:)>OutcomeTime(t,1)-1 & thisTime(t,:)<OutcomeTime(t,1)-0.1),2,'omitnan');
        Analysis.AllData.AllCells.OutcomeAVG(c,:) =mean(thisData(:,thisTime(t,:)>OutcomeTime(t,1) & thisTime(t,:)<OutcomeTime(t,2)),2,'omitnan');
        Analysis.AllData.AllCells.OutcomeMAX(c,:) =max(thisData(:,thisTime(t,:)>OutcomeTime(t,1) & thisTime(t,:)<OutcomeTime(t,2)),[],2,'omitnan');
        Analysis.AllData.AllCells.OutcomeZAVG(c,:) =Analysis.AllData.AllCells.OutcomeAVG(c,:)-preOutcome';
        Analysis.AllData.AllCells.OutcomeZMAX(c,:) =Analysis.AllData.AllCells.OutcomeMAX(c,:)-preOutcome';
    end
        Analysis.AllData.(thisID).baselineAVG   =baseAVG(c,:);
        Analysis.AllData.(thisID).baselineSTD   =baseSTD(c,:);
        Analysis.AllData.(thisID).preCueAVG     =Analysis.AllData.AllCells.preCueAVG(c,:);
        Analysis.AllData.(thisID).preCueAVG     =Analysis.AllData.AllCells.preCueSTD(c,:);
        Analysis.AllData.(thisID).CueAVG        =Analysis.AllData.AllCells.CueAVG(c,:);
        Analysis.AllData.(thisID).CueMAX        =Analysis.AllData.AllCells.CueMAX(c,:);
        Analysis.AllData.(thisID).OutcomeAVG    =Analysis.AllData.AllCells.OutcomeAVG(c,:);
        Analysis.AllData.(thisID).OutcomeMAX    =Analysis.AllData.AllCells.OutcomeMAX(c,:);
        Analysis.AllData.(thisID).OutcomeZAVG   =Analysis.AllData.AllCells.OutcomeZAVG(c,:);
        Analysis.AllData.(thisID).OutcomeZMAX   =Analysis.AllData.AllCells.OutcomeZMAX(c,:);
end
end