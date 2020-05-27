clear all
%% select folder containing individual animal folders
path=uigetdir;
cd(path)

%% Loop
AList=ls;
for thisA=3:size(AList,1)
    cd(AList(thisA,:))
    SList=ls;
    for thisS=1:size(SList,1)
    try
        SList(thisS,:)
        NewName=thisRename(SList(thisS,:),'MonthS2N');
        movefile(SList(thisS,:),NewName,'f')
    catch
        disp([SList(thisS,:),'_Cannot be process']);
    end
    end
    cd(path)
end

function NewName=thisRename(OldName,RenameType)
switch RenameType
    case 'MonthS2N'
        USindex=strfind(OldName,'_');
        switch OldName(USindex(2)+1:USindex(2)+3)
            case 'Jan'
                Nb='01';
            case 'Feb'
                Nb='02';
            case 'Mar'
                Nb='03';
            case 'Apr'
                Nb='04';
            case 'May'
                Nb='05';
            case 'Jun'
                Nb='06';
            case 'Jul'
                Nb='07';
            case 'Aug'
                Nb='08';
            case 'Sep'
                Nb='09';
            case 'Oct'
                Nb='10';
            case 'Nov'
                Nb='11';
            case 'Dec'
                Nb='12';
            otherwise
                Nb=[];
                disp(['Did not find a valid month string at the expected position for ' OldName])
        end
        NewName=[OldName(1:USindex(2)) Nb OldName(USindex(2)+1:end)];
    otherwise
        disp('Unknown renaming request')
end
end
