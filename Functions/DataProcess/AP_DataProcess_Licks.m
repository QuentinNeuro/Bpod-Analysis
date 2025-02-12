function Analysis=AP_DataProcess_Licks(Analysis)
% Lick PSTH and readjust PSTH's zero to first lick if option is activated

%% Timing
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
binSize=Analysis.Parameters.Licks.BinSize;
binVector=PSTH_TW(1):binSize:PSTH_TW(2);
nTrials=Analysis.Parameters.Behavior.nTrials;
testZeroFirstLick=Analysis.Parameters.Timing.ZeroFirstLick;
firstLickFilter=true(Analysis.AllData.nTrials,1);

%% Data processing
for t=1:nTrials
    licks{t}=Analysis.Core.Licks{t}-timeToZero(t);
    trials{t}=t*ones(size(licks));

    zeroFirstLick(t)=0;
    if testZeroFirstLick
        licksDuringZeroState=licks{t}(licks{t}> 0 & licks{t} < 2);
        if ~isempty(licksDuringZeroState)
            zeroFirstLick(t)=licksDuringZeroState(1);

        else 
            Analysis.Filters.FirstLick(thisTrial)=false;
        end
    licks{t}=licks{t}-zeroFirstLick(t);
    timeToZero(t)=timeToZero(t)-zeroFirstLick(t);
    end
    
    % PSTH
    time(t,:)=binVector(2:end);
    data(t,:)=histcounts(licks{t},binVector/binSize);
end

%% Statistics for Analysis Structure
Analysis.AllData.Licks.Events   =licks;
Analysis.AllData.Licks.Trials   =trials;
Analysis.AllData.Licks.Time     =time;
Analysis.AllData.Licks.Data     =data;

Analysis.AllData.Time.Zero=timeToZero;
Analysis.AllData.Time.zeroFirstLick=zeroFirstLick;
Analysis.Filters.FirstLick=firstLickFilter;
end