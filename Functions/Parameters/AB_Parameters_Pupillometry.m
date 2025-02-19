function Par=AB_Parameters_Pupillometry(Par,SessionData)

%% Session parameters
nSessions=Par.Behavior.nSessions;
thisPath=pwd;
thisFile=Par.Files{end};
[~,FileNameNoExt]=fileparts(fullfile(thisPath,thisFile));
Par.Pupillometry.Pupillometry(nSessions)=0;

%% Try to load pupil data and check for trial number consistency
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
    if Par.Behavior.nTrials(nSessions)==Pupillometry.Parameters.nTrials
        ParPup=Pupillometry.Parameters;
    else
        disp('Pupillometry : inconsistent trial number');
        return
    end
    else
    return
end

%% Find trigger state for pupillometry
BpodStates=SessionData.RawData.OriginalStateNamesByNumber{1,1};
switch Par.Behavior.Behavior
    case 'CuedOutcome'
        if contains(BpodStates{1},'ITI')
        triggerState=BpodStates{2};
        else
        triggerState=BpodStates{1};
        end
    otherwise
    triggerState=BpodStates{1};
end 

%% Save in Parameter structure
Par.Pupillometry.Pupillometry(nSessions)=1;
Par.Pupillometry.Files{nSessions}=[FileNameNoExt '_Pupil.mat'];
Par.Pupillometry.SamplingRate=ParPup.frameRate;
Par.Pupillometry.StartState=triggerState;
Par.Pupillometry.Parameters{nSessions}=ParPup;

end
    