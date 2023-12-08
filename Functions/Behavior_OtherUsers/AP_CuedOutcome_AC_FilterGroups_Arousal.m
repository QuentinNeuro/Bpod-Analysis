function GroupPlot=AP_CuedOutcome_AC_FilterGroups_Arousal(GroupPlot,indexp,Analysis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if Analysis.Parameters.Wheel
    switch Analysis.Parameters.Phase
        case {'Habituation'}
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Running';
                GroupPlot{indexp,2}={   'Uncued_Reward_Run'         {'Uncued_Reward','Run'};...
                                        'Uncued_Reward_noRun'       {'Uncued_Reward','RunInv'}};
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if Analysis.Parameters.Pupillometry
    switch Analysis.Parameters.Phase
        case {'Habituation'}
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Pupil';
                GroupPlot{indexp,2}={   'Uncued_Reward_HPupil'       {'Uncued_Reward','Pupil','PupilNaN'};...
                                        'Uncued_Reward_LPupil'       {'Uncued_Reward','PupilInv','PupilNaN'}};
    end
end