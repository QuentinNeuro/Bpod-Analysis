function [GroupPlot,GroupCorr,GroupTest]=AP_CuedOutcome_FilterGroups(Analysis)
% GroupPlot   : Group for general plotting purposing
% GroupCorr   : Group for regression
% GroupTest   : Group for testing performance using A_Performance
%function designed by Quentin 2017

arousal=0; % Function at the end - not working yet

GroupPlot={};
GroupCorr={};
indexp=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
GroupTest=AP_CuedOutcome_FilterGroups_Test(Analysis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
switch Analysis.Parameters.Phase
        case {'Habituation'}
indexp=indexp+1;
GroupPlot{indexp,1}='Reward';
GroupPlot{indexp,2}={   'Uncued_Reward'             {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'Uncued_Reward_NotColl'     {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Uncued_Omission',          {'Omission'}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
          case {'RewardA','Training','RewardA_woOmi','RewardA_Large','RewardB','RewardB_noUncued'} 
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp';
GroupPlot{indexp,2}={   'CS_Reward',                {'CS','Reward','LicksOutcome','FirstLick'};...
                        'NS',                       {'NS'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'};...
                        'CS_Omission',              {'CS','Omission'}};

GroupCorr{1,1}=GroupPlot{indexp,1};
GroupCorr{1,2}=GroupPlot{indexp,2};

if ~Analysis.Parameters.Illustration(1)
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp_Licks';
GroupPlot{indexp,2}={   'AnticipLick_CS_Reward',    {'CS','LicksCue','Reward','LicksOutcome','FirstLick'};...
                        'NoAnticipLick_CS_Reward',  {'CS','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={   'CS',                       {'CS'};...
                        'NS',                       {'NS'};...
                        'NoCue',                    {'Uncued'}};
indexp=indexp+1;
GroupPlot{indexp,1}='Cues_Licks';
GroupPlot{indexp,2}={   'AnticipLick_CS',      	    {'CS','LicksCue'};...
                        'NoAnticipLick_CS',         {'CS','LicksCueInv'};...
                        'AnticipLick_NS',           {'NS','LicksCue'};...
                        'NoAnticipLick_NS',         {'NS','LicksCueInv'}};
indexp=indexp+1;
GroupPlot{indexp,1}='Reward';
GroupPlot{indexp,2}={   'Uncued_Reward'             {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'Uncued_Reward_NotColl'     {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Uncued_Omission',          {'Omission'}};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           
    case {'PunishA','{PunishB'}
indexp=indexp+1;
GroupPlot{indexp,1}='PunExp';        
GroupPlot{indexp,2}={   'CS_Punish',                {'CS','Punish'};...
                        'CS_Omission',              {'CS','Omission'};...
                        'Uncued_Punish',            {'Uncued','Punish'}};
indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={   'CS',                       {'CS'};...
                        'NS',                       {'NS'};...
                        'NoCue',                    {'Uncued'}};  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                         
    case {'RewardAPunishBValues' , 'RewardBPunishAValues'}
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp_Licks';        
GroupPlot{indexp,2}={ 'HVS_Reward',                 {'HVS','Reward','LicksOutcome','FirstLick'};...
                      'LVS_Reward',                 {'LVS','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',              {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp_Licks';        
GroupPlot{indexp,2}={ 'AnticipLick_HVS_Reward',     {'HVS','LicksCue','Reward','LicksOutcome','FirstLick'};...
                      'NoAnticipLick_LVS_Reward',   {'LVS','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',              {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
GroupPlot{indexp,1}='PunExp';        
GroupPlot{indexp,2}={ 'HVS_Punish',                 {'HVS','Punish'};...
                      'LVS_Punish',                 {'LVS','Punish'};...
	                  'Uncued_Punish',              {'Uncued','Punish'}}; 
indexp=indexp+1;
GroupPlot{indexp,1}='PunExp_Licks';        
GroupPlot{indexp,2}={ 'AnticipLick_HVS_Punish',     {'HVS','LicksCue','Punish'};...
                      'NoAnticipLick_LVS_Punish',   {'LVS','LicksCueInv','Punish'};...
	                  'Uncued_Punish',              {'Uncued','Punish'}};                  
indexp=indexp+1;
GroupPlot{indexp,1}=' Cues';
GroupPlot{indexp,2}={ 'HVS',                        {'HVS'};...
                      'LVS',                        {'LVS'};...
                      'NoCue',                      {'Uncued'}};
indexp=indexp+1;
GroupPlot{indexp,1}='Cues_Licks';
GroupPlot{indexp,2}={'AnticipLick_HV',              {'HVS','LicksCue'};...
                    'NoAnticipLick_HV',             {'HVS','LicksCueInv'};...
                    'AnticipLick_LV',               {'LVS','LicksCue'};...
                    'NoAnticipLick_LV',             {'LVS','LicksCueInv'}};
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
    case {'RewardAPunishB','RewardBPunishA'}
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp';
GroupPlot{indexp,2}={'HVS_Reward',                  {'HVS','Reward','LicksOutcome'};...
                    'HVS_Omission',                 {'HVS','Omission'};...
                    'Uncued_Reward',                {'Uncued','Reward','LicksOutcome'}};
indexp=indexp+1;
GroupPlot{indexp,1}='PunExp';
GroupPlot{indexp,2}={'LVS_Punish',                  {'LVS','Punish'};...
                    'LVS_Omission',                 {'LVS','Omission'};...
                    'Uncued_Punish',                {'Uncued','Punish'}};  
indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={'HVS',                         {'HVS'};...
                    'LVS',                          {'LVS'};...
                    'NoCue',                        {'Uncued'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case {'RewardACBValues','RewardBACValues'}
indexp=indexp+1;
GroupPlot{indexp,1}='Rewards';
GroupPlot{indexp,2}={'HVS',                         {'HVS'};...
                     'MVS',                         {'MVS'};...
                     'LVS',                         {'LVS'}}; 
indexp=indexp+1;
GroupPlot{indexp,1}='Rewards';
GroupPlot{indexp,2}={'HVS_Reward',                  {'HVS','Reward','LicksOutcome'};...
                     'MVS_Reward',                  {'MVS','Reward','LicksOutcome'};...
                     'LVS_Reward',                  {'LVS','Reward','LicksOutcome'}};     

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
if arousal
GroupPlot=AP_CuedOutcome_FilterGroups_Arousal(GroupPlot,indexp,Analysis)
end

end
