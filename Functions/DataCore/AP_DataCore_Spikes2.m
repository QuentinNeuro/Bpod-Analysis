function Analysis=AP_DataCore_Spikes2(Analysis)
FileList=ls('*.mat');

%% Parameters
TTL_Tagging=Analysis.Parameters.Spikes.tagging_TTL;
switch Analysis.Parameters.Spikes.Clustering
    case 'Kilosort'
    TTLTS_SpikeTS_Factor=1;
    label=tdfread('cluster_KSLabel.tsv');
    case 'MClust'
    TTLTS_SpikeTS_Factor=Analysis.Parameters.Spikes.TTLTS_spikeTS_Factor;
end

% Behavior specific
switch Analysis.Parameters.Behavior
    case 'CuedOutcome'
FieldStates=fieldnames(Analysis.Core.States{1,1});
TTL_Behavior=find(contains(FieldStates,Analysis.Parameters.StateToZero));
if size(TTL_Behavior,1)~=1
    TTL_Behavior=TTL_Behavior(1);
end
    case 'AuditoryTuning'
FieldStates=fieldnames(Analysis.Core.States{1,1});
TTL_Behavior=find(contains(FieldStates,Analysis.Parameters.StateToZero));
if size(TTL_Behavior,1)~=1
    TTL_Behavior=TTL_Behavior(1);
end
end

%% Load TTLs
load 1HzEvents.mat
if isempty(Events_TS)
    load allStimEvents.mat
end
Analysis.Core.TS_Tag=Events_TS(Events_TTL==TTL_Tagging);

load behavEvents.mat
Analysis.Core.TS_Behavior=Events_TS(Events_TTL==TTL_Behavior);
%% Warning - check nb of trials
if Analysis.Parameters.nTrials ~= length(Analysis.Core.TS_Behavior)
    disp('mismatch between the number of trials in Bpod and TTLs - Trying to autocorrect');
    Analysis=AS_TTLmismatch(Analysis);
end
%% Load All Spikes
counterTT=0;
for i=1:size(FileList,1)
    if contains(FileList(i,:),'TT')
        counterTT=counterTT+1;
        load(FileList(i,:));
        thisC_Name=strtrim(FileList(i,:));
        thisC_Name=thisC_Name(1:end-4);
        thisTT_TS=TS/TTLTS_SpikeTS_Factor;
        Analysis.Parameters.SpikeNames{counterTT}=thisC_Name;
        Analysis.Core.Spikes.Spikes_TS{counterTT}=thisTT_TS;
        if exist('label','var')
            Analysis.Core.Spikes_Metrics{counterTT}=label.KSLabel(counterTT,:);
        else
            Analysis.Core.Spikes_Metrics{counterTT}='unknown';
        end
    end
end

Analysis.Parameters.nCells=counterTT;
end