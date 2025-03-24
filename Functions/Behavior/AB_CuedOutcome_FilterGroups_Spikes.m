function [GroupPlot]=AB_CuedOutcome_FilterGroups_Spikes(Analysis)

GroupPlot={};
indexp=0;

switch Analysis.Parameters.Behavior.Phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    case {'RewardA','RewardB'} 
indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={'CS','NS','NoCue'};

indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp';
GroupPlot{indexp,2}={'Uncued_Reward','CS_Reward','CS_Omission'};
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
    case {'RewardAPunishB','RewardBPunishA'}

indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={'HVS','LVS','NoCue'};

indexp=indexp+1;
GroupPlot{indexp,1}='RewPE';
GroupPlot{indexp,2}={'Uncued_Reward','HVS_Reward','HVS_Omission'};

indexp=indexp+1;
GroupPlot{indexp,1}='PunPE';
GroupPlot{indexp,2}={'Uncued_Punish','LVS_Punish','LVS_Omission'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    case {'RewardAPunishBValues','RewardBPunishAValues'}

indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={'HVS','LVS','NoCue'};

indexp=indexp+1;
GroupPlot{indexp,1}='RewPE';
GroupPlot{indexp,2}={'Uncued_Reward','HVS_Reward','LVS_Reward'};

indexp=indexp+1;
GroupPlot{indexp,1}='PunPE';
GroupPlot{indexp,2}={'Uncued_Punish','LVS_Punish','HVS_Punish'};

end
end