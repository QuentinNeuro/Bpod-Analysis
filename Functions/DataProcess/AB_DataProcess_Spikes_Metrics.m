function AB_DataProcess_Spikes_Metrics

%% Parameters
nCells=Analysis.Parameters.Data.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
nTrials=Analysis.AllData.nTrials;
%% Label
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
        for c=1:nCells
            Analysis.AllData.(cellID{c}).LabelChannel='unknown';
            Analysis.AllData.(cellID{c}).LabelClustering='unknown';
        end
end

%% Waveforms


%% ISI
