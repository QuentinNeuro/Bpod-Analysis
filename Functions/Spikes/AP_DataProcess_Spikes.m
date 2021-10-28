function Analysis=AP_DataProcess_Spikes(Analysis)
%% DOES NOT WORK YET ##

%% Parameters
nCells=Analysis.Parameters.Spikes.nCells;
Time_Tagging=Analysis.Parameters.Spikes.tagging_timeW;
Time_Behav=Analysis.Parameters.PlotX;
BinSize=Analysis.Parameters.Spikes.BinSize;
BinTtime=Time_Behav(1):BinSize:Time_Behav(2);

% TTL timestamps
BehaviorTS=Analysis.Core.Spikes.BehaviorTS;
TaggingTS=Analysis.Core.Spikes.TaggingTS;
        
for thisC=1:nCells
    thisC_Name=Analysis.Core.Spikes.CellNames{thisC};
    thisTT_TS=Analysis.Core.Spikes.(thisC_Name).Data;
%% Extract PhotoStim
    for thisT=1:length(TaggingTS)
        thisEvents_Window=Time_Tagging+TaggingTS(thisT);
        thisTT_Events{thisT}=thisTT_TS(thisTT_TS>=thisEvents_Window(1) & thisTT_TS<=thisEvents_Window(2))...
                                    -TaggingTS(thisT);
        thisTT_Trials{thisT}=ones(1,length(thisTT_Events{thisT})).*thisT;
    end
    Analysis.Tagging.Spikes.(thisC_Name).Events_TS=thisTT_Events;
    Analysis.Tagging.Spikes.(thisC_Name).Trials=thisTT_Trials;
    clear thisEvents_Window thisTT_Events thisTT_Trials
%% Extract Behav
    for thisT=1:length(BehaviorTS)
        thisEvents_Window=Time_Behav+BehaviorTS(thisT);
        thisTT_Events{thisT}=thisTT_TS(thisTT_TS>=thisEvents_Window(1) & thisTT_TS<=thisEvents_Window(2))...
                                    -BehaviorTS(thisT);
        thisTT_Trials{thisT}=ones(1,length(thisTT_Events{thisT})).*thisT;
        thisTT_Rate(thisT,:)    = histcounts(thisTT_Events{thisT},BinTtime)/BinSize;
        thisTT_Bin(thisT,:)     = BinTtime;
    end

    Analysis.AllData.Spikes.(thisC_Name).Time=thisTT_Bin;
    Analysis.AllData.Spikes.(thisC_Name).Data=thisTT_Rate;
    Analysis.AllData.Spikes.(thisC_Name).Events_TS=thisTT_Events;
    Analysis.AllData.Spikes.(thisC_Name).Trials=thisTT_Trials;
        
    clear thisEvents_Window thisTT_Events thisTT_Trials thisTT_Rate
end
end