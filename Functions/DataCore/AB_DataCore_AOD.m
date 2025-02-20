function Analysis=AB_DataCore_AOD(Analysis)
%% Load stuff
% Lists
rawFile=ls('raw*');
if isempty(rawFile)
    rawFile=ls('calcium*');
end
dffFile=ls('dff*');
ttlFile=ls('TTL*');
% Check 
if Analysis.Parameters.AOD.raw & ~isempty(rawFile)
    load(rawFile)
elseif ~isempty(dffFile)
    load(dffFile)
    Analysis.Parameters.AOD.raw=0;
else
    Analysis.Parameters.AOD.AOD=0;
    disp('AOD : error loading fluorescent data')
    return
end

%% Basic parameters
nTrials=Analysis.Parameters.Behavior.nTrials;
nData=size(D,2); 
nCells=nData/nTrials;
if mod(nCells,1)
    disp('Error guessing the number of cells for AOD recording')
    Analysis.Parameters.AOD.AOD=0;
    return
end
sampRate=1000/mean(diff(D(1).x));

%% Sort data by trial
counter=1;
for t=1:nTrials
    for c=1:nCells
        dataTrial{t}(:,c)=D(counter).y;
        counter=counter+1;
    end
end
%% Save in Analysis structure
Analysis.Parameters.Data.nCells=nCells;
Analysis.Parameters.AOD.SamplingRate=sampRate;
Analysis.Parameters.AOD.min=min(nData);
Analysis.Parameters.AOD.nCells=nCells;
Analysis.Parameters.AOD.recRaw=Analysis.Parameters.AOD.raw;
Analysis.Core.AOD=dataTrial;
if ~isempty(ttlFile)
    load(ttlFile)
    Analysis.Core.AOD_TS=TTL_Outcome(:,1)';
end
end

%%%%%% TTL readings %%%%%
% TTL_Outcome=zeros(size(D,2),2);
% for thisT=1:size(D,2)
%     indices=find(D(thisT).y);
%     TTL_Outcome(thisT,:)=[D(thisT).x(indices(1)) D(thisT).x(indices(end))]/1000;
% end