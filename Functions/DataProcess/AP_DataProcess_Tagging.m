function Analysis=AP_DataProcess_Tagging(Analysis)

%% Parameters
nCells=Analysis.Parameters.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
zeroTS=Analysis.Core.Spikes_TagTS;
nTrials=length(zeroTS);
binSize=Analysis.Parameters.Spikes.BinSize(2);
TW=Analysis.Parameters.Spikes.tagging_TW;
% Tagging test
baseTW=Analysis.Parameters.Spikes.tagging_baseline;
epochTW=Analysis.Parameters.Spikes.tagging_EpochTW;
epochNames=Analysis.Parameters.Spikes.tagging_EpochNames;
alphas=Analysis.Parameters.Spikes.pThreshold;

%% Align data to stimulation 
thisBinTW=TW(1):binSize:TW(2);
for t=1:nTrials
    for c=1:nCells
        thisTS           = Analysis.Core.SpikeTS{c};
        thisTS_Zero      = thisTS-zeroTS(t);
        thisTS_align     = thisTS_Zero(thisTS_Zero>=thisBinTW(1) & thisTS_Zero<=thisBinTW(end));
        thisRate         = histcounts(thisTS_align,thisBinTW)/binSize;
        dataTrial{t}(c,:)= thisRate;
        dataCells{c}(t,:)= thisRate;
        dataTS{c}{t}     = thisTS_align;
        trialTS{c}{t}    = t*ones(size(thisTS_align));
    end
    timeTrial(t,:)=thisBinTW(1:end-1);
end
% Save in structure
Analysis.Tagging.nTrials=nTrials;
Analysis.Tagging.Time.Zero_Spike=zeroTS;
Analysis.Tagging.AllCells.Time=timeTrial;
Analysis.Tagging.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
for c=1:nCells
    thisID=cellID{c};
    Analysis.Tagging.AllCells.CellName{c}       =thisID;
    Analysis.Tagging.(thisID).Time              =timeTrial;
    Analysis.Tagging.(thisID).Data              =dataCells{c};
    Analysis.Tagging.(thisID).SpikeTS           =dataTS{c};
    Analysis.Tagging.(thisID).TrialTS           =trialTS{c};
end

%% Tagging metrics
for c=1:nCells
    Analysis.Tagging.Label{c}=[];
    baseRate=reshape(dataCells{c}(timeTrial>baseTW(1) & timeTrial<baseTW(2)),nTrials,[]);
    for e=1:size(epochNames,2)
        epochRate=reshape(dataCells{c}(timeTrial>epochTW(e,1) & timeTrial<epochTW(e,2)),nTrials,[]);
        [p,h,stats]=myTagStat(baseRate,epochRate,alphas);
% Save in structure
        Analysis.Tagging.AllCells.(epochNames{e}).p(c,:)=p;
        Analysis.Tagging.AllCells.(epochNames{e}).h(c,:)=h;
        Analysis.Tagging.AllCells.(epochNames{e}).Latency(c,:)=stats.Latency;
        Analysis.Tagging.AllCells.(epochNames{e}).FiringRate(c,:)=stats.FiringRate;
        Analysis.Tagging.AllCells.(epochNames{e}).Reliability(c,:)=stats.Reliability;
        Analysis.Tagging.(thisID).(epochNames{e}).tagStats=stats;
        if prod(h(1:2))
            Analysis.Tagging.Label{c}=[Analysis.Tagging.Label{c} ' ' epochNames{e}];
            Analysis.AllData.(thisID).LabelTag=[Analysis.AllData.(thisID).LabelTag ' ' epochNames{e}];
        end
    end
end

%% Filters
for e=1:size(epochNames,2)
    Analysis.Filters.(['Tag_' (epochNames{e})])=logical(sum(Analysis.Tagging.AllCells.(epochNames{e}).h(:,1:2),2)>=2);
end
end