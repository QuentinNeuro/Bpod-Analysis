function GroupPlot=AP_CuedOutcome_AC_FilterGroups_Arousal(GroupPlot,indexp,Analysis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if Analysis.Parameters.Wheel
    switch Analysis.Parameters.Phase
        case {'Habituation'}
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Running';
                GroupPlot{indexp,2}={   'Uncued_Reward_Run'         {'Uncued_Reward','Run'};...
                                        'Uncued_Reward_noRun'       {'Uncued_Reward','RunInv'}};

        case {'RewardA','Training','RewardA_woOmi','RewardA_Large','RewardB','RewardB_noUncued'} 
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Running';
                GroupPlot{indexp,2}={   'Uncued_Reward_Run'         {'Uncued_Reward','Run'};...
                                        'Uncued_Reward_noRun'       {'Uncued_Reward','RunInv'}};
                indexp=indexp+1;
                GroupPlot{indexp,1}='CSNS_Running';
                GroupPlot{indexp,2}={   'CS_Reward_Run'             {'CS_Reward','Run'};...
                                        'CS_Reward_noRun'           {'CS_Reward','RunInv'};...
                                        'NS_Run'                    {'NS_Omission','Run'};...
                                        'NS_noRun'                  {'NS_Omission','RunInv'}};
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

        case {'RewardA','Training','RewardA_woOmi','RewardA_Large','RewardB','RewardB_noUncued'} 
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Pupil';
                GroupPlot{indexp,2}={   'Uncued_Reward_HPupil'      {'Uncued_Reward','Pupil','PupilNaN'};...
                                        'Uncued_Reward_LPupil'      {'Uncued_Reward','PupilInv','PupilNaN'}};
                indexp=indexp+1;
                GroupPlot{indexp,1}='CSNS_Pupil';
                GroupPlot{indexp,2}={   'CS_Reward_HPupil'          {'CS_Reward','Pupil','PupilNaN'};...
                                        'CS_Reward_LPupil'          {'CS_Reward','PupilInv','PupilNaN'};...
                                        'NS_HPupil'                 {'NS_Omission','Pupil','PupilNaN'};...
                                        'NS_LPupil'                 {'NS_Omission','PupilInv','PupilNaN'}};
    end
end