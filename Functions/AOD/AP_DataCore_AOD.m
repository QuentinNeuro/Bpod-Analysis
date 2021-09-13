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
    Analysis.Parameters.AOD_offset
    offset=0;
end
Analysis.Parameters.AOD_offset;
catch
    disp('could not find corresponding AOD data')
end

%% Parameters 
stateStart='AO_WarmUp'; 
stateOutcome=Analysis.Parameters.StateOfOutcome;
nTrials=Analysis.Core.nTrials; 
nData=size(D,2); 
nSamples=length(D(1).y); 

Analysis.Core.AOD.nCells=nData/nTrials; 
Analysis.Core.AOD.sampRate=1/(1000*(D(1).x(2)-D(1).x(1))); 
 
%% Timing from Analysis structure or TTL 
counter=0;
for thisT=1:nTrials 
    Analysis.Core.AOD.Time.Start(thisT)=Analysis.Core.States{1,thisT}.(stateStart)(1); 
    Analysis.Core.AOD.Time.Outcome(thisT)=Analysis.Core.States{1,thisT}.(stateOutcome)(1); 
    Analysis.Core.AOD.Time.Zero(1+counter:nCells+counter)=Analysis.Core.AOD.timeOutcome(thisT)-Analysis.Core.AOD.timeStart(thisT);
    counter=counter+nCells;
end 

try
    load(['TTL_outcome_' Analysis.Parameters.Files{1}]);
    counter=0;
    for thisT=1:nTrials
        Analysis.Core.AOD.Time.Zero(1+counter:nCells+counter)=TTL_Outcome(thisT,1);
        counter=counter+nCells;
    end
catch
    disp('TTL file absent, using bpod state timing instead');
end
 
 
%% AOD Data   -
for thisCT=1:nData 
    Analysis.Core.AOD.Time(:,thisCT)=D(thisCT).x/1000; 
    Analysis.Core.AOD.Data(:,thisCT)=D(thisCT).y; 
end
end 