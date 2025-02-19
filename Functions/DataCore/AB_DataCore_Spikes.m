function Analysis=AB_DataCore_Spikes(Analysis)

filePath=pwd;
fileList_TT=ls('TT*.mat');

%% Load TTLs
% Behavior
bpodStates=fieldnames(Analysis.Core.States{1,1});
TTL_Behavior=find(contains(bpodStates,Analysis.Parameters.Timing.EpochZeroPSTH));
if size(TTL_Behavior,1)~=1
    TTL_Behavior=TTL_Behavior(1);
end
load behavEvents.mat
Analysis.Core.SpikesBehTS=Events_TS(Events_TTL==TTL_Behavior);

if Analysis.Parameters.Behavior.nTrials ~= length(Analysis.Core.SpikesBehTS)
    disp('mismatch between the number of trials in Bpod and TTLs - Trying to autocorrect');
    Analysis=AS_TTLmismatch(Analysis); %% nested function below  %%
end

% Tagging
TTL_Tagging=Analysis.Parameters.Spikes.tagging_TTL;
try
load 1HzEvents.mat
if isempty(Events_TS)
    load allStimEvents.mat
end
Analysis.Parameters.Spikes.Tag=1;
Analysis.Core.SpikesTagTS=Events_TS(Events_TTL==TTL_Tagging);
catch
    Analysis.Parameters.Spikes.Tag=0;
end

%% Timestamp Parameters
Analysis.Parameters.Spikes.recClustering=Analysis.Parameters.Spikes.Clustering;
switch Analysis.Parameters.Spikes.Clustering
    case 'Kilosort'
    TTLTS_SpikeTS_Factor=1;
    Analysis.Parameters.Spikes.TTLTS_spikeTS_Factor=TTLTS_SpikeTS_Factor;
    case 'MClust'
    TTLTS_SpikeTS_Factor=Analysis.Parameters.Spikes.TTLTS_spikeTS_Factor;
end

%% Load All Spikes
counterTT=0;
for c=1:size(fileList_TT,1)
    counterTT=counterTT+1;
    thisFile=deblank(fileList_TT(c,:));
    load(thisFile);
    thisID=thisFile(1:end-4);
    thisTT_TS=TS/TTLTS_SpikeTS_Factor;
    Analysis.Parameters.Spikes.CellID{counterTT}=thisID;
    Analysis.Core.SpikesTS{counterTT}=thisTT_TS;
end

Analysis.Parameters.Data.nCells=counterTT;
Analysis.Parameters.Spikes.recClustering=Analysis.Parameters.Spikes.Clustering;

%% Load Cluster info, QC and waveforms
% Cluster info and quality metrics
switch Analysis.Parameters.Spikes.Clustering
    case 'Kilosort'
load('clusterInfo.mat');
Analysis.Parameters.Spikes.clusterInfo=clusterInfo;
    case 'MClust'
Analysis.Parameters.Spikes.clusterInfo='notsupported';
end

% Waveforms
if Analysis.Parameters.Spikes.LoadWV
    switch Analysis.Parameters.Spikes.Clustering
    case 'Kilosort'
        try cd Waveforms
    fileList_WV=ls('waves_*');
    counterWV=0;
    if size(fileList_WV,1)==size(fileList_TT,1)
        for w=1:size(fileList_WV,1)
        counterWV=counterWV+1;
        thiWV=deblank(fileList_WV(w,:));
        SpikeWV=double(readNPY(thiWV));
        if size(SpikeWV,2)==size(Analysis.Core.SpikesTS{counterWV},1)
            Analysis.Parameters.Spikes.CellID_WV{counterWV}=thiWV;
            Analysis.Core.SpikesWV{counterWV}=SpikeWV;
        end
        end
    else disp('Spikes : TT and waveform file numbers do not match');
    end
        catch
            disp('Spikes : could not process waveforms');
        end
        cd(filePath)
    case 'MClust'
        disp('waveforms not supported yet');
    end
end


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