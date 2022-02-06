function Analysis=AP_DataCore_AOD(Analysis) 
%% loading AOD files 
try
if Analysis.Parameters.AOD.raw
    load(['raw_calcium_of_' Analysis.Parameters.Files{1}]);
else
    load(['dff_calcium_of_' Analysis.Parameters.Files{1}]);
    Analysis.Parameters.AOD.offset=0;
end

catch
    try
        load(['calcium_of_' Analysis.Parameters.Files{1}]);
        Analysis.Parameters.AOD.raw=0;
        Analysis.Parameters.AOD.offset=0;
    catch
    disp('could not find corresponding AOD data')
    end
end
%% Parameters 
stateStart='AO_WarmUp'; 
stateOutcome=Analysis.Parameters.StateOfOutcome;
nTrials=Analysis.Parameters.nTrials; 
nData=size(D,2); 
Analysis.Parameters.AOD.nCells=nData/nTrials;
Analysis.Parameters.AOD.sampRateRec=1000/mean(diff(D(1).x));
Analysis.Parameters.AOD.nSamples=length(D(1).x);

%% Timing from Analysis structure or TTL 
try
    load(['TTL_outcome_' Analysis.Parameters.Files{1}]);
    Analysis.Core.AOD.Zero=TTL_Outcome(:,1)';
catch
    for thisT=1:nTrials 
        Analysis.Core.AOD.Zero(thisT)=Analysis.Core.States{1,thisT}.(stateOutcome)(1)-Analysis.Core.States{1,thisT}.(stateStart)(1);
    end
end
%% AOD Data
Analysis.Core.AOD.time=D(1).x/1000;
for thisCT=1:nData
    Analysis.Core.AOD.Data(:,thisCT)=D(thisCT).y;
end
end 