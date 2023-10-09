function [errorFile,DB_Stat]=AP_FileBatch(LP,DB,DB_Stat,batchType)
errorCount=0;
errorFile={};
thisOrigin=pwd;

switch batchType
    %% DataBase
    case 'DataBase'
    DB.DataBase=1;
    LP.P.SortFilters=1;
    LP.P.Illustration=[0 0]; 
    listGroup=ls;
    for g=3:size(listGroup,1)
        thisGroup=listGroup(g,:)
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
listGroup=ls;
for g=3:size(listGroup,1)
    cd(thisOrigin)
    thisGroup=listGroup(g,:)
    cd(thisGroup)
    pwdGroup=pwd;
    listAnimal=ls;
    for a=3:size(listAnimal,1)
        cd(pwdGroup)
        try
        thisAnimal=listAnimal(a,:)
        if isempty(strfind(thisAnimal,'Bonsai')) && isempty(strfind(thisAnimal,'Histology'))
            cd(thisAnimal)
            pwdAnimal=pwd;
            listBehavior=ls;
            for k=3:size(listBehavior,1)
                cd(pwdAnimal)
                try
                    thisBehavior=listBehavior(k,:)
                    cd(thisBehavior)
                    cd 'Session Data'
                    pwdBehavior=pwd;
                    LP.PathName=pwdBehavior;
                    fileList=ls('*.mat');
                    LP.FileList=fileList;
                for f=1:size(fileList)
                    cd(pwdBehavior)
                    try
                        thisFile=fileList(f,:)
                        LP.FileToOpen{1}=thisFile;
                        Analysis_Photometry(LP);
                    catch
                        errorCount=errorCount+1;
                        errorFile{errorCount}=thisFile;
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