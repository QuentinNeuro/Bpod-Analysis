function Analysis=AB_DataProcess_Spikes(Analysis)
%% Align data to behavior and to tagging
%% Parameters
nCells=Analysis.Parameters.Data.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
nTrials=Analysis.AllData.nTrials;
zeroTS=Analysis.Core.SpikesBehTS;
binSize=Analysis.Parameters.Spikes.BinSize(1);
PSTH_TW=Analysis.Parameters.Timing.PSTH;
BinTW=PSTH_TW(1):binSize:PSTH_TW(2);
ignoreTrialFilter=Analysis.Filters.ignoredTrials;
% Baseline
baselineTW=Analysis.Parameters.Data.BaselineTW + PSTH_TW(1);
baselinePts=BinTW>baselineTW(1) & BinTW<baselineTW(2);
baselinePts=baselinePts(2:end);

%% Behavior PSTH and baseline extraction
data=Analysis.Core.SpikesTS;
timeTrial=ones(nTrials,1)*BinTW(2:end);
for c=1:nCells
    dataBaseline=[];
    thisTS=data{c};
    tcount=0;
    for t=1:nTrials
        if ignoreTrialFilter(t)
        tcount=tcount+1;
        thisTS_Zero              = thisTS-zeroTS(tcount);
        thisTS_align             = thisTS_Zero(thisTS_Zero>=BinTW(1) & thisTS_Zero<=BinTW(end));
        dataTS{c}{tcount,:}      = thisTS_align;
        trialTS{c}{tcount,:}     = t*ones(size(thisTS_align));
        thisRate                 = histcounts(thisTS_align,BinTW)/binSize;
        dataCells{c}(tcount,:)   = thisRate;
        dataBaseline{c}(tcount,:)= thisRate(baselinePts);
        end
    end
    
% Baseline calculation and data normalization
        [dataCells{c},baselineAVG,baselineSTD]=AB_DataProcess_Normalize(Analysis,timeTrial,dataCells{c},dataBaseline{c});
% For AllCells structure
    for t=1:tcount
        dataTrial{t}(c,:)= dataCells{c}(t,:);
    end  

%% Save in structure
    thisID=cellID{c};
    Analysis.AllData.AllCells.CellName{c}       = thisID;
    Analysis.AllData.(thisID).Time              = timeTrial;
    Analysis.AllData.(thisID).Data              = dataCells{c};
    Analysis.AllData.(thisID).SpikeTS           = dataTS{c};
    Analysis.AllData.(thisID).TrialTS           = trialTS{c};
    Analysis.AllData.(thisID).BaselineAVG       = baselineAVG;
    Analysis.AllData.(thisID).BaselineSTD       = baselineSTD;

    Analysis.AllData.(thisID)=AB_DataProcess_Epochs(Analysis.AllData.(thisID),Analysis);

end
Analysis.Parameters.Data.Label=['Spikes ' Analysis.Parameters.Data.Label];
Analysis.AllData.Time.Zero_Spike=zeroTS;
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');

%% label
switch Analysis.Parameters.Spikes.recClustering
    case 'Kilosort'
    clusterInfo=Analysis.Parameters.Spikes.clusterInfo;
    for c=1:nCells
        cellNb=str2num(cellID{c}(4:end));
        thisCI=clusterInfo(clusterInfo.cluster_id==cellNb,:);
        cellLabel{c}=thisCI.group{:};
        if isempty(cellLabel{c})
            cellLabel{c}=[thisCI.KSLabel{:} '_KS'];
        end
        cellCh=thisCI.ch;
        Analysis.AllData.(cellID{c}).LabelChannel=cellCh;
        Analysis.AllData.(cellID{c}).LabelClustering=cellLabel{c};
    end
    case 'MClust'
end

%% Tagging PSTH
Analysis=AB_DataProcess_Spikes_Tagging(Analysis);


end