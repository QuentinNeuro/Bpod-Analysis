function Analysis=AB_DataProcess_Timing(Analysis,action)

%% Parameters
nTrials=Analysis.Core.nTrials;
ignoreTrialFilter=Analysis.Filters.ignoredTrials;
nEpochs=size(Analysis.Parameters.Timing.EpochNames,2);
epochNames=Analysis.Parameters.Timing.EpochNames;
epochStates=Analysis.Parameters.Timing.EpochStates;
ForceEpochTimeReset=Analysis.Parameters.Timing.ForceEpochTimeReset;

if ~isfield(Analysis.Parameters.Timing,'EpochTimeReset_auto')
    Analysis.Parameters.Timing.EpochTimeReset_auto= Analysis.Parameters.Timing.EpochTimeReset;
end

switch action
    case 'ini'
epochReset=Analysis.Parameters.Timing.EpochTimeReset_auto;
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
for e=1:size(ForceEpochTimeReset,1)
        if ~isnan(ForceEpochTimeReset(e,:))
            epochReset(e,:)=ForceEpochTimeReset(e,:);
        end
end
Analysis.Parameters.Timing.EpochTimeReset=epochReset;
%% Process PSTH and Epoch Times
for t=1:nTrials
    Analysis.AllData.Time.Zero(t,1)=Analysis.Core.States{1,t}.(StateToZero)(1);
    for e=1:nEpochs
        Analysis.AllData.Time.(epochNames{e})(t,:)=Analysis.Core.States{1,t}.(epochStates{e});
    end
end
Analysis.AllData.Time.Zero=Analysis.AllData.Time.Zero(ignoreTrialFilter);

    case 'update'
epochReset=Analysis.Parameters.Timing.EpochTimeReset;
for e=1:nEpochs
    Analysis.AllData.Time.(epochNames{e})=Analysis.AllData.Time.(epochNames{e})(ignoreTrialFilter,:)+epochReset(e,:)-Analysis.AllData.Time.Zero;
end

% Spikes

end
