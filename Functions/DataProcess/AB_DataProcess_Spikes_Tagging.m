function Analysis=AB_DataProcess_Spikes_Tagging(Analysis)

%% Parameters
nCells=Analysis.Parameters.Data.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
zeroTS=Analysis.Core.SpikesTagTS;
nTrials=length(zeroTS);
binSize=Analysis.Parameters.Spikes.BinSize(2);
TW=Analysis.Parameters.Spikes.tagging_TW;
BinTW=TW(1):binSize:TW(2);
% Tagging test
baseTW=Analysis.Parameters.Spikes.tagging_baseline;
epochTW=Analysis.Parameters.Spikes.tagging_EpochTW;
epochNames=Analysis.Parameters.Spikes.tagging_EpochNames;
nEpochs=size(epochNames,2);
alphas=Analysis.Parameters.Spikes.pThreshold;

%% Align data to stimulation 
data=Analysis.Core.SpikesTS;
timeTrial=ones(nTrials,1)*BinTW(2:end);
for c=1:nCells
    thisTS           = data{c};
    for t=1:nTrials
        thisTS_Zero      = thisTS-zeroTS(t);
        thisTS_align     = thisTS_Zero(thisTS_Zero>=BinTW(1) & thisTS_Zero<=BinTW(end));
        thisRate         = histcounts(thisTS_align,BinTW)/binSize;
        dataTrial{t}(c,:)= thisRate;
        dataCells{c}(t,:)= thisRate;
        dataTS{c}{t}     = thisTS_align;
        trialTS{c}{t}    = t*ones(size(thisTS_align));
    end
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
    Analysis.Tagging.AllCells.Data_Cell(c,:)    =mean(dataCells{c},1,'omitnan');
    
end

%% Tagging metrics
% Firing Rate
for c=1:nCells
    thisID=cellID{c};
    Analysis.Tagging.Label{c}=[];
    Analysis.AllData.(thisID).LabelTag=[];
    baseRate=reshape(dataCells{c}(timeTrial>baseTW(1) & timeTrial<baseTW(2)),nTrials,[]);
    for e=1:nEpochs
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
            Analysis.Tagging.Label{c}   =[Analysis.Tagging.Label{c} ' ' epochNames{e}];
            Analysis.Tagging.(thisID).LabelTag  =[Analysis.Tagging.Label{c} ' ' epochNames{e}];
            Analysis.AllData.(thisID).LabelTag  =Analysis.Tagging.Label{c};
        end
    end
end

% Waveforms
if isfield(Analysis.Core,'SpikesWV')
    dataWV=Analysis.Core.SpikesWV;
for c=1:nCells
    thisTS=data{c};
    thisWV=dataWV{c};
    thisID=cellID{c};
    for e=1:nEpochs
        thisWV_epoch=[];
        for t=1:nTrials
            thisTS_Zero      = thisTS-zeroTS(t);
            thisWV_epoch     = [thisWV_epoch thisWV(:,thisTS_Zero>epochTW(e,1) & thisTS_Zero<epochTW(e,2))];
        end
        Analysis.Tagging.(thisID).(epochNames{e}).Waveforms=thisWV_epoch;
    end
end
end

%% Filters
for e=1:nEpochs
    Analysis.Filters.(['Tag_' (epochNames{e})])=logical(sum(Analysis.Tagging.AllCells.(epochNames{e}).h(:,1:2),2)>=2);
end

%% Plot using filters
% for e=1:nEpochs
%     thisFilter=Analysis.Filters.(['Tag_' (epochNames{e})]);
%     for c=1:length(thisFilter)
%         if thisFilter(c)
%             AB_PlotTag(Analysis,c,epochTW(e,:))
%         end
%     end
% end
for c=1:nCells
    AB_PlotTag(Analysis,c,epochTW(1,:))
end
end