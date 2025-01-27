function Par=AP_Parameters_Pupillometry(Par,Pup,SessionData)
%% Extract parameters from pupillometry file
    thisCheck=0;
    thisPupPar=[];
        if ~isempty(Pup)
            if Par.nTrials==Pup.Parameters.nTrials
                thisCheck=1;
                thisPupPar=Pup.Parameters;
            else
                disp('not the same number of trials analyzed for Bpod and for pupillometry');
            end
        end
%% Find trigger state for pupillometry
    thisPupSS=[];
    F_States=SessionData.RawData.OriginalStateNamesByNumber{1,1};
        if thisCheck
            switch Par.Behavior
                case 'CuedOutcome'
                    if contains(F_States{1},'ITI')
                    thisPupSS=F_States{2};
                    else
                    thisPupSS=F_States{1};
                    end
                otherwise
                thisPupSS=F_States{1};
            end 
            thisPupPar.StartState=thisPupSS;
        end
%% Save in Parameter structure
thisPupPar.Pupillometry=thisCheck;
Par.Pupillometry.Pupillometry=thisCheck;
if ~isfield(Par,'Pupillometry_Parameters')
    Par.Pupillometry.Parameters{1}=thisPupPar;
else
    Par.Pupillometry.Parameters{end+1}=thisPupPar;
end
% Defines default Pupillometry Status
if ~isfield(Par,'Pupillometry')
    Par.Pupillometry.Pupillometry=thisCheck;
else
    if ~Par.Pupillometry.Pupillometry
    Par.Pupillometry.Pupillometry=thisCheck;
    end
end
end
    