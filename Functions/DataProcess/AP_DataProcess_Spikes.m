function Analysis=AP_DataProcess_Spikes(Analysis)
%% Align data to behavior and to tagging
%% Parameters
nCells=Analysis.Parameters.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
nTrials=Analysis.Core.nTrials;
zeroTS=Analysis.Core.Spikes_BehTS;
binSize=Analysis.Parameters.Spikes.BinSize(1);
TW=Analysis.Parameters.Timing.PSTH;

%% Align data to behavior 
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
    timeTrial(t,:)=thisBinTW(2:end);
end
% Save in structure and generate metrics
Analysis.Parameters.Data.Label={['Spikes ' Analysis.Parameters.Data.Label{1}]};
Analysis.AllData.Time.Zero_Spike=zeroTS;
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
for c=1:nCells
    thisID=cellID{c};
    Analysis.AllData.AllCells.CellName{c}       = thisID;
    Analysis.AllData.(thisID).Time              = timeTrial;
    Analysis.AllData.(thisID).Data              = dataCells{c};
    Analysis.AllData.(thisID).SpikeTS           = dataTS{c};
    Analysis.AllData.(thisID).TrialTS           = trialTS{c};
    Analysis.AllData.(thisID).LabelCluster      = Analysis.Core.SpikeLabel{c};
    Analysis.AllData.(thisID).LabelTag          = [];
end

% Metrics
Analysis=AP_DataProcess_SingleCells(Analysis);

%% Align data to Tagging
Analysis=AP_DataProcess_Tagging(Analysis);
end