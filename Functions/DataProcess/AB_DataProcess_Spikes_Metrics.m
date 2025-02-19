function Analysis=AB_DataProcess_Spikes_Metrics(Analysis)
%% Parameters
nCells=Analysis.Parameters.Data.nCells;
cellID=Analysis.Parameters.Spikes.CellID;

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
        cellCh=clusterInfo(clusterInfo.cluster_ch==cellNb,:);
        Analysis.AllData.(cellID{c}).LabelChannel=cellCh;
        Analysis.AllData.(cellID{c}).LabelClustering=cellLabel{c};
    end
    case 'MClust'
end

% bootstrap_Reps=100;
% bootstrap_Size=20;
% 
% bootstrap_Idx(:,2)=bootstrap_Idx(:,1)+latencyTW(end)-1;
% ISI_bin=0.001;
% ISI_tw=[0 1];
% ISI_edge=ISI_tw(1):ISI_bin:ISI_tw(2);
% % for c=1:nCells
%     dt=diff(Analysis.Core.SpikeTS{1, 4});
% 
%     ndt=length(dt);
%     ndt_BS=ndt*bootstrap_Size/100;
%     bootstrap_Idx=randi(ndt-ndt_BS);
%     [ISI_n,edges] = histcounts(dt,ISI_edge);
%     plot(edges(2:end),ISI_n/dt_n)
%     xlim([0 0.05]);
% end
%% Waveforms ?
% Width ?


%% 


end