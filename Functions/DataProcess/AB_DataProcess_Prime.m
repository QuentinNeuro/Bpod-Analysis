function Analysis=AB_DataProcess_Prime(Analysis)

%% Load Parameters and data
nTrials=Analysis.AllData.nTrials;
sampRate=Analysis.Parameters.Prime.SamplingRate;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
timeToZero=Analysis.AllData.Time.Zero;

% Baseline and Normalize
testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRate;
testNorm=Analysis.Parameters.Prime.raw;

% Prime Specific
switch Analysis.Parameters.Prime.DataType
    case 'Angle'
nCells=Analysis.Parameters.Prime.nAngle;
data=Analysis.Core.Prime_Angle(Analysis.Filters.ignoredTrials);
    case 'Depth'
nCells=Analysis.Parameters.Prime.nDepth;
data=Analysis.Core.Prime_Depth(Analysis.Filters.ignoredTrials);
end
Analysis.Parameters.Data.nCells=nCells;

%% Preprocessing - smoothing and decimate
% Exclude data
if Analysis.Parameters.Prime.SiteExclusion
    filterExclusion=true(1,nCells);
    filterExclusion(Analysis.Parameters.Prime.SiteExclusion)=false;
    for t=1:nTrials
        data{t}=data{t}(filterExclusion,:);
    end
    nCells=sum(filterExclusion);
    Analysis.Parameters.nCells=nCells;
end

% smoothing
if Analysis.Parameters.Prime.smoothing
    data = cellfun(@(x) smoothdata(x,2,"gaussian",Analysis.Parameters.Prime.smoothing),data,'UniformOutput',false);
end

%% PSTH and baseline extraction
for c=1:nCells
    dataBaseline=[];
    for t=1:nTrials
        thisData=data{t}(c,:);
        [timeTW,dataTW]=myPSTH(thisData,PSTH_TW,timeToZero(t),sampRate);
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
Analysis.Parameters.Data.Label = {['Prime ' Analysis.Parameters.Prime.DataType]};
Analysis.Parameters.Prime.CellID=Analysis.AllData.AllCells.CellName;
Analysis.AllData.AllCells.Time = timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');

%Analysis.AllData.AllCells=AB_DataProcess_Epochs(Analysis.AllData.AllCells,Analysis);

end