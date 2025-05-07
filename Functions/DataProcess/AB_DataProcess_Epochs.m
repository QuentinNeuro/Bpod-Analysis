function dataStructure=AB_DataProcess_Epochs(dataStructure,Analysis)
%% Parameters
time=dataStructure.Time;
data=dataStructure.Data;
nReps=size(data,1);
epochNames=Analysis.Parameters.Timing.EpochNames;
epochTime=Analysis.AllData.Time;
nEpochs=size(epochNames,2);

%% Process data
for e=1:nEpochs
    thisEpochTime=epochTime.(epochNames{e});
    for r=1:nReps
        thisTime=time(r,:);
        thisData=data(r,thisTime>thisEpochTime(r,1) & thisTime<thisEpochTime(r,2));
        epochPre(r,:)=mean(data(r,thisTime>thisEpochTime(r,1)-0.3 & thisTime<thisEpochTime(r,1)),'omitnan');
        if ~isempty(thisData)
            epochMAX(r,:)=max(thisData,[],'omitnan');
        else
            epochMAX(r,:)=NaN;
        end
        epochAVG(r,:)=mean(thisData,'omitnan');
    end

    %% save in structure
    dataStructure.([epochNames{e} 'Pre'])=epochPre;
    dataStructure.([epochNames{e} 'AVG'])=epochAVG;
    dataStructure.([epochNames{e} 'MAX'])=epochMAX;
    dataStructure.([epochNames{e} 'AVGZ'])=epochAVG-epochPre;
    dataStructure.([epochNames{e} 'MAXZ'])=epochMAX-epochPre;
end
end