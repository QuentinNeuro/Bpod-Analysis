function Analysis=AB_DataProcess_AOD(Analysis)

%% Parameters
nTrials=Analysis.AllData.nTrials;
nCells=Analysis.Parameters.Data.nCells;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
% Sampling Rate
sampRate=Analysis.Parameters.AOD.SamplingRate;
sampRateDecimated=Analysis.Parameters.Data.SamplingRateDecimated;
if sampRate<sampRateDecimated
    disp('Error in decimating processed photometry data : sampling Rate is lower than requested decimated sampling rate')
    sampRateDecimated=sampRate;
end
Analysis.Parameters.AOD.SamplingRateDecimated=sampRateDecimated;
[p,q] = rat(sampRateDecimated / sampRate);
% Baseline and Normalize
testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRateDecimated;
testNorm=Analysis.Parameters.AOD.raw;

%% AOD Timing
fieldStates=fieldnames(Analysis.Core.States{1,1});
startState=fieldStates{2};
for t=1:Analysis.Core.nTrials
    AODTimeOffset(t,1)=Analysis.Core.States{1,t}.(startState)(1)+Analysis.Parameters.AOD.offsetTime;
end
AODTimeOffset=AODTimeOffset(Analysis.Filters.ignoredTrials);
timeToZero_Bpod=timeToZero-AODTimeOffset;
if isfield(Analysis.Core,'AOD_TS')
    timeToZero_TTL=Analysis.Core.AOD_TS(Analysis.Filters.ignoredTrials);
    Analysis.AllData.Time.AODTTL=timeToZero_TTL;
    disp('Time difference between bpod and TTL')
    zeroTScomp=mean(timeToZero_TTL'-timeToZero_Bpod)
end
if contains(Analysis.Parameters.AOD.timing,'TTL') && isfield(Analysis.Core,'AOD_TS')
    timeToZeroAOD=timeToZero_TTL;
else
    Analysis.Parameters.AOD.timing='Bpod';
    timeToZeroAOD=timeToZero_Bpod;
end

%% Preprocessing - smoothing and offset
data=Analysis.Core.AOD(Analysis.Filters.ignoredTrials);
AODoffset=Analysis.Parameters.AOD.offset;
AODsmooth=Analysis.Parameters.AOD.smoothing;

% offset
if ischar(AODoffset)
    switch AODoffset
        case 'auto'
            m = cellfun(@(x) min(x,[],'all'),data);
            AODoffset=min(m,[],'all')-1;
        otherwise
            AODoffset=0;
    end
end
if AODoffset>0
    data = cellfun(@(x) x-AODoffset,data,'UniformOutput',false);
end
% smoothing
if AODsmooth
    data = cellfun(@(x) smoothdata(x,1,"gaussian",AODsmooth),data,'UniformOutput',false);
end

%% PSTH and baseline extraction
for c=1:nCells
    dataBaseline=[];
    for t=1:nTrials
        % thisData=resample(data{t}(:,c),p,q);
        thisData=data{t}(:,c);
        [timeTW,dataTW]=myPSTH(thisData,PSTH_TW,timeToZeroAOD(t),sampRate);
        dataCells{c}(t,:)=dataTW;
        switch testBaseline
            case 1
                dataBaseline(t,:)=thisData(baselinePts(1):baselinePts(2));
            case 2
                dataBaseline(t,:)=dataTW(baselinePts(1):baselinePts(2));
        end
        timeTrial(t,:)=timeTW;
    end
% Baseline calculation and data normalization
    [dataCells_N,baselineAVG,baselineSTD]=AB_DataProcess_Normalize(Analysis,timeTrial,dataCells{c},dataBaseline);
    if testNorm
        dataCells{c}=dataCells_N;
    end
% For AllCells structure
    for t=1:nTrials
        dataTrial{t}(c,:)= dataCells{c}(t,:);
    end

%% Save in structure
    thisID=sprintf('cell%.0d',c);
    Analysis.AllData.AllCells.CellName{c}       = thisID;
    Analysis.AllData.(thisID).Time              = timeTrial;
    Analysis.AllData.(thisID).Data              = dataCells{c};
    Analysis.AllData.(thisID).BaselineAVG       = baselineAVG;
    Analysis.AllData.(thisID).BaselineSTD       = baselineSTD;

    Analysis.AllData.(thisID)=AB_DataProcess_Epochs(Analysis.AllData.(thisID),Analysis);
end
Analysis.Parameters.Data.Label     = {['AOD ' Analysis.Parameters.Data.Label]};
Analysis.Parameters.AOD.CellID     = Analysis.AllData.AllCells.CellName;
Analysis.AllData.AllCells.Time     = timeTrial;
Analysis.AllData.AllCells.Data     = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
Analysis.AllData.Time.AODOffset    = AODTimeOffset;
%% Adjust some parameters
% %% remove trials with too many missing points
%     nanCount=sum(isnan(Analysis.AllData.cell1.Data))<SR*2;
%     Analysis.Filters.ignoredTrials=Analysis.Filters.ignoredTrials.*nanCount;
end