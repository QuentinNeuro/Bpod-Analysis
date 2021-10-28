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
sampRate=1000/(D(1).x(2)-D(1).x(1)); 
nCells=nData/nTrials;
dsampRate=Analysis.Parameters.AOD.decimateSR;
if dsampRate
    decimateFactor=floor(sampRate/dsampRate);
    Analysis.Parameters.AOD.sampRate=dsampRate;
else
    Analysis.Parameters.AOD.sampRate=sampRate;
end
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
thisTime=D(1).x/1000;
if dsampRate
    thisTime=decimate(thisTime,decimateFactor);
end
Analysis.Core.AOD.Time=thisTime;
 
for thisCT=1:nData
    thisData=D(thisCT).y; 
    if Analysis.Parameters.AOD.smoothing
        thisData=smooth(thisData);
    end
    if dsampRate
        thisData=decimate(thisData,decimateFactor);
    end
    Analysis.Core.AOD.Data(:,thisCT)=thisData;
end
%% Save in parameter structure
Analysis.Parameters.AOD.nCells=nCells;
Analysis.Parameters.AOD.nSamples=length(thisTime);
end 