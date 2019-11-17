%% Clustering based on PCA and kmeans for VIP AOD data
% Todo: (1) timecut for concat data / decimate the data ?
%       (2) looping kmeans with different cluster numbers
%       (3) Figures
% - v 0.8 - by Quentin November 2019 - 

%% Parameters
figureonly=0;
newZscore=1;

% Trialtype names
TrialTypes={'All','Reward','Punish','ConcatRewPun'}; % cannot really change these types. Types 1 and 4 are hard coded in multiple places
TrialTypeNb=size(TrialTypes,2);
% Events to calculate cue and reinf responses 
EventZero=2; %0 no zeroing - 1 zero at reinf - 2 zero at begining of timewindow.
EventNames={'Cue','Reinf_Early','Reinf_Med','Reinf_Late'};
EventTimes=[-1 0 ; 0 1 ; 1 3 ; 3 6];
EventNames_Concat={'Cue1','RewardAVG','RewardMax','Cue2','PunishAVG','PunishMax'}; % Used for trial type 4, concat of rew and punish trials.
EventTimes_Concat=[-1 0 ; 0 3 ; 0 6 ; 8.1 9.1;9.1 12.1; 9.1 15.1];
% PCA parameters
thresholdexplainedPCA=80;
TimeCut=[0 6]; % make empty for no cut
% K-means parameters
clusterNbKmeans=2;

if ~figureonly
%% Initialize
% Loading new data
dataLoaded=VAC_LoadData;
As=struct();
As.Raw.SessionNames=dataLoaded.FileList;
As.Raw.Index=dataLoaded.Index;
As.Raw.Time=dataLoaded.Time;
% Z-scored data
if newZscore
DFF=dataLoaded.DFF*100;
ZscorDFF=(DFF-mean(DFF(:,2:21),2))./std(DFF(:,2:21),0,2);
dataLoaded.DFF=ZscorDFF;
end
As.Raw.Data=dataLoaded.DFF;

%% Create trial types
As.(TrialTypes{1}).Index.Session=As.Raw.Index.Session;
As.(TrialTypes{1}).Time=As.Raw.Time;
As.(TrialTypes{1}).Data=dataLoaded.DFF;
% Reward
As.(TrialTypes{2}).Index.Session=As.Raw.Index.Session(As.Raw.Index.Rew1Pun0==1,:);
As.(TrialTypes{2}).Time=As.Raw.Time;
As.(TrialTypes{2}).Data=dataLoaded.DFF(As.Raw.Index.Rew1Pun0==1,:);
% Punish
As.(TrialTypes{3}).Index.Session=As.Raw.Index.Session(As.Raw.Index.Rew1Pun0==0,:);
As.(TrialTypes{3}).Time=As.Raw.Time;
As.(TrialTypes{3}).Data=dataLoaded.DFF(As.Raw.Index.Rew1Pun0==0,:);
%ConcatRewandPun
As.(TrialTypes{4}).Index.Session=As.Raw.Index.Session(As.Raw.Index.Rew1Pun0==1,:);
As.(TrialTypes{4}).Time=[As.Raw.Time As.Raw.Time+9+0.1];
thisrew=As.(TrialTypes{2}).Data;
thispun=As.(TrialTypes{3}).Data;
As.(TrialTypes{4}).Data=[thisrew thispun-(thispun(:,1)-thisrew(:,end))];

%% Clusters
for i=1:TrialTypeNb
    thisData=As.(TrialTypes{i}).Data;
    thisTime=As.(TrialTypes{i}).Time;
    As.(TrialTypes{i}).DFF_AVG=mean(thisData,1);
    As.(TrialTypes{i}).DFF_STD=std(thisData,1);
    As.(TrialTypes{i}).Events.Names=EventNames;
    %% Events
    if i~=4
        for j=1:size(EventTimes,1)
            switch EventZero
                case 0
                    thisZeros=zeros(size(thisData,1),1);
                case 1
                    thisZeros=mean(thisData(:,thisTime>0-0.1 & thisTime<0+0.1),2);
                case 2
                    thisZeros=mean(thisData(:,thisTime>EventTimes(j,1)-0.1 & thisTime<EventTimes(j,2)+0.1),2);
            end
            As.(TrialTypes{i}).Events.Data(:,j)=mean(thisData(:,thisTime>EventTimes(j,1) & thisTime<EventTimes(j,2)),2)-thisZeros;
        end
    else % For concat
        for j=1:size(EventTimes_Concat,1)
        switch EventZero
            case 0
                thisZeros=zeros(size(thisData,1),1);
            case 1
                thisZeros=mean(thisData(:,thisTime>0-0.1 & thisTime<0+0.1),2);
            case 2
                thisZeros=mean(thisData(:,thisTime>EventTimes_Concat(j,1)-0.1 & thisTime<EventTimes_Concat(j,2)+0.1),2);
        end
        As.(TrialTypes{i}).Events.Data(:,j)=mean(thisData(:,thisTime>EventTimes_Concat(j,1) & thisTime<EventTimes_Concat(j,2)),2)-thisZeros;
        end
    end
    % TSNE
    thisTSNE=tsne(As.(TrialTypes{i}).Events.Data);
    As.(TrialTypes{i}).Events.TSNE=thisTSNE;
    % Kmeans
    thisIndexK=kmeans(As.(TrialTypes{i}).Events.Data,clusterNbKmeans,'Replicates',5);
    As.(TrialTypes{i}).Events.Cluster_Index=thisIndexK;
    % Cluster avg wv
    for j=1:clusterNbKmeans
        As.(TrialTypes{i}).Events.Cluster_DFFAVG(j,:)=mean(thisData(thisIndexK==j,:),1);
        As.(TrialTypes{i}).Events.Cluster_DFFSTD(j,:)=std(thisData(thisIndexK==j,:),1);
    end
    % Cluster match
    As=VAC_IndexMatch(As,TrialTypes{i},'Events');
    
    %% PCA
    % Cut data according to the new timewindow
    if ~isempty(TimeCut) && i~=4
        thisPCAData=thisData(:,thisTime>TimeCut(1) & thisTime<TimeCut(2));
        thisPCAData=thisPCAData-thisPCAData(:,1);
    else thisPCAData=thisData;
    end
    thisPCA=VAC_myPCA(thisPCAData',thresholdexplainedPCA);
    As.(TrialTypes{i}).PCA.PCs=thisPCA;
    % TSNE
    thisTSNE=tsne(thisPCA);
    As.(TrialTypes{i}).PCA.TSNE=thisTSNE;
    % Kmeans
    thisIndexK=kmeans(thisPCA,clusterNbKmeans,'Replicates',5);
    As.(TrialTypes{i}).PCA.Cluster_Index=thisIndexK;  
    % Cluster avg wv
    for j=1:clusterNbKmeans
        As.(TrialTypes{i}).PCA.Cluster_DFFAVG(j,:)=mean(thisData(thisIndexK==j,:),1);
        As.(TrialTypes{i}).PCA.Cluster_DFFSTD(j,:)=std(thisData(thisIndexK==j,:),1);
    end
    % Cluster match
    As=VAC_IndexMatch(As,TrialTypes{i},'PCA');
end
end
%% figure
% fig_data=VAC_Fig1(As);
