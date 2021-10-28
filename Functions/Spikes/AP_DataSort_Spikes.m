function  Analysis=AP_DataSort_Spikes(Analysis,thistype,thisFilter)

    Analysis.(thistype).Spikes=struct();
	Analysis.(thistype).Spikes.Time=Analysis.AllData.AOD.time(:,thisFilter);
    Analysis.(thistype).AOD.AllCells.Data=NaN(length(Analysis.AllData.AOD.time(:,1)),Analysis.Core.AOD.nCells);
    Analysis.(thistype).AOD.AllCells.DataTrials=zeros(size(Analysis.AllData.AOD.time(:,thisFilter)));
    
    for thisC=1:Analysis.Core.AOD.nCells
        thisC_Name=sprintf('cell%.0d',thisC);
        Analysis.(thistype).AOD.(thisC_Name).Data=Analysis.AllData.AOD.(thisC_Name).Data(:,thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueAVG=Analysis.AllData.AOD.(thisC_Name).CueAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueMAX=Analysis.AllData.AOD.(thisC_Name).CueMAX(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG=Analysis.AllData.AOD.(thisC_Name).OutcomeAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX=Analysis.AllData.AOD.(thisC_Name).OutcomeMAX(thisFilter);
        
        Analysis.(thistype).AOD.AllCells.Data(:,thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).Data,2);
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials + Analysis.(thistype).AOD.(thisC_Name).Data;
        Analysis.(thistype).AOD.AllCells.CueAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueAVG);
        Analysis.(thistype).AOD.AllCells.CueMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueMAX);
        Analysis.(thistype).AOD.AllCells.OutcomeAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG);
        Analysis.(thistype).AOD.AllCells.OutcomeMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX);
    end
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials/Analysis.Core.AOD.nCells;
        Analysis.(thistype).AOD.AllCells.DataAVG=nanmean(Analysis.(thistype).AOD.AllCells.Data,2);
end




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
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).AVG2=(histcounts(Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Events,BinTT)/BinSize)/Analysis.(thistype).nTrials;
    Analysis.(thistype).Spikes.Behavior.(thisTT_Name).SEM=std(Analysis.(thistype).Spikes.Behavior.(thisTT_Name).Rate,1)/sqrt(Analysis.(thistype).nTrials); 
end



        for thisT=1:length(BehaviorTS)
            if Analysis.Filters.ignoredTrials(thisT)==1
                counterOK=counterOK+1;
            thisEvents_Window=Time_Behav+BehaviorTS(thisT);
            thisTT_Events{counterOK}=thisTT_TS(thisTT_TS>=thisEvents_Window(1) & thisTT_TS<=thisEvents_Window(2))...
                                        -BehaviorTS(thisT);
            thisTT_Trials{counterOK}=ones(1,length(thisTT_Events{counterOK})).*counterOK;
            
            thisTT_Rate(counterOK,:)    = histcounts(thisTT_Events{counterOK},BinTtime)/BinSize;
            thisTT_Bin(counterOK,:)     = BinTtime;
           
            end
        end

        Analysis.AllData.Spikes.(thisC_Name).Time=thisTT_Bin;
        Analysis.AllData.Spikes.(thisC_Name).Data=thisTT_Rate;
        Analysis.AllData.Spikes.(thisC_Name).Events_TS=thisTT_Events;
        Analysis.AllData.Spikes.(thisC_Name).Trials=thisTT_Trials;
        

end