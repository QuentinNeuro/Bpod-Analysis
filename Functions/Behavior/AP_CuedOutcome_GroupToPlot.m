function [Group_Plot,Group_Corr,Group_Test]=AP_CuedOutcome_GroupToPlot(Analysis)
% GTP   : Group for general plotting purposing
% GTR  : Group for regression
% GTT   : Group for testing performance using A_Performance
%function designed by Quentin 2017
Group_Test={};
Group_Plot={};
indexp=0;
Group_Corr={};
indexc=0;


%% Adjust phase names
switch Analysis.Parameters.Phase
    case 'Training'
Analysis.Parameters.Phase='RewardA';
    case 'RewardA_woOmi'
Analysis.Parameters.Phase='RewardA';
end

%% Groups
switch Analysis.Parameters.Phase
          case 'RewardA'  %'RewardA' 'Training'     
Group_Test={'type_1','type_1','type_1','type_3'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewExp';
Group_Plot{indexp,2}={  'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
                        'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
                        'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};  
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                    {'Cue A'};...
                      'Cue_B',                      {'Cue B'};...
                      'NoCue',                      {'Uncued'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues_Licks';
Group_Plot{indexp,2}={  'AnticipLick_CueA',      	{'Cue A','LicksCue'};...
                        'NoAnticipLick_CueA',       {'Cue A','LicksCueInv'};...
                        'AnticipLick_CueB',         {'Cue B','LicksCue'};...
                        'NoAnticipLick_CueB',       {'Cue B','LicksCueInv'}};
% Arousal
if Analysis.Parameters.Wheel
    indexp=indexp+1;
Group_Plot{indexp,1}='Running';
Group_Plot{indep,2}={'Cue_A_Reward_Run',      	{'Cue A','Reward','LicksOutcome','Run'};...
                      'Cue_A_Reward_noRun',       {'Cue A','Reward','LicksOutcome','RunInv'};...
                      'Uncued_Reward',            {'Uncued','Reward'}};
end
if Analysis.Parameters.Pupillometry
indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={'Cue_A_Reward_CuePupil',      {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                    'Cue_A_Reward_CuenoPupil',       {'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
                    'Uncued_Reward',                 {'Uncued','Reward'}};
end              
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='RewExp';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                        'CueB_Omission',            {'Cue B'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};      
      
%%        
    case 'RewardB'
Group_Test={'type_3','type_3','type_3','type_1'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewExp';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
                    'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
                    'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                          {'Cue A'};...
                    'Cue_B',                          {'Cue B'};...
                    'NoCue',                          {'Uncued'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues_Licks';
Group_Plot{indexp,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
                    'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
                    'AnticipLick_CueB',               {'Cue B','LicksCue'};...
                    'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
% Arousal
if Analysis.Parameters.Wheel
    indexp=indexp+1;
Group_Plot{indexp,1}='Running';
Group_Plot{indexp,2}={'Cue_B_Reward_Run',           {'Cue B','Reward','LicksOutcome','Run'};...
                      'Cue_B_Reward_noRun',         {'Cue B','Reward','LicksOutcome','RunInv'};...
                      'Uncued_Reward',              {'Uncued','Reward'}};
end
if Analysis.Parameters.Pupillometry
indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={'Cue_B_Reward_CuePupil',      {'Cue B','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                    'Cue_B_Reward_CuenoPupil',       {'Cue B','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
                    'Uncued_Reward',                 {'Uncued','Reward'}};
end    
% Correlation 
indexc=indexc+1;
Group_Corr{indexc,1}='RewExp';
Group_Corr{indexc,2}={  'CueB_Reward',              {'Cue B','Reward','LicksOutcome'};...
                        'CueA_Omission',            {'Cue A'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};      
        
   
%%  
    case 'RewardAPunishBValues'
Group_Test={'type_1','type_1','type_1','type_4'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewExp';        
Group_Plot{indexp,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
                      'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'AnticipLick_CueA_Punish',        {'Cue A','LicksCue','Punish'};...
                      'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
	                  'Uncued_Punish',                  {'Uncued','Punish'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                          {'Cue A'};...
                      'Cue_B',                          {'Cue B'};...
                      'NoCue',                          {'Uncued'}};
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='RewExp';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                        'CueB_Reward',              {'Cue B','Reward','LicksOutcome'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};                   
%%                  
    case 'RewardBPunishAValues'
Group_Test={'type_4','type_4','type_4','type_1'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewExp';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
                      'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Punish',        {'Cue B','LicksCue','Punish'};...
                      'NoAnticipLick_CueA_Punish',      {'Cue A','LicksCueInv','Punish'};...
	                  'Uncued_Punish',                  {'Uncued','Punish'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                          {'Cue A'};...
                      'Cue_B',                          {'Cue B'};...
                      'NoCue',                          {'Uncued'}};
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='RewExp';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                        'CueB_Reward',              {'Cue B','Reward','LicksOutcome'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};

%%
    case 'PunishA'
Group_Plot{1,1}='PunExp';        
Group_Plot{1,2}={'CueA_Punish',                    {'Cue A','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
Group_Plot{2,1}='Cues';
Group_Plot{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};     
%%      
    case 'PunishB'
Group_Plot{1,1}='PunExp';        
Group_Plot{1,2}={'CueA_Punish',                    {'Cue B','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
Group_Plot{2,1}='Cues';
Group_Plot{2,2}={'Cue_A',                          {'Cue B'};...
          'Cue_B',                          {'Cue A'};...
          'NoCue',                          {'Uncued'}};     
%%           
    case 'RewardAPunishB'
Group_Plot{1,1}='RewExp';
Group_Plot{1,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
          'AnticipLick_CueA_Omission',      {'Cue A','LicksCue','Omission'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
Group_Plot{2,1}='PunExp';
Group_Plot{2,2}={'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
          'NoAnticipLick_CueB_Omission',    {'Cue B','LicksCueInv','Omission'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};  
Group_Plot{3,1}='Cues';
Group_Plot{3,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
Group_Corr{1,1}='Behavior';
Group_Corr{1,2}={'Cue_A_Reward_Pupil',                  {'Cue A','Reward','LicksOutcome','Pupil','PupilNaN'};...
           'Cue_A_Reward_noPupil',                {'Cue A','Reward','LicksOutcome','PupilInv','PupilNaN'};...
           'Uncued_Reward',                 {'Uncued','Reward'}};

%%
    case 'RewardACBValues'
Group_Plot{1,1}='Cues';
Group_Plot{1,2}={'CueA',                           {'Cue A'};...
          'CueB',                           {'Cue B'};...
          'CueC',                           {'Cue C'}}; 
Group_Plot{2,1}='Rewards';
Group_Plot{2,2}={'CueA_Rew',                       {'Cue A','Reward','LicksOutcome'};...
          'CueB_Rew',                       {'Cue B','Reward','LicksOutcome'};...
          'CueC_Rew',                       {'Cue C','Reward','LicksOutcome'}};        

end
end
