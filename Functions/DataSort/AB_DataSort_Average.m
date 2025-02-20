function Analysis=AB_DataSort_Average(Analysis,FilterName)

%% Parameters
thisType=FilterName;
recordingType=Analysis.Parameters.Data.RecordingType;
nCells=Analysis.Parameters.Data.nCells;
nTrials=Analysis.(thisType).nTrials;
nTrialSQRT=sqrt(nTrials);

epochNames=Analysis.Parameters.Timing.EpochNames;
epochTime=Analysis.(thisType).Time;
nEpochs=size(epochNames,2);
%% Detect data fields to average data
dataFields{1}='Licks';
if ~isempty(recordingType)
    dataFields=[dataFields Analysis.Parameters.(recordingType).CellID];
end
if any(Analysis.Parameters.Wheel.Wheel)
    dataFields=[dataFields 'Wheel'];
end
if any(Analysis.Parameters.Pupillometry.Pupillometry)
    dataFields=[dataFields 'Pupil'];
end
nFields=size(dataFields,2);
%% Generate averages
for f=1:nFields
    Analysis.(thisType).(dataFields{f}).DataAVG=mean(Analysis.(thisType).(dataFields{f}).Data,1,'omitnan'); 
    Analysis.(thisType).(dataFields{f}).DataSEM=std(Analysis.(thisType).(dataFields{f}).Data,0,1,'omitnan')/nTrialSQRT;
    fieldsLvl2=fieldnames(Analysis.(thisType).(dataFields{f}));
    for e=1:nEpochs
        epochFields=fieldsLvl2(contains(fieldsLvl2,epochNames{e}));
        for ef=1:size(epochFields,1)
            Analysis.(thisType).(dataFields{f}).([epochFields{ef} '_AVG'])=mean(Analysis.(thisType).(dataFields{f}).(epochFields{ef}),'omitnan');
            Analysis.(thisType).(dataFields{f}).([epochFields{ef} '_SEM'])=std(Analysis.(thisType).(dataFields{f}).(epochFields{ef}),0,1,'omitnan')/nTrialSQRT;
        end
    % calculate max of the average trace
    thisTimeAVG=mean(Analysis.(thisType).(dataFields{f}).Time,1,'omitnan');
    thisDataAVG=Analysis.(thisType).(dataFields{f}).DataAVG;
    thisEpochTime=mean(epochTime.(epochNames{e}),1,'omitnan');
    epochPre_AVG=Analysis.(thisType).(dataFields{f}).([epochNames{e} 'Pre_AVG']);
    epochAVG_MAX=max(thisDataAVG(thisTimeAVG>thisEpochTime(1) & thisTimeAVG<thisEpochTime(2)),[],'omitnan');
    epochAVG_MAXZ=epochAVG_MAX-epochPre_AVG;
    Analysis.(thisType).(dataFields{f}).([epochNames{e} 'AVG_MAX'])=epochAVG_MAX;
    Analysis.(thisType).(dataFields{f}).([epochNames{e} 'AVG_MAXZ'])=epochAVG_MAXZ;
    end
end

%% AllData_AllCells specific
if nCells
    cellID=Analysis.Parameters.(recordingType).CellID;
    for c=1:nCells
        thisID=cellID{c};
        dataCells(c,:)=Analysis.(thisType).(thisID).DataAVG;
        for t=1:nTrials
            dataTrial{t}(c,:)=Analysis.(thisType).(thisID).Data(t,:);
        end
    end
    Analysis.(thisType).AllCells.Data_Cell  = dataCells;
    Analysis.(thisType).AllCells.Data       = cell2mat(cellfun(@(x) mean(x,1,'omitnan'),dataTrial,'UniformOutput',false)');
    Analysis.(thisType).AllCells.DataAVG    = mean(dataCells,1,'omitnan');
    Analysis.(thisType).AllCells.DataSEM    = std(dataCells,0,1,'omitnan')/nTrialSQRT;
end
end