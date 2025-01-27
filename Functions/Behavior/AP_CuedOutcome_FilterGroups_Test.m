function GroupTest=AP_CuedOutcome_FilterGroups_Test(Analysis)
GroupTest={};

switch Analysis.Parameters.Behavior.Phase
    case {'RewardA','Training','RewardA_woOmi','RewardA_Large'} 
GroupTest={'type_1','type_1','type_1','type_3'};

    case {'RewardB','RewardB_noUncued'}
GroupTest={'type_3','type_3','type_3','type_1'};

    case 'RewardAPunishBValues'
GroupTest={'type_1','type_1','type_1','type_4'};

    case 'RewardBPunishAValues'
GroupTest={'type_4','type_4','type_4','type_1'};
    case {'Train3C','Test3C-RewardSize'}
GroupTest={'type_2','type_2','type_1','type_2'};
end
