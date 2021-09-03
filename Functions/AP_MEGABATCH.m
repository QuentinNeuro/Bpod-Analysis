function AP_MEGABATCH(LP)

Dir_GROUP=ls
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
                FileList=ls;
                LP.FileList=FileList(3:end,:);
                for f=3:size(FileList)
                    try
                    thisFile=FileList(f,:)
                    if contains(thisFile,'mat')
                        LP.FileToOpen{1}=thisFile;
                        try
                            Analysis_Photometry(LP);
                        catch
                            disp('Could not analyze this file')
                        end
                    end
                    catch
                    end
                end
                cd ..
                cd ..
                catch
                end
            end
            cd ..
        end
        catch
        end
    end
    cd ..
end
end