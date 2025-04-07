function Analysis=AB_DataProcess_Spikes_Tagging_Select(Analysis)

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

% if nTrials>100
%     nTrials=100;
% end
%% Load data
data=Analysis.Core.SpikesTS;
if isfield(Analysis.Core,'SpikesWV')
    dataWV=Analysis.Core.SpikesWV;
else
    dataWV=[];
end
[~,data,dataWV]=AB_DataProcess_Spikes_Cleanup('update',data,dataWV,'auto',Analysis.Filters.Cell_Artifacts);

try
    load([Analysis.Parameters.Files{1} '_' Analysis.Parameters.Behavior.Phase '_' Analysis.Parameters.Behavior.TypeOfCue '_core_Tag_Select.mat']);
catch
    Tag_SelectTrials=struct;
end

%% Align data to stimulation 
for c=1:nCells
    thisTS           = data{c};
    thisID=cellID{c};
    tcount=0;
    if isfield(Tag_SelectTrials,thisID)
        switch Tag_SelectTrials.(thisID)
            case 'Early'
                trialIdx=1:100;
            case 'Late'
                trialIdx=101:nTrials;
        end
    else
        trialIdx=1:nTrials;
    end

    for t=trialIdx
        tcount=tcount+1;
        thisTS_Zero      = thisTS-zeroTS(t);
        thisTS_align     = thisTS_Zero(thisTS_Zero>=BinTW(1) & thisTS_Zero<=BinTW(end));
        thisRate         = histcounts(thisTS_align,BinTW)/binSize;
        dataTrial{tcount}(c,:)= thisRate;
        dataCells{c}(tcount,:)= thisRate;
        dataTS{c}{tcount}     = thisTS_align;
        trialTS{c}{tcount}    = tcount*ones(size(thisTS_align));
    end
    timeTrial=ones(length(trialIdx),1)*BinTW(2:end);
% Save in structure
    thisID=cellID{c};
    Analysis.Tagging.AllCells.CellName{c}       =thisID;
    Analysis.Tagging.(thisID).TrialIdx          =trialIdx;
    Analysis.Tagging.(thisID).Time              =timeTrial;
    Analysis.Tagging.(thisID).Data              =dataCells{c};
    Analysis.Tagging.(thisID).SpikeTS           =dataTS{c};
    Analysis.Tagging.(thisID).TrialTS           =trialTS{c};
    Analysis.Tagging.AllCells.Data_Cell(c,:)    =mean(dataCells{c},1,'omitnan');
end
% Save in structure
Analysis.Tagging.nTrials=nTrials;
Analysis.Tagging.Time.Zero_Spike=zeroTS;
Analysis.Tagging.AllCells.Time=timeTrial;
Analysis.Tagging.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');

%% Tagging metrics
% Firing Rate
for c=1:nCells
    thisID=cellID{c};
    Analysis.Tagging.Label{c}=[];
    Analysis.AllData.(thisID).LabelTag=[];
    timeTrial=Analysis.Tagging.(thisID).Time;
    baseRate=reshape(dataCells{c}(timeTrial>baseTW(1) & timeTrial<baseTW(2)),size(dataCells{c},1),[]);
    for e=1:nEpochs
        epochRate=reshape(dataCells{c}(timeTrial>epochTW(e,1) & timeTrial<epochTW(e,2)),size(dataCells{c},1),[]);
        [p,h,stats]=myTagStat(baseRate,epochRate,alphas);
        if diff(stats.FiringRate)<0
            h(2)=-h(2);
        end
% Save in structure
        Analysis.Tagging.AllCells.(epochNames{e}).p(c,:)=p;
        Analysis.Tagging.AllCells.(epochNames{e}).h(c,:)=h;
        Analysis.Tagging.AllCells.(epochNames{e}).Latency(c,:)=stats.Latency;
        Analysis.Tagging.AllCells.(epochNames{e}).Latency_nan(c,:)=stats.Latency_zmn(:,3);
        Analysis.Tagging.AllCells.(epochNames{e}).FiringRate(c,:)=stats.FiringRate;
        Analysis.Tagging.AllCells.(epochNames{e}).Reliability(c,:)=stats.Reliability;
        Analysis.Tagging.(thisID).(epochNames{e}).tagStats=stats;
        if prod(h(1:2))>0
            Analysis.Tagging.Label{c}           =[Analysis.Tagging.Label{c} ' ' epochNames{e}];
            Analysis.Tagging.(thisID).LabelTag  =[Analysis.Tagging.Label{c} ' ' epochNames{e}];
            Analysis.AllData.(thisID).LabelTag  =Analysis.Tagging.Label{c};
        elseif prod(h(1:2))<0
            Analysis.Tagging.Label{c}           =[Analysis.Tagging.Label{c} ' ' epochNames{e} '_Inhib'];
            Analysis.Tagging.(thisID).LabelTag  =Analysis.Tagging.Label{c};
            Analysis.AllData.(thisID).LabelTag  =Analysis.Tagging.Label{c};
        end
    end
end

% Waveforms
if ~isempty(dataWV)
for c=1:nCells
    thisTS=data{c};
    thisWV=dataWV{c};
    wvnan=nan(size(thisWV,1),size(thisWV,2),1);
    % thisWV=dataWV{c}(1,:,:);
    % thisWV=reshape(thisWV,size(thisWV,2),size(thisWV,3));
    thisID=cellID{c};
    if ~isempty(thisWV)
    for e=1:nEpochs
        thisWV_epoch=[];
        tcount=0;
        for t=Analysis.Tagging.(thisID).TrialIdx
            tcount=tcount+1;
            thisTS_Zero      = thisTS-zeroTS(t);
            thisWV_epoch_temp= thisWV(:,:,thisTS_Zero>epochTW(e,1) & thisTS_Zero<epochTW(e,2));
            if ~isempty(thisWV_epoch_temp)
                thisWV_epoch(:,:,tcount)     = thisWV_epoch_temp(:,:,1);
            else
                
                thisWV_epoch(:,:,tcount)     = wvnan;
            end
        end
        Analysis.Tagging.(thisID).(epochNames{e}).Waveforms=thisWV_epoch;
        Analysis.Tagging.(thisID).(epochNames{e}).Waveforms_Stats=AB_DataProcess_Spikes_Waveforms('Stats',thisWV_epoch,[]);
        Analysis.Tagging.(thisID).(epochNames{e}).Waveforms_Corr=AB_DataProcess_Spikes_Waveforms('xcorr',thisWV,thisWV_epoch);
        Analysis.Tagging.AllCells.(epochNames{e}).wf_corr(c)=Analysis.Tagging.(thisID).(epochNames{e}).Waveforms_Corr.Waveform_Corr;
        Analysis.Tagging.AllCells.(epochNames{e}).wf_pval(c)=Analysis.Tagging.(thisID).(epochNames{e}).Waveforms_Corr.Waveform_Pval;
    end
    end
end
end

%% Filters
for e=1:nEpochs
    Analysis.Filters.(epochNames{e})=logical(sum(Analysis.Tagging.AllCells.(epochNames{e}).h(:,1:2),2)>=2);
end

%% Plot using filters
switch Analysis.Parameters.Plot.Cells_tag
    case 'All'
for c=1:nCells
    try
    AB_PlotData_Spikes_Tag(Analysis,c,1)
    catch
    end
end
    case 'Tag'
for e=1:nEpochs
    thisFilter=Analysis.Filters.(epochNames{e});
    for c=1:length(thisFilter)
        if thisFilter(c)
            AB_PlotData_Spikes_Tag(Analysis,c,e)
        end
    end
end
end
end