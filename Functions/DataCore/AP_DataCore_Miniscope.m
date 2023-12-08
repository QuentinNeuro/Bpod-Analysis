function Analysis=AP_DataCore_Miniscope(Analysis)

%% Load stuff
% timestamps
try
load('trialStartFrame.mat'); 
load('trialStartTS.mat'); 
load('trialZeroTS.mat');
catch
    disp('Could not find TTL files - Attempting to generate using SaleaReader.m')
    try
        SaleaReader()
        load('trialStartFrame.mat'); 
        load('trialStartTS.mat'); 
        load('trialZeroTS.mat');
    catch
        disp('Could not generate TTL files - Miniscope analysis abort')
        Analysis.Parameters.Miniscope.Miniscope=0;
        return
    end
end
% data
load('rec_extract.mat');

%% Basic parameters
SR=Analysis.Parameters.Miniscope.SR;
nCells=size(traces,2);
nbOfTrial=Analysis.Parameters.nTrials;
Analysis.Parameters.nCells=nCells;

%% Sort data by trial
for t=1:nbOfTrial-1
    dtrial{t}=traces(frameStartIdx(t):frameStartIdx(t+1),:);
end
dtrial{t+1}=traces(frameStartIdx(t+1):end,:);

%% Save into Analysis structure
Analysis.Core.TS_mini=zeroTS-trialStartTS;
Analysis.Core.Miniscope=dtrial;
end