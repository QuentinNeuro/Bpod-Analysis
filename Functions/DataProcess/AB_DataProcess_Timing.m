function Analysis=AB_DataProcess_Timing(Analysis,action)

%% Parameters
nTrials=Analysis.Core.nTrials;
nEpochs=size(Analysis.Parameters.Behavior.EpochNames,2);
epochNames=Analysis.Parameters.Behavior.EpochNames;
epochStates=Analysis.Parameters.Behavior.EpochStates;
epochReset=Analysis.Parameters.Behavior.EpochTimeReset;
ForceEpochTimeReset=Analysis.Parameters.Timing.ForceEpochTimeReset;

ignoreTrialFilter=Analysis.Filters.ignoredTrials;

switch action
    case 'ini'
%% stateToZero
StateToZero=Analysis.Parameters.Timing.EpochZeroPSTH;
bpodStates=Analysis.Core.States{1,1};
if ~isfield(bpodStates,StateToZero)
    try StateToZero=epochStates{contains(epochNames,StateToZero)};
    catch
        disp([StateToZero ' is not a valid Bpod state to create a PSTH'])
        stateField = fieldnames(bpodStates);
        StateToZero=stateField{2};
        disp([Par.Timing.EpochZeroPSTH ' will be used instead'])
    end
    Analysis.Parameters.Timing.EpochZeroPSTH=StateToZero;
end

%% adjust EpochTime
if ~isempty(ForceEpochTimeReset)
    nForceEpochs=size(ForceEpochTimeReset,2);
    for e=1:nForceEpochs
        if ~isnan(ForceEpochTimeReset(e,:))
            epochReset(e,:)=ForceEpochTimeReset(e,:);
        end
    end
    Analysis.Parameters.Behavior.EpochTimeReset=epochReset;
end

%% Process PSTH and Epoch Times
for t=1:nTrials
    Analysis.AllData.Time.Zero(t,1)=Analysis.Core.States{1,t}.(StateToZero)(1);
    for e=1:nEpochs
        Analysis.AllData.Time.(epochNames{e})(t,:)=Analysis.Core.States{1,t}.(epochStates{e});
    end
end
Analysis.AllData.Time.Zero=Analysis.AllData.Time.Zero(ignoreTrialFilter);

    case 'update'
for e=1:nEpochs
    Analysis.AllData.Time.(epochNames{e})=Analysis.AllData.Time.(epochNames{e})(ignoreTrialFilter,:)+epochReset(e,:)-Analysis.AllData.Time.Zero;
end
end
