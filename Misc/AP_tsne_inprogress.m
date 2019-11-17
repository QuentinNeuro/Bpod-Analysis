%% Playing with TSNE for photometry data and analysis pipeline

%% Comparing two channels / uncued reward
% Parameters
type2chcomp='Uncued_Reward';
thisData=[];
thresholdexplainedPCA=80;
clusterNbKmeans=2;
nTrials=Analysis.(type2chcomp).nTrials;
timeWindow=[-0.5 4];
% Data making
if size(Analysis.Parameters.PhotoCh,2)==2
    thisDataRaw=[Analysis.(type2chcomp).Photo_470.DFF ;...
        Analysis.(type2chcomp).Photo_470b.DFF];
    timeVector=Analysis.(type2chcomp).Photo_470.Time(1,:);
    thisData=thisDataRaw(:,timeVector>-0.5 & timeVector<4);
    indexCh=[ones(1,nTrials) 2*ones(1,nTrials)];
%     indexChName(1:nTrials)='ch1';
%     indexChName(nTrials+1:nTrials+nTrials)='ch2';
% ---- PCA ----      
    thisData4PCA=thisData';
    [coeffPCA,scorePCA,latentPCA,tsqPCA,explainedPCA]=pca(thisData4PCA);
% Sum explainedPCA to get the corresponding number of coeff
sumExplainedPCA=0;
index=0;
while sumExplainedPCA<thresholdexplainedPCA
    index=index+1;
    sumExplainedPCA=sumExplainedPCA+explainedPCA(index);
end
indexPCA=index;

thisDataPCA=coeffPCA(:,1:indexPCA);

% ----  kmeans ---
indexK=kmeans(thisDataPCA,clusterNbKmeans,'Replicates',5);
for i=1:clusterNbKmeans
    ClusterName{i}=sprintf('cluster_%.0d',indexK(i));
end
% ---   tsne ---
OutputSNE=tsne(thisDataPCA);

% Figure
indexgscatter={indexCh,indexK};
figure();
subplot(1,2,1)
gscatter(coeffPCA(:,1),coeffPCA(:,2),indexgscatter,'rkgb','o*',8);
subplot(1,2,2)
gscatter(OutputSNE(:,1),OutputSNE(:,2),indexgscatter,'rkgb','o*',8);

end
  
% 
% 
% 
% trialtypeNames=Analysis.Parameters.TrialNames;
% thresholdexplainedPCA=95;
% photoch='Photo_470b';
% type='AllData';
% clusterNbKmeans=8;
% trialtypesNumber=Analysis.AllData.TrialTypes;
% %% Names of trials
% 
% %% Create inputs and run PCA
% % 1 Take all the timeseries as input for PCA - 
% % Rows are observation/trials/ neurons -- Columns are timepoints
% InputPCA=Analysis.(type).(photoch).DFF';
% % clip data to -2 +2 with a 100Hz SR
% %InputPCA=InputPCA();
% 
% % PCA to reduce dimensionality
% [coeffPCA,scorePCA,latentPCA,tsqPCA,explainedPCA]=pca(InputPCA);
% 
% % Sum explainedPCA to find 95+ and get the corresponding coeff
% sumExplainedPCA=0;
% index=0;
% while sumExplainedPCA<thresholdexplainedPCA
%     index=index+1;
%     sumExplainedPCA=sumExplainedPCA+explainedPCA(index);
% end
% indexPCA=index;
% 
% dataPCA=coeffPCA(:,1:indexPCA);
% 
% %% kmeans
% indexK=kmeans(dataPCA,clusterNbKmeans,'Replicates',5);
% 
% %% Run TSne
% OutputSNE=tsne(dataPCA);
% 
% %% Plots
% figure()
% subplot(2,2,1)
% gscatter(coeffPCA(:,1),coeffPCA(:,2),indexK)%,trialtypes);
% subplot(2,2,2)
% gscatter(OutputSNE(:,1),OutputSNE(:,2),indexK)%,trialtypes);
% switch type
%     case 'AllData'
% subplot(2,2,3)
% gscatter(coeffPCA(:,1),coeffPCA(:,2),trialtypesNumber);
% subplot(2,2,4)
% gscatter(OutputSNE(:,1),OutputSNE(:,2),trialtypesNumber);
% end
% 
% 
