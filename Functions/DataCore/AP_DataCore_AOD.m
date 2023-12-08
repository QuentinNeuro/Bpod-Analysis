function Analysis=AP_DataCore_AOD(Analysis)

%% Load stuff
nTrials=Analysis.Parameters.nTrials;
% data
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
    Analysis.Parameters.AOD.AOD=0;
    return
        end
    end
end

%% timestamps
% Bpod timestamp guess
fieldStates=fieldnames(Analysis.Core.States{1,1});
stateStart=fieldStates{2};
StateToZero=Analysis.Parameters.StateToZero;
for thisT=1:nTrials 
    zeroTS_Bpod(thisT)=Analysis.Core.States{1,thisT}.(StateToZero)(1)-Analysis.Core.States{1,thisT}.(stateStart)(1);
end
% Load TTL info
try
    load(['TTL_outcome_' Analysis.Parameters.Files{1}]);
    zeroTS=TTL_Outcome(:,1)';
catch
    disp('Cannot find the TTL file for outcome info')
    zeroTS=zeroTS_Bpod;
end
disp('Time difference between bpod and TTL')
zeroTScomp=mean(zeroTS-zeroTS_Bpod)
switch Analysis.Parameters.AOD.timing
    case 'Bpod'
        zeroTS=zeroTS_Bpod;
    case 'TTL'
        zeroTS=zeroTS;
end
%% Basic parameters
% nTrials=Analysis.Parameters.nTrials;
nData=size(D,2); 
nCells=nData/nTrials;
if mod(nCells,1)
    disp('Error guessing the number of cells for AOD recording')
    Analysis.Parameters.AOD.AOD=0;
    return
end
SR=1000/mean(diff(D(1).x));

%% Sort data by trial
counter=1;
for t=1:nTrials
    for c=1:nCells
        dataTrial{t}(c,:)=D(counter).y;
        counter=counter+1;
    end
end
%% Save in Analysis structure
Analysis.Parameters.nCells=nCells;
Analysis.Parameters.AOD.sampRate=SR;
Analysis.Core.AOD_TS=zeroTS;
Analysis.Core.AOD=dataTrial;
end

%%%%%% TTL readings %%%%%
% TTL_Outcome=zeros(size(D,2),2);
% for thisT=1:size(D,2)
%     indices=find(D(thisT).y);
%     TTL_Outcome(thisT,:)=[D(thisT).x(indices(1)) D(thisT).x(indices(end))]/1000;
% end