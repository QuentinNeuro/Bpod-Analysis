% Batch modification of core analysis file
clear all
%% select folder containing individual animal folders
path=uigetdir;
cd(path)

%% Loop
AList=ls;
for thisA=3:size(AList,1)
    cd(AList(thisA,:))
    SList=ls;
    for thisS=3:size(SList,1)
    try
        load(SList(thisS,:))
        SList(thisS,:)
        Analysis=thisSmodif(Analysis,'RemoveIgnoredFilter');
        save(SList(thisS,:),'Analysis')
    catch
        disp([SList(thisS,:),'_Cannot be process']);
    end
    end
    cd(path)
end

%% Function
function Analysis=thisSmodif(Analysis,ModifType)
switch ModifType
    case 'RemoveIgnoredFilter'
        if isfield(Analysis.Core,'ignoredTrials')
            Analysis.Core=rmfield(Analysis.Core,'ignoredTrials');
        end
    case 'RemoveCoreParam'
        if isfield(Analysis.Core,'Parameters')
            Analysis.Core=rmfield(Analysis.Core,'Parameters');
        end
    case 'RawToCoreAndPupil'
    Core=Analysis.Raw;
    Analysis.Core=Core;
    Analysis=rmfield(Analysis,'Raw');
    
    if Analysis.Parameters.Pupillometry
        Analysis.Core=rmfield(Analysis.Core,'Parameters');
        PupParam=Analysis.Parameters.Pupillometry_Parameters;
        PupParam.Pupillometry=1;
        PupParam.StartState=Analysis.Parameters.PupilStartState;
        Analysis.Parameters=rmfield(Analysis.Parameters,'Pupillometry_Parameters');
    else
        PupParam.Pupillometry=0;
    end
    Analysis.Parameters.Pupillometry_Parameters{1}=PupParam;
    if isfield(Analysis.Parameters,'PupilStartState')
        Analysis.Parameters=rmfield(Analysis.Parameters,'PupilStartState');
    end

    case 'AddPupFields'
        if ~isfield(Analysis.Raw,'Parameters')
%             Analysis.Raw.Pup=cell(1,Analysis.Raw.nTrials);
%             Analysis.Raw.PupSmooth=cell(1,Analysis.Raw.nTrials);
%             Analysis.Raw.PupBlink=cell(1,Analysis.Raw.nTrials);
              Analysis.Raw.Parameters.pupFrameRate=[];
              Analysis.Raw.Parameters.pupNFrames=[];
        end
        
    case 'NewFilter'
        Analysis.Filters.Wheel=logical(true(Analysis.Raw.nTrials,1)*Analysis.Parameters.Wheel);
        Analysis.Filters.Pupillometry=logical(true(Analysis.Raw.nTrials,1)*Analysis.Parameters.Pupillometry);
    
    case 'PupBNC'
if Analysis.Parameters.Pupillometry
    F_States=fieldnames(Analysis.Raw.States{1,1});
    if contains(F_States{1},'ITI')
        Analysis.Parameters.PupilStartState=F_States{2};
    else
        Analysis.Parameters.PupilStartState=F_States{1};
    end
else
    Analysis.Parameters.PupilStartState='na';
end
    newmodif=Analysis.Parameters.PupilStartState
    otherwise
        disp('Unknown modification request')
end
end

