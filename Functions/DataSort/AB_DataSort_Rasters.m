function Analysis=AB_DataSort_Rasters(Analysis,FilterName)

%% Parameters
thisType=FilterName;
nTrials=Analysis.(thisType).nTrials;
%% Licks
for t=1:nTrials
    Analysis.(thisType).Licks.Trials{t,:}=t*ones(size(Analysis.(thisType).Licks.Trials{t,:}));
end

%% Spikes
if Analysis.Parameters.Spikes.Spikes
    nCells=Analysis.Parameters.Data.nCells;
    cellID=Analysis.Parameters.Spikes.CellID;
    for c=1:nCells
        thisID=cellID{c};
        for t=1:nTrials
            Analysis.(thisType).(thisID).TrialTS{t}=t*ones(size(Analysis.(thisType).(thisID).TrialTS{t}));
        end
    end
end
end