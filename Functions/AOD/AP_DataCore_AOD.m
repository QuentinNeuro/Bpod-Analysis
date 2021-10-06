function Analysis=AP_DataCore_AOD(Analysis) 
%% loading AOD files 
try
if Analysis.Parameters.AOD_raw
    load(['raw_calcium_of_' Analysis.Parameters.Files{1}]);
    newDFF=1;
    offset=Analysis.Parameters.AOD_offset;
else
    load(['dff_calcium_of_' Analysis.Parameters.Files{1}]);
    newDFF=0;
    offset=0;
end
Analysis.Parameters.AOD_offset;
catch
    try
        load(['calcium_of_' Analysis.Parameters.Files{1}]);
        newDFF=0;
        offset=0;
    catch
    disp('could not find corresponding AOD data')
    end
end

%% Parameters 
stateStart='AO_WarmUp'; 
stateOutcome=Analysis.Parameters.StateOfOutcome;
nTrials=150; 
nData=size(D,2); 
sampRate=1000/(D(1).x(2)-D(1).x(1)); 
nCells=nData/nTrials; 

%% Save in core structure
Analysis.Core.AOD.nCells=nCells;
Analysis.Core.AOD.nSamples=length(D(1).y);
Analysis.Core.AOD.sampRate=sampRate;
 
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
Analysis.Core.AOD.Time=D(1).x/1000;
for thisCT=1:nData
    Analysis.Core.AOD.Data(:,thisCT)=D(thisCT).y; 
end
end 