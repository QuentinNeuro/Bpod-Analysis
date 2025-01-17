function Analysis=AP_DataProcess_Prime(Analysis)

%% Load Parameters and data
switch Analysis.Parameters.Prime.DataType
    case 'Angle'
Analysis.Parameters.nCells=Analysis.Parameters.Prime.nAngle;
data=Analysis.Core.Prime_Angle;
    case 'Depth'
Analysis.Parameters.nCells=Analysis.Parameters.Prime.nDepth;
data=Analysis.Core.Prime_Depth;
end

sampRate=Analysis.Parameters.Prime.sampRate;
nTrials=Analysis.Parameters.nTrials;
nCells=Analysis.Parameters.nCells;

baselinePts=ceil(Analysis.Parameters.NidaqBaseline*sampRate); 
timeWindow=Analysis.Parameters.ReshapedTime;
CueTime=Analysis.AllData.Time.Cue+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome+Analysis.Parameters.OutcomeTimeReset;
timeToZero=Analysis.AllData.Time.Zero;

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

%% Process data
% Baseline Calculation
for t=1:nTrials
        baseAVG(:,t)=mean(data{t}(:,baselinePts(1):baselinePts(2)),2,'omitnan');
        baseSTD(:,t)=std(data{t}(:,baselinePts(1):baselinePts(2)),[],2,'omitnan');
end
if Analysis.Parameters.Prime.raw
if Analysis.Parameters.BaselineMov
    baseAVG=movmean(baseAVG,Analysis.Parameters.BaselineMov,2,'omitnan');
    baseSTD=movmean(baseSTD,Analysis.Parameters.BaselineMov,2,'omitnan');
end
% Data Normalization
    for t=1:nTrials
        if Analysis.Parameters.Zscore
            data{t}=(data{t}-baseAVG(:,t))./baseSTD(:,t);
        else
            data{t}=100*(data{t}-baseAVG(:,t))./baseAVG(:,t);
        end
    end
end

%% make PSTH for each trial
for t=1:nTrials
    for c=1:nCells
        [thisTime,thisData]=AP_PSTH(data{t}(c,:),timeWindow,timeToZero(t),sampRate);
        % thisData=thisData-mean(thisData(1:sampRate),'omitnan');
        dataTrial{t}(c,:)=thisData;
        dataCells{c}(t,:)=thisData;
    end
    timeTrial(t,:)=thisTime;
end

%% Save in structure and generate metrics
Analysis.AllData.AllCells.Time=timeTrial;
Analysis.AllData.AllCells.Data = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
for c=1:nCells
    thisC_Name=sprintf('cell%.0d',c);
    Analysis.AllData.AllCells.CellName{c}       =thisC_Name;
    Analysis.AllData.(thisC_Name).Time          =timeTrial;
    Analysis.AllData.(thisC_Name).Data          =dataCells{c};
end    
Analysis=AP_DataProcess_SingleCells(Analysis,baseAVG,baseSTD);

end