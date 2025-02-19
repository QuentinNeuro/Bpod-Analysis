function Analysis=AB_DataCore_Miniscope(Analysis)

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
nCells=size(traces,2);
nTrials=Analysis.Parameters.Behavior.nTrials;

%% Sort data by trial
for t=1:nTrials-1
    dtrial{t}=traces(frameStartIdx(t):frameStartIdx(t+1),:);
end
dtrial{t+1}=traces(frameStartIdx(t+1):end,:);

%% Save into Analysis structure
Analysis.Parameters.Data.nCells=nCells;
Analysis.Core.TS_mini=zeroTS-trialStartTS;
Analysis.Core.Miniscope=dtrial;
end