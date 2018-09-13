function Analysis=Analysis_Spikes(Analysis,action,thistype,Filter)
% Addon to Analysis_Photometry to compute a quick tagging and behav PSTH
% from spiking activities.
% Requiers TTL timestamps for tagging (1HzEvents) and for behavioral Events
% and TT files

Time_Tagging=[-0.1 0.1];
Time_Behav=Analysis.Parameters.PlotEdges;
BinSize=0.1;
BinTT=Time_Behav(1):BinSize:Time_Behav(2);
FileList=ls;

switch action
    case 'Organize'
%% Parameters
TTL_Tagging=2;
switch Analysis.Parameters.Behavior
    case 'CuedOutcome'
TTL_Behavior=14;
end
TTLTS_SpikeTS_Factor=10000;
%% Load TTLs
load 1HzEvents.mat
if isempty(Events_TS)
    load allStimEvents.mat
end
Analysis.AllData.Spikes.Time.Tagging=Events_TS(Events_TTL==TTL_Tagging);
load behavEvents.mat
Analysis.AllData.Spikes.Time.Behavior=Events_TS(Events_TTL==TTL_Behavior);
%% Warning - check nb of trials
if Analysis.Parameters.nTrials ~= length(Analysis.AllData.Spikes.Time.Behavior)
    disp('mismatch between the number of trials in Bpods and TTLs')
    Analysis.Parameters.SpikesAnalysis=0;
    return
end

%% Load All Spikes
counterTT=0;
for i=1:size(FileList,1)
    if contains(FileList(i,:),'TT')
        counterTT=counterTT+1;
        thisTT_Name=FileList(i,:);
        thisTT_Name=thisTT_Name(1:strfind(thisTT_Name,'.mat')-1);
        load(thisTT_Name);
        thisTT_TS=TS./TTLTS_SpikeTS_Factor;
        Analysis.AllData.Spikes.TTList{counterTT}=thisTT_Name;
        Analysis.AllData.Spikes.Raw.(thisTT_Name)=thisTT_TS;
%% Extract PhotoStim
        for thisTrial=1:length(Analysis.AllData.Spikes.Time.Tagging)
            thisEvents_Window=Time_Tagging+Analysis.AllData.Spikes.Time.Tagging(thisTrial);
            thisTT_Events{thisTrial}=thisTT_TS(thisTT_TS>=thisEvents_Window(1) & thisTT_TS<=thisEvents_Window(2))...
                                        -Analysis.AllData.Spikes.Time.Tagging(thisTrial);
            thisTT_Trials{thisTrial}=ones(1,length(thisTT_Events{thisTrial})).*thisTrial;
        end
        Analysis.AllData.Spikes.Tagging.(thisTT_Name).Events=thisTT_Events;
        Analysis.AllData.Spikes.Tagging.(thisTT_Name).Trials=thisTT_Trials;
        clear thisEvents_Window thisTT_Events thisTT_Trials
%% Extract Behav
counterOK=0;
        for thisTrial=1:length(Analysis.AllData.Spikes.Time.Behavior)
            if Analysis.Filters.ignoredTrials(thisTrial)==1
                counterOK=counterOK+1;
            thisEvents_Window=Time_Behav+Analysis.AllData.Spikes.Time.Behavior(thisTrial);
            thisTT_Events{counterOK}=thisTT_TS(thisTT_TS>=thisEvents_Window(1) & thisTT_TS<=thisEvents_Window(2))...
                                        -Analysis.AllData.Spikes.Time.Behavior(thisTrial);
            thisTT_Trials{counterOK}=ones(1,length(thisTT_Events{counterOK})).*counterOK;
            
            thisTT_Rate(counterOK,:)    = histcounts(thisTT_Events{counterOK},BinTT)/BinSize;
            thisTT_Bin(counterOK,:)     = BinTT;
           
            end
        end
        Analysis.AllData.Spikes.Behavior.(thisTT_Name).Events=thisTT_Events;
        Analysis.AllData.Spikes.Behavior.(thisTT_Name).Trials=thisTT_Trials;
        Analysis.AllData.Spikes.Behavior.(thisTT_Name).Rate=thisTT_Rate;
        Analysis.AllData.Spikes.Behavior.(thisTT_Name).Bin=thisTT_Bin;
        clear thisEvents_Window thisTT_Events thisTT_Trials thisTT_Rate
    end
end

    case 'Sort'
for i=1:length(Analysis.AllData.Spikes.TTList)
	thisTT_Name=Analysis.AllData.Spikes.TTList{i};
    thisTT_Events=Analysis.AllData.Spikes.Behavior.(thisTT_Name).Events;
    thisTT_Events(Filter~=1) = '';
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Events=cell2mat(thisTT_Events);
    thisTrials=cell(size(thisTT_Events));
    for j=1:length(thisTrials)
        thisTT_Trials{1,j}=j*ones(length(thisTT_Events{1,j}),1)';
    end
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Trials=cell2mat(thisTT_Trials);
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Rate=Analysis.AllData.Spikes.Behavior.(thisTT_Name).Rate(Filter,:);
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Bin=Time_Behav(1)+BinSize:BinSize:Time_Behav(2);
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).AVG=mean(Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Rate,1);
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).SEM=std(Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Rate,1)/sqrt(Analysis.(thistype).nTrials); 
end

    case 'Figure'
for i=1:length(Analysis.AllData.Spikes.TTList)
    thisTT_Name=Analysis.AllData.Spikes.TTList{i};
    Analysis_Spikes_PlotData(Analysis,thisTT_Name);
end
end