function [GroupPlot,GroupCorr,GroupTest]=AB_CuedOutcome_FilterGroups(Analysis)
% GroupPlot   : Group for general plotting purposing
% GroupCorr   : Group for regression
% GroupTest   : Group for testing performance using A_Performance
%function designed by Quentin 2017

GroupPlot={};
GroupCorr={};
indexp=0;
if length(Analysis.Parameters.Plot.Illustration)==2
    Analysis.Parameters.Plot.Illustration(3)=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
GroupTest=AB_CuedOutcome_FilterGroups_Test(Analysis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
switch Analysis.Parameters.Behavior.Phase
    case {'Habituation'}
indexp=indexp+1;
GroupPlot{indexp,1}='Reward';
GroupPlot{indexp,2}={   'Uncued_Reward'             {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'Uncued_Reward_NotColl'     {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Uncued_Omission',          {'Omission'}};
GroupCorr{1,1}='Reward_Correlation';
GroupCorr{1,2}={        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'};....
                        'Uncued_Omission',          {'Omission'}};

    case {'Habituation-Water'}
indexp=indexp+1;
GroupPlot{indexp,1}='Reward';
GroupPlot{indexp,2}={   'Uncued_Reward'             {'Reward','LicksOutcome','FirstLick'};... 
                        'Uncued_Reward_NotColl'     {'Reward','LicksOutcomeInv','FirstLick'};...
                        'Uncued_Omission',          {'Omission'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
          case {'RewardA','Training','RewardA_woOmi','RewardA_Large','RewardB','RewardB_noUncued',} 
indexp=indexp+1;
GroupPlot{indexp,1}='RewardExp';
GroupPlot{indexp,2}={   'CS_Reward',                {'CS','Reward','LicksOutcome','FirstLick'};...
                        'NS',                       {'NS'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'};...
                        'CS_Omission',              {'CS','Omission'}};

if ~Analysis.Parameters.Plot.Illustration(1)
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
                        'Uncued_Omission',          {'Uncued','Omission'}};
end

GroupCorr{1,1}='RewardExp_Correlation';
GroupCorr{1,2}={        'CS_Reward',                {'CS','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};

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
    case {'RewardACBValues','RewardBACValues','Uncertainty'}
indexp=indexp+1;
GroupPlot{indexp,1}='Cues';
GroupPlot{indexp,2}={'HVS',                         {'HVS'};...
                     'MVS',                         {'MVS'};...
                     'LVS',                         {'LVS'}}; 
indexp=indexp+1;
GroupPlot{indexp,1}='Rewards';
GroupPlot{indexp,2}={'HVS_Reward',                  {'HVS','Reward','LicksOutcome'};...
                     'MVS_Reward',                  {'MVS','Reward','LicksOutcome'};...
                     'LVS_Reward',                  {'LVS','Reward','LicksOutcome'}};     

GroupCorr{1,1}='RewardExp_Correlation';
GroupCorr{1,2}={        'HVS_Reward',                {'HVS','Reward'};...
                        'MVS_Omission',              {'MVS','Omission'}};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
case {'Train3C'}
    indexp=indexp+1;
GroupPlot{indexp,1}='RewardExpectation';
GroupPlot{indexp,2}={'HighValue',                   {'HVS','Reward','LicksOutcome'};...
                     'LowValue',                    {'LVS','Reward','LicksOutcome'}}; 
case {'Test3C-RewardSize'}
    indexp=indexp+1;
GroupPlot{indexp,1}='LowValueError';
GroupPlot{indexp,2}={'LV_Predicted',           	{'type_1','LicksOutcome'};...
                     'LV_Bigger',               {'type_2','LicksOutcome'};...
                     'LV_Omitted',              {'type_3'}};
    indexp=indexp+1;
GroupPlot{indexp,1}='HighValueError';
GroupPlot{indexp,2}={'HV_Predicted',           	{'type_4','LicksOutcome'};...
                     'HV_Smaller',              {'type_5','LicksOutcome'};...
                     'HV_Omitted',              {'type_6'}};
    indexp=indexp+1;
GroupPlot{indexp,1}='NoValueError';
GroupPlot{indexp,2}={'NV_Predicted',           	{'type_7','LicksOutcome'};...
                     'NV_Bigger',               {'type_8','LicksOutcome'}};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

if Analysis.Parameters.Plot.Illustration(3)
GroupPlot=AB_CuedOutcome_FilterGroups_Arousal(GroupPlot,indexp,Analysis);
end
if Analysis.Parameters.Stimulation.Stimulation
GroupPlot=AB_CuedOutcome_FilterGroups_Stim(GroupPlot,indexp,Analysis);
end


end
