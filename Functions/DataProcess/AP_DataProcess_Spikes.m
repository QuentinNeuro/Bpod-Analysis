function Analysis=AP_DataProcess_Spikes(Analysis)

%% Parameters
nCells=Analysis.Parameters.nCells;
cellID=Analysis.Parameters.Spikes.CellID;
dataType={'AllData'};
nTrials=Analysis.Core.nTrials;
zeroTS={Analysis.Core.Spikes_BehTS};
if Analysis.Parameters.Spike.Tag
    dataType{2}='Tagging';
    zeroTS{2}=Analysis.Core.Spikes_TagTS;
    nTrials(2)=length(Analysis.Core.Spikes_TagTS);
end
binSize=Analysis.Parameters.Spikes.BinSize;
timeWindow=[Analysis.Parameters.ReshapedTime ; Analysis.Parameters.Spikes.tagging_timeW];


%% Align data to behavior and tagging protocols
for dt=1:size(dataType,2)
    thisBinTW=timeWindow(dt,1):binSize(dt):timeWindow(dt,2);
    thisZero=zeroTS{dt};
    for t=1:nTrials(dt)
        for c=1:nCells
            thisTS           = Analysis.Core.SpikeTS{c};
            thisTS_Zero      = thisTS-thisZero(t);
            thisTS_align     = thisTS_Zero(thisTS_Zero>=thisBinTW(1) & thisTS_Zero<=thisBinTW(end));
            thisRate         = histcounts(thisTS_align,thisBinTW)/binSize(dt);
            dataTrial{t}(c,:)= thisRate;
            dataCells{c}(t,:)= thisRate;
        end
        timeTrial(t,:)=thisBinTW(1:end-1);
    end
    %% Save in structure and generate metrics
    Analysis.(dataType{dt}).AllCells.Time=timeTrial;
    Analysis.(dataType{dt}).AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
    for c=1:nCells
        thisID=cellID{c};
        Analysis.(dataType{dt}).AllCells.CellName{c}       =thisID;
        Analysis.(dataType{dt}).(thisID).Time              =timeTrial;
        Analysis.(dataType{dt}).(thisID).Data              =dataCells{c};
    end

    clear dataTrial dataCells timeTrial
end
% Metrics
Analysis=AP_DataProcess_SingleCells(Analysis);

%% Tagging
%     % Tagging stats
%     for w=1:size(testTW,1)
%         baseCount=flip(thisRate(:,binTag<=-0.05),2);
%         testCount=thisRate(:,binTag(1:end-1)>=testTW(w,1));
%         [p, data]=AS_myTagStat(baseCount,testCount,binSizeTag,diff(testTW(w,:)),pThreshold);
% 
%         Analysis.AllData.Spikes.TagStat.Decision(c,w)=p.h;
%         Analysis.AllData.Spikes.TagStat.preFR(c,w)=data.preFR_avg;
%         Analysis.AllData.Spikes.TagStat.postFR(c,w)=data.postFR_avg;
%         Analysis.AllData.Spikes.TagStat.preLat(c,w)=data.preLat_avg;
%         Analysis.AllData.Spikes.TagStat.postLat(c,w)=data.postLat_avg;
%         Analysis.AllData.Spikes.TagStat.preRel(c,w)=data.preRel_pct;
%         Analysis.AllData.Spikes.TagStat.postRel(c,w)=data.postRel_pct;
%     end
end

%% 

% 
% 
% % Tagging stats parameters
% testTW=[0 0.01; 0.01 0.05; 0.05 0.15];
% testNames={'Tagged','Inhib','Desinhib'};
% pThreshold=Analysis.Parameters.Spikes.pThreshold;
% 
% 
% 
% %% Data ini
% Analysis.AllData.Spikes.CellNames={};
% Analysis.AllData.Spikes.TagStat.TagNames=testNames;
% 
% %% Main loop
% for c=1:nCells
%     c_Name=Analysis.Core.Spikes.CellNames{c};
%     thisTS=Analysis.Core.Spikes.SpikeTS{c};
%     Analysis.AllData.Spikes.CellNames{c}=c_Name;
% %% Align photostim
%     for t=1:length(tagTS)
%         thisWindow=timeW_tag+tagTS(t);
%         thisTS_align{t}=thisTS(thisTS>=thisWindow(1) & thisTS<=thisWindow(2))...
%                                     -tagTS(t);
%         thisTS_trials{t} = ones(1,length(thisTS_align{t})).*t;
%         thisRate(t,:)    = histcounts(thisTS_align{t},binTag);
%         thisBin(t,:)     = binTag;
%     end
%     Analysis.AllData.Spikes.(c_Name).Tagging.SpikeTS=thisTS_align;
%     Analysis.AllData.Spikes.(c_Name).Tagging.Trials=thisTS_trials;
%     Analysis.AllData.Spikes.(c_Name).Tagging.Rate=thisRate;
%     Analysis.AllData.Spikes.(c_Name).Tagging.Bin=thisBin(:,1:end-1);
% 
%     % Tagging stats
%     for w=1:size(testTW,1)
%         baseCount=flip(thisRate(:,binTag<=-0.05),2);
%         testCount=thisRate(:,binTag(1:end-1)>=testTW(w,1));
%         [p, data]=AS_myTagStat(baseCount,testCount,binSizeTag,diff(testTW(w,:)),pThreshold);
% 
%         Analysis.AllData.Spikes.TagStat.Decision(c,w)=p.h;
%         Analysis.AllData.Spikes.TagStat.preFR(c,w)=data.preFR_avg;
%         Analysis.AllData.Spikes.TagStat.postFR(c,w)=data.postFR_avg;
%         Analysis.AllData.Spikes.TagStat.preLat(c,w)=data.preLat_avg;
%         Analysis.AllData.Spikes.TagStat.postLat(c,w)=data.postLat_avg;
%         Analysis.AllData.Spikes.TagStat.preRel(c,w)=data.preRel_pct;
%         Analysis.AllData.Spikes.TagStat.postRel(c,w)=data.postRel_pct;
%     end
% 
%     clear thisWindow thisTS_align thisTS_trials thisRate thisBin
% %% Align behavior
%     for t=1:length(behTS)
%         thisWindow=timeW_beh+behTS(t);
%         thisTS_align{t}=thisTS(thisTS>=thisWindow(1) & thisTS<=thisWindow(2))...
%                                     -behTS(t);
%         thisTS_trials{t}=ones(1,length(thisTS_align{t})).*t;
%         thisRate(t,:)    = histcounts(thisTS_align{t},binBeh)/binSize;
%         thisBin(t,:)     = binBeh;
%     end
%     Analysis.AllData.Spikes.(c_Name).SpikeTS=thisTS_align;
%     Analysis.AllData.Spikes.(c_Name).Trials=thisTS_trials;
%     Analysis.AllData.Spikes.(c_Name).Rate=thisRate;
%     Analysis.AllData.Spikes.(c_Name).Bin=thisBin(:,1:end-1);
%     clear thisWindow thisTS_align thisTS_trials thisRate thisBin
