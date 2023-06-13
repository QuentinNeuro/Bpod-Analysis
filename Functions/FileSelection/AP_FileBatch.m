function [errorFile,DB_Stat]=AP_FileBatch(LP,DB,DB_Stat,batchType)
errorCount=0;
errorFile={};
thisOrigin=pwd;

switch batchType
    %% DataBase
    case 'DataBase'
    DB.DataBase=1;
    Dir_GROUP=ls;
    for g=3:size(Dir_GROUP,1)
        thisGroup=Dir_GROUP(g,:)
        cd(thisGroup)
        fileList=ls('*CuedOutcome*');
        LP.FileList=fileList;
        for f=1:size(fileList)
            thisFile=fileList(f,:)
            if ~contains(thisFile,'Pupil')
            try
                thisFile=fileList(f,:)
                LP.FileToOpen{1}=thisFile;
                LP.PathName=[pwd filesep];
                Analysis=Analysis_Photometry(LP);
                if DB.DataBase
                    DB_Stat=Database_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB.Group);
                    DB_Stat.LP=LP;
                    disp(Analysis.Parameters.CueTimeReset)
                end
            catch
                errorCount=errorCount+1;
                errorFile{errorCount}=thisFile;
            end
            end
            close all
        end
        cd(thisOrigin)
    end

%% Spikes
    case 'Spikes'
folders=ls('VIP-*');
for f=1:size(folders,1)
    thisFolder=deblank(folders(f,:))
    cd(thisFolder);
    cd(ls('*offlinesorter'))
    thisFile=ls('*CuedOutcome*');
    if ~isempty(thisFile)
    try
        LP.FileList=thisFile;
        LP.FileToOpen=cellstr(LP.FileList);
        LP.PathName=[pwd filesep];
        Analysis_Photometry(LP)
    catch
        errorCount=errorCount+1;
        errorFile{errorCount}=thisFolder;
    end
    end
    cd(thisOrigin)
end

%% MegaBatch
    case 'MegaBatch'
Dir_GROUP=ls;
for g=3:size(Dir_GROUP,1)
    thisGroup=Dir_GROUP(g,:)
    cd(thisGroup)
    Dir_ANIMAL=ls;
    for a=3:size(Dir_ANIMAL,1)
        try
        thisAnimal=Dir_ANIMAL(a,:)
        if isempty(strfind(thisAnimal,'Bonsai')) && isempty(strfind(thisAnimal,'Histology'))
            cd(thisAnimal)
            Dir_BEHAVIOR=ls;
            for k=3:size(Dir_BEHAVIOR,1)
                try
                    thisBehavior=Dir_BEHAVIOR(k,:)
                    cd(thisBehavior)
                    cd 'Session Data'
                    LP.PathName=pwd;
                    fileList=ls('*.mat');
                    LP.FileList=fileList;
                for f=1:size(fileList)
                    try
                        thisFile=fileList(f,:)
                        LP.FileToOpen{1}=thisFile;
                        Analysis_Photometry(LP);
                    catch
                        errorCount=errorCount+1;
                        errorFile{errorCount}=thisFolder;
                    end
                end
                catch
                end
            end
        end
        catch
        end
    end
end
end
end