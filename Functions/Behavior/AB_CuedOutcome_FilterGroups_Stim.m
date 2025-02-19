function GroupPlot=AP_CuedOutcome_FilterGroups_Stim(GroupPlot,indexp,Analysis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    switch Analysis.Parameters.Phase
        case {'Habituation'}
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Stim';
                GroupPlot{indexp,2}={   'Uncued_Reward_Stim'         {'Uncued_Reward','Stim'};...
                                        'Uncued_Reward_noStim'       {'Uncued_Reward','StimInv'}};
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Omission_Stim';
                GroupPlot{indexp,2}={   'Uncued_Omission_Stim'       {'Uncued_Omission','Stim'};...
                                        'Uncued_Omission_noStim'       {'Uncued_Omission','StimInv'}};


        case {'RewardA','Training','RewardA_woOmi','RewardA_Large','RewardB','RewardB_noUncued'} 
                indexp=indexp+1;
                GroupPlot{indexp,1}='Uncued_Reward_Stim';
                GroupPlot{indexp,2}={   'Uncued_Reward_Stim'         {'Uncued_Reward','Stim'};...
                                        'Uncued_Reward_noStim'       {'Uncued_Reward','StimInv'}};
                indexp=indexp+1;
                GroupPlot{indexp,1}='CSNS_Stim';
                GroupPlot{indexp,2}={   'CS_Reward_Stim'             {'CS_Reward','Stim'};...
                                        'CS_Reward_noStim'           {'CS_Reward','StimInv'};...
                                        'NS_Stim'                    {'NS_Omission','Stim'};...
                                        'NS_noStim'                  {'NS_Omission','StimInv'}};
    end
end