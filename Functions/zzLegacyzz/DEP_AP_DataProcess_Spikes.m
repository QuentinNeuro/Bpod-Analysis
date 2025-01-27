function Analysis=AP_DataProcess_Spikes2(Analysis)

%% Parameters
binSize=Analysis.Parameters.Spikes.BinSize;
binSizeTag=0.001;
timeW_tag=Analysis.Parameters.Spikes.tagging_timeW;
timeW_beh=Analysis.Parameters.ReshapedTime;
binTag=timeW_tag(1):binSizeTag:timeW_tag(2);
binBeh=timeW_beh(1):binSize:timeW_beh(2);
nCells=Analysis.Parameters.Spikes.nCells;
% Tagging stats parameters
testTW=[0 0.01; 0.01 0.05; 0.05 0.15];
testNames={'Tagged','Inhib','Desinhib'};
pThreshold=Analysis.Parameters.Spikes.pThreshold;
%% Timestamps
tagTS=Analysis.Core.Spikes.TaggingTS;
behTS=Analysis.Core.Spikes.BehaviorTS;

%% Data ini
Analysis.AllData.Spikes.CellNames={};
Analysis.AllData.Spikes.TagStat.TagNames=testNames;

%% Main loop
for c=1:nCells
    thisC_Name=Analysis.Core.Spikes.CellNames{c};
    thisTS=Analysis.Core.Spikes.SpikeTS{c};
    Analysis.AllData.Spikes.CellNames{c}=thisC_Name;
%% Align photostim
    for thisTrial=1:length(tagTS)
        thisWindow=timeW_tag+tagTS(thisTrial);
        thisTS_align{thisTrial}=thisTS(thisTS>=thisWindow(1) & thisTS<=thisWindow(2))...
                                    -tagTS(thisTrial);
        thisTS_trials{thisTrial} = ones(1,length(thisTS_align{thisTrial})).*thisTrial;
        thisRate(thisTrial,:)    = histcounts(thisTS_align{thisTrial},binTag);
        thisBin(thisTrial,:)     = binTag;
    end
    Analysis.AllData.Spikes.(thisC_Name).Tagging.SpikeTS=thisTS_align;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Trials=thisTS_trials;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Rate=thisRate;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Bin=thisBin(:,1:end-1);
   
    % Tagging stats
    for w=1:size(testTW,1)
        baseCount=flip(thisRate(:,binTag<=-0.05),2);
        testCount=thisRate(:,binTag(1:end-1)>=testTW(w,1));
        [p, data]=AS_myTagStat(baseCount,testCount,binSizeTag,diff(testTW(w,:)),pThreshold);

        Analysis.AllData.Spikes.TagStat.Decision(c,w)=p.h;
        Analysis.AllData.Spikes.TagStat.preFR(c,w)=data.preFR_avg;
        Analysis.AllData.Spikes.TagStat.postFR(c,w)=data.postFR_avg;
        Analysis.AllData.Spikes.TagStat.preLat(c,w)=data.preLat_avg;
        Analysis.AllData.Spikes.TagStat.postLat(c,w)=data.postLat_avg;
        Analysis.AllData.Spikes.TagStat.preRel(c,w)=data.preRel_pct;
        Analysis.AllData.Spikes.TagStat.postRel(c,w)=data.postRel_pct;
    end

    clear thisWindow thisTS_align thisTS_trials thisRate thisBin
%% Align behavior
    for thisTrial=1:length(behTS)
        thisWindow=timeW_beh+behTS(thisTrial);
        thisTS_align{thisTrial}=thisTS(thisTS>=thisWindow(1) & thisTS<=thisWindow(2))...
                                    -behTS(thisTrial);
        thisTS_trials{thisTrial}=ones(1,length(thisTS_align{thisTrial})).*thisTrial;
        thisRate(thisTrial,:)    = histcounts(thisTS_align{thisTrial},binBeh)/binSize;
        thisBin(thisTrial,:)     = binBeh;
    end
    Analysis.AllData.Spikes.(thisC_Name).SpikeTS=thisTS_align;
    Analysis.AllData.Spikes.(thisC_Name).Trials=thisTS_trials;
    Analysis.AllData.Spikes.(thisC_Name).Rate=thisRate;
    Analysis.AllData.Spikes.(thisC_Name).Bin=thisBin(:,1:end-1);
    clear thisWindow thisTS_align thisTS_trials thisRate thisBin
end
end