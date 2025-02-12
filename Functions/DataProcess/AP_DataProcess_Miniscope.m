function Analysis=AP_DataProcess_Miniscope(Analysis)

%% Parameters
nTrials=Analysis.Parameters.Behavior.nTrials;
cellID=Analysis.Parameters.Miniscope.CellID;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Miniscope.SR;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselinePts=Analysis.Parameters.Data.NidaqBaselinePoints;

%% Check timing between miniscope and bpod
startToZero_mini=Analysis.Core.TS_mini;
startToZero_Bpod=Analysis.AllData.Time.Zero';
zeroComp_mini_Bpod=startToZero_mini-startToZero_Bpod;
if max(abs(zeroComp_mini_Bpod))>2/SR
    countMax=sum(abs(zeroComp_mini_Bpod)>2/SR);
    thisMax=max(abs(zeroComp_mini_Bpod));
    sprintf('%.0d trials have a jitter superior to 2 images, with a maximum of %.0d sec',countMax,thisMax)
end

%% PSTH and baseline extraction
data=Analysis.Core.Miniscope;
dataBaseline=[];
for t=1:nTrials
    for c=1:nCells
        [timeTW,dataTW]=AP_PSTH(data{t}(:,c),timeWindow,timeToZero(t),sampRate);
        dataTrial{t}(c,:)=dataTW;
        dataCells{c}(t,:)=dataTW;

         switch testBaseline
            case 1
                dataBaseline{c}(t,:)=data{t}(baselinePts(1):baselinePts(2),c);
            case 2
                dataBaseline{c}(t,:)=dataTW(baselinePts(1):baselinePts(2));
        end
    end
    timeTrial(t,:)=timeTW;
end


%% Save in structure and generate metrics
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
for c=1:nCells
    thisID=cellID{c};
    Analysis.AllData.AllCells.CellName{c}       = thisID;
    Analysis.AllData.(thisID).Time              = timeTrial;
    Analysis.AllData.(thisID).Data              = dataCells{c};
    Analysis.AllData.(thisID).DataBaseline      = dataBaseline{c};
end
end    
