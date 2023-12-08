function GroupTest=AP_CuedOutcome_AC_FilterGroups_Test(Analysis)
GroupTest={};

switch Analysis.Parameters.Phase
    case {'Train3C'}
GroupTest={'type_2','type_2','type_1','type_2'};
    case {'Test3C-RewardSize'}
GroupTest={'type_4','type_4','type_1','type_4'};
end
