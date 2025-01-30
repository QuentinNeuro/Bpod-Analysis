function Analysis=AP_DataCore_Spikes(Analysis)
fileList=ls('TT*.mat');

%% Parameters
TTL_Tagging=Analysis.Parameters.Spikes.tagging_TTL;
switch Analysis.Parameters.Spikes.Clustering
    case 'Kilosort'
    TTLTS_SpikeTS_Factor=1;
    tempCI=load('clusterInfo.mat');
    clusterInfo=tempCI.clusterInfo;
    spikeLabel=clusterInfo.group;
    ksLabel=clusterInfo.KSLabel;
    for i=1:size(spikeLabel,1)
        if isempty(spikeLabel{i})
            spikeLabel{i}=[ksLabel{i} '_KS'];
        end
    end
    case 'MClust'
    TTLTS_SpikeTS_Factor=Analysis.Parameters.Spikes.TTLTS_spikeTS_Factor;
end

% Behavior specific
switch Analysis.Parameters.Behavior.Behavior
    case 'CuedOutcome'
FieldStates=fieldnames(Analysis.Core.States{1,1});
TTL_Behavior=find(contains(FieldStates,Analysis.Parameters.Timing.StateToZero));
if size(TTL_Behavior,1)~=1
    TTL_Behavior=TTL_Behavior(1);
end
    case 'AuditoryTuning'
FieldStates=fieldnames(Analysis.Core.States{1,1});
TTL_Behavior=find(contains(FieldStates,Analysis.Parameters.Timing.StateToZero));
if size(TTL_Behavior,1)~=1
    TTL_Behavior=TTL_Behavior(1);
end
end

%% Load TTLs
Analysis.Parameters.Spikes.Tag=1;
load 1HzEvents.mat
if isempty(Events_TS)
    load allStimEvents.mat
end
Analysis.Core.Spikes_TagTS=Events_TS(Events_TTL==TTL_Tagging);
load behavEvents.mat
Analysis.Core.Spikes_BehTS=Events_TS(Events_TTL==TTL_Behavior);
%% Warning - check nb of trials
if Analysis.Parameters.Behavior.nTrials ~= length(Analysis.Core.Spikes_BehTS)
    disp('mismatch between the number of trials in Bpod and TTLs - Trying to autocorrect');
    Analysis=AS_TTLmismatch(Analysis); %% see below  %%
end
%% Load All Spikes
counterTT=0;
for i=1:size(fileList,1)
    counterTT=counterTT+1;
    thisFile=deblank(fileList(i,:));
    load(thisFile);
    thisID=thisFile(1:end-4);
    thisTT_TS=TS/TTLTS_SpikeTS_Factor;
    Analysis.Parameters.Spikes.CellID{counterTT}=thisID;
    Analysis.Core.SpikeTS{counterTT}=thisTT_TS;
    Analysis.Core.SpikeLabel{counterTT}=spikeLabel{i};
    % Analysis.Core.Spike_QC(counterTT,:)=spike_QC(:,i);
end

Analysis.Parameters.nCells=counterTT;
Analysis.Parameters.Spikes.clusterInfo=clusterInfo;
end

%%%%%%%%%%%%%%%%%% TTLmismatch check %%% %%%%%%%%%%%%%%%%%
function Analysis=AS_TTLmismatch(Analysis)
%%   
    nTrialBpod=Analysis.Parameters.Behavior.nTrials;
    nTrialTTL=length(Analysis.Core.Spikes_BehTS);

    sprintf('Bpod trial nb %.0d - TTL trial nb %.0d', nTrialBpod,nTrialTTL)

    if nTrialBpod > nTrialTTL
       disp('Too many bpod trials');
       if ceil(Analysis.Core.Spikes_BehTS(2)-Analysis.Core.Spikes_BehTS(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            for indexTTLFix=length(Analysis.Core.Spikes_BehTS)+1:Analysis.Parameters.nTrials
                Analysis.Core.Spikes_BehTS(indexTTLFix)=Analysis.Core.Spikes_BehTS(indexTTLFix-1)...
                    +(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1));
            end
            disp('TTL mismatch resolved')
        else
            disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.Spikes.Spikes=0;
            return
       end
    else
%%
       disp('Too many TTLs');
        if ceil(Analysis.Core.Spikes_BehTS(2)-Analysis.Core.Spikes_BehTS(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            Analysis.Core.Spikes_BehTS=Analysis.Core.Spikes_BehTS(1:Analysis.Parameters.nTrials);
        disp('TTL mismatch resolved')
        else
           disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.Spikes.Spikes=0;
            return
        end
    end
%    Analysis.AllData.Spikes.Time.Behavior=Analysis.AllData.Spikes.Time.Behavior(Analysis.Filters.ignoredTrials);
end