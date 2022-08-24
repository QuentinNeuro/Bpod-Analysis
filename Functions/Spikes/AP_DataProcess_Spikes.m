function Analysis=AP_DataProcess_Spikes(Analysis)

%% Parameters
binSize=Analysis.Parameters.Spikes.BinSize;
timeW_tag=Analysis.Parameters.Spikes.tagging_timeW;
timeW_beh=Analysis.Parameters.ReshapedTime;
binTag=timeW_tag(1):binSize:timeW_tag(2);
binBeh=timeW_beh(1):binSize:timeW_beh(2);
nCells=Analysis.Parameters.Spikes.nCells;
%% Timestamps
tagTS=Analysis.Core.Spikes.TaggingTS;
behTS=Analysis.Core.Spikes.BehaviorTS;

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
        thisTS_trials{thisTrial}=ones(1,length(thisTS_align{thisTrial})).*thisTrial;
        thisRate(thisTrial,:)    = histcounts(thisTS_align{thisTrial},binBeh)/binSize;
        thisBin(thisTrial,:)     = binBeh;
    end
    Analysis.AllData.Spikes.(thisC_Name).Tagging.SpikeTS=thisTS_align;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Trials=thisTS_trials;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Rate=thisRate;
    Analysis.AllData.Spikes.(thisC_Name).Tagging.Bin=thisBin(:,1:end-1);
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
end
end