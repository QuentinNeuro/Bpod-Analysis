function Analysis=A_FilterCNSMatch(Analysis)

    switch Analysis.Parameters.Phase
        case {'RewardA','Training','RewardA_woOmi','RewardA_Large','PunishA'}
            Analysis.Filters.CS=Analysis.Filters.Cue_A;
            Analysis.Filters.NS=Analysis.Filters.Cue_B;
        case {'RewardB','RewardB_noUncued','PunishB'}
            Analysis.Filters.CS=Analysis.Filters.Cue_B;
            Analysis.Filters.NS=Analysis.Filters.Cue_A;
        case {'RewardAPunishBValues','RewardAPunishB'}
            Analysis.Filters.HVS=Analysis.Filters.Cue_A;
            Analysis.Filters.LVS=Analysis.Filters.Cue_B;
        case {'RewardBPunishAValues','RewardBPunishA'}
            Analysis.Filters.HVS=Analysis.Filters.Cue_B;
            Analysis.Filters.LVS=Analysis.Filters.Cue_A;
        case {'RewardACBValues'}
            Analysis.Filters.HVS=Analysis.Filters.Cue_A;
            Analysis.Filters.MVS=Analysis.Filters.Cue_B;
            Analysis.Filters.LVS=Analysis.Filters.Cue_C;
        case {'RewardBACValues'}
            Analysis.Filters.HVS=Analysis.Filters.Cue_B;
            Analysis.Filters.MVS=Analysis.Filters.Cue_A;
            Analysis.Filters.LVS=Analysis.Filters.Cue_C;
        case {'Train3C','Test3C-RewardSize'} % Amy's task
            Analysis.Filters.HVS=Analysis.Filters.Cue_B;
            Analysis.Filters.LVS=Analysis.Filters.Cue_A;
            Analysis.Filters.NVS=Analysis.Filters.Cue_C;
    end