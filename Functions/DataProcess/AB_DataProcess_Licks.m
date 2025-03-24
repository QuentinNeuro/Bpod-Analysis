function Analysis=AB_DataProcess_Licks(Analysis)
% Lick PSTH and readjust PSTH's zero to first lick if option is activated

%% Timing
nTrials=Analysis.AllData.nTrials;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
binSize=Analysis.Parameters.Licks.BinSize;
binVector=PSTH_TW(1):binSize:PSTH_TW(2);
testZeroFirstLick=Analysis.Parameters.Timing.ZeroFirstLick;
firstLickFilter=true(Analysis.AllData.nTrials,1);

%% Data processing
data=Analysis.Core.Licks(Analysis.Filters.ignoredTrials);
for t=1:nTrials
    licks{t,:}=data{t}-timeToZero(t);
    trials{t,:}=t*ones(size(licks{t,:}));

    zeroFirstLick(t,:)=0;
    if testZeroFirstLick
        licksDuringZeroState=licks{t}(licks{t}> 0 & licks{t} < 2);
        if ~isempty(licksDuringZeroState)
            zeroFirstLick(t)=licksDuringZeroState(1);

        else 
            Analysis.Filters.FirstLick(t)=false;
        end
    licks{t}=licks{t}-zeroFirstLick(t);
    timeToZero(t)=timeToZero(t)-zeroFirstLick(t);
    end
    
    % PSTH
    timeTrial(t,:)=binVector(2:end);
    dataTrial(t,:)=histcounts(licks{t},binVector);
end

%% Statistics for Analysis Structure
Analysis.AllData.Licks.Events   =licks;
Analysis.AllData.Licks.Trials   =trials;
Analysis.AllData.Licks.Time     =timeTrial;
Analysis.AllData.Licks.Data     =dataTrial/binSize;

Analysis.AllData.Time.Zero=timeToZero;
Analysis.AllData.Time.zeroFirstLick=zeroFirstLick;
Analysis.Filters.FirstLick=firstLickFilter;
end