function Analysis=AP_DataSort_Spikes(Analysis,thisType,thisFilter)

nCells=Analysis.Parameters.Spikes.nCells;
nTrials=Analysis.(thisType).nTrials;

for c=1:nCells
    thisC_Name=Analysis.AllData.Spikes.CellNames{c};
    thisTS=Analysis.AllData.Spikes.(thisC_Name).SpikeTS(thisFilter);
    for t=1:nTrials
        thisTS_trials{1,t}=t*ones(1,length(thisTS{1,t}));
    end

    Analysis.(thisType).Spikes.(thisC_Name).SpikeTS=thisTS;
    Analysis.(thisType).Spikes.(thisC_Name).Trials=thisTS_trials;
    Analysis.(thisType).Spikes.(thisC_Name).Rate=Analysis.AllData.Spikes.(thisC_Name).Rate(thisFilter,:);
    Analysis.(thisType).Spikes.(thisC_Name).Bin=Analysis.AllData.Spikes.(thisC_Name).Bin(thisFilter,:);


    Analysis.(thisType).Spikes.(thisC_Name).RateAVG=mean(Analysis.(thisType).Spikes.(thisC_Name).Rate,1);
    Analysis.(thisType).Spikes.(thisC_Name).RateSEM=std(Analysis.(thisType).Spikes.(thisC_Name).Rate,1)/sqrt(nTrials); 
    
    Analysis.(thisType).Spikes.AllCells.Bin(c,:)=Analysis.AllData.Spikes.(thisC_Name).Bin(1,:);
    Analysis.(thisType).Spikes.AllCells.Rate(c,:)=Analysis.(thisType).Spikes.(thisC_Name).RateAVG;
end
    Analysis.(thisType).Spikes.AllCells.Bin(c,:)=Analysis.AllData.Spikes.(thisC_Name).Bin(1,:);
    Analysis.(thisType).Spikes.AllCells.RateAVG=mean(Analysis.(thisType).Spikes.AllCells.Rate,1);
    Analysis.(thisType).Spikes.AllCells.RateSEM=std(Analysis.(thisType).Spikes.AllCells.Rate,1)/sqrt(nCells); 
end