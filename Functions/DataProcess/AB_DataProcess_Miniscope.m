function Analysis=AB_DataProcess_Miniscope(Analysis)

%% Parameters
nTrials=Analysis.AllData.nTrials;
nCells=Analysis.Parameters.Data.nCells;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
timeToZero=Analysis.AllData.Time.Zero;
sampRate=Analysis.Parameters.Miniscope.SamplingRate;
% Baseline & Normalize
testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRate;
testNorm=Analysis.Parameters.Miniscope.raw;

%% Check timing between miniscope and bpod
startToZero_mini=Analysis.Core.TS_mini;
startToZero_Bpod=Analysis.AllData.Time.Zero;
zeroComp_mini_Bpod=startToZero_mini-startToZero_Bpod;
if max(abs(zeroComp_mini_Bpod))>2/sampRate
    countMax=sum(abs(zeroComp_mini_Bpod)>2/sampRate);
    thisMax=max(abs(zeroComp_mini_Bpod));
    sprintf('%.0d trials have a jitter superior to 2 images, with a maximum of %.0d sec',countMax,thisMax)
end

%% PSTH and baseline extraction
data=Analysis.Core.Miniscope(Analysis.Filters.ignoredTrials);
for c=1:nCells
    dataBaseline=[];
    for t=1:nTrials
        thisData=data{t}(:,c);
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
    % if testNorm
    %     dataCells{c}=dataCells_N;
    % end
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
Analysis.Parameters.Data.Label={['Miniscope ' Analysis.Parameters.Data.Label]};
Analysis.Parameters.Miniscope.CellID=Analysis.AllData.AllCells.CellName;
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
end    
