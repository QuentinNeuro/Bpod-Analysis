function AP_MEGABATCH(LP)

Dir_GROUP=ls
for g=3:size(Dir_GROUP,1)
    thisGroup=Dir_GROUP(g,:)
    cd(thisGroup)
    Dir_ANIMAL=ls;
    for a=3:size(Dir_ANIMAL,1)
        thisAnimal=Dir_ANIMAL(a,:)
        if isempty(strfind(thisAnimal,'Bonsai')) && isempty(strfind(thisAnimal,'Histology'))
            cd(thisAnimal)
            Dir_BEHAVIOR=ls;
            for k=3:size(Dir_BEHAVIOR,1)
                thisBehavior=Dir_BEHAVIOR(k,:)
                cd(thisBehavior)
                cd 'Session Data'
                LP.PathName=pwd;
                FileList=ls;
                LP.FileList=FileList(3:end,:);
                for f=3:size(FileList)
                    thisFile=FileList(f,:)
                    if contains(thisFile,'mat')
                        LP.FileToOpen{1}=thisFile;
                        try
                            Analysis_Photometry(LP);
                        catch
                            disp('Could not analyze this file')
                        end
                    end
                end
                cd ..
                cd ..
            end
            cd ..
        end
    end
    cd ..
end
end