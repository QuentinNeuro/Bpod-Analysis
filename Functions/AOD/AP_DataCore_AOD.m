function Analysis=AP_DataCore_AOD(Analysis) 
%% Adjust for old behavior
switch Analysis.Parameters.StateOfOutcome
    case 'WaitForLick'
        Analysis.Parameters.StateToZero=Analysis.Parameters.StateOfCue;
end

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
        try
            load(['dff_' Analysis.Parameters.Files{1}]);
            Analysis.Parameters.AOD.raw=0;
            Analysis.Parameters.AOD.offset=0;
        catch 
    disp('could not find corresponding AOD data')
        end
    end
end
%% Parameters 
fieldStates=fieldnames(Analysis.Core.States{1,1});
stateStart=fieldStates{2}; 
stateOutcome=Analysis.Parameters.StateOfOutcome;
nTrials=Analysis.Parameters.nTrials;
nData=size(D,2); 
nCells=nData/nTrials;
Analysis.Parameters.AOD.nCells=nCells;
Analysis.Parameters.AOD.nSamples=length(D(1).x);

if mod(nCells,1)
    disp('Error guessing the number of cells for AOD recording')
    Analysis.Parameters.AOD.AOD=0;
end

% Analysis.Parameters.Photometry=1;
Analysis.Parameters.AOD.sampRateRec=1000/mean(diff(D(1).x));
if Analysis.Parameters.AOD.decimateSR>Analysis.Parameters.AOD.sampRateRec || Analysis.Parameters.AOD.decimateSR==0
    Analysis.Parameters.AOD.decimateSR=Analysis.Parameters.AOD.sampRateRec;
end
Analysis.Parameters.AOD.sampRate=Analysis.Parameters.AOD.decimateSR;

%% Timing from Analysis structure or TTL 
try
    load(['TTL_outcome_' Analysis.Parameters.Files{1}]);
    Analysis.Core.AOD.Zero=TTL_Outcome(:,1)';
catch
    disp('Cannof find the TTL file for outcome info')
    for thisT=1:nTrials 
        Analysis.Core.AOD.Zero(thisT)=Analysis.Core.States{1,thisT}.(stateOutcome)(1)-Analysis.Core.States{1,thisT}.(stateStart)(1);
    end
end
%% AOD Data
Analysis.Core.AOD.time=D(1).x/1000;
for thisCT=1:nData
    Analysis.Core.AOD.Data(:,thisCT)=D(thisCT).y;
end

for thisT=0:nTrials-1
    indexTrial=thisT*nCells+1:(thisT+1)*nCells;
    Analysis.Core.AOD.DataTrialAVG{thisT+1}=mean(Analysis.Core.AOD.Data(:,indexTrial),2);
end

end 