function [Group_Plot,Group_Corr,Group_Test]=AP_CuedOutcome_GroupToPlot(Analysis)
% GTP   : Group for general plotting purposing
% GTR   : Group for regression
% GTT   : Group for testing performance using A_Performance
%function designed by Quentin 2017
Group_Test={};
Group_Plot={};
indexp=0;
Group_Corr={};
indexc=0;

illustrationTest=Analysis.Parameters.Illustration(1);

%% Groups
switch Analysis.Parameters.Phase
          case {'Habituation'}
indexp=indexp+1;
Group_Plot{indexp,1}='Reward';
Group_Plot{indexp,2}={  'Habit_Reward'      {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'NotColl'           {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Habit_Omission',   {'Omission'}};
% if Analysis.Parameters.Wheel
%     indexp=indexp+1;
% Group_Plot{indexp,1}='Running';
% Group_Plot{indexp,2}={'Habit_Reward_Run'          {'Uncued','Reward','LicksOutcome','FirstLick','Run'};...
%                       'Habit_Reward_noRun'          {'Uncued','Reward','LicksOutcome','FirstLick','RunInv'}};
% 
% end
          case {'RewardA','Training','RewardA_woOmi','RewardA_Large'} 
Group_Test={'type_1','type_1','type_1','type_3'};
if ~illustrationTest
indexp=indexp+1;

Group_Plot{indexp,1}='Reward';
Group_Plot{indexp,2}={  'Habit_Reward'      {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'NotColl'           {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Habit_Omission',   {'Uncued','Omission'}};

indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={  'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome','FirstLick'};...
                        'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                      {'Cue A'};...
                      'Cue_B',                      {'Cue B'};...
                      'NoCue',                      {'Uncued'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues_Licks';
Group_Plot{indexp,2}={  'AnticipLick_CueA',      	{'Cue A','LicksCue'};...
                        'NoAnticipLick_CueA',       {'Cue A','LicksCueInv'};...
                        'AnticipLick_CueB',         {'Cue B','LicksCue'};...
                        'NoAnticipLick_CueB',       {'Cue B','LicksCueInv'}};
end
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExp';
Group_Plot{indexp,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                        'CueB_Omission',            {'Cue B'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};
                    
% Arousal
% if Analysis.Parameters.Wheel
%     indexp=indexp+1;
%     
% Group_Plot{indexp,1}='Running';
% Group_Plot{indexp,2}={'Uncued_Reward_Run'          {'Uncued','Reward','LicksOutcome','FirstLick','Run'};...
%                       'Uncued_Reward_noRun'          {'Uncued','Reward','LicksOutcome','FirstLick','RunInv'}};

% Group_Plot{indexp,1}='Running';
% Group_Plot{indexp,2}={'Cue_A_Reward_Run',         {'Cue A','Reward','LicksOutcome','Run'};...
%                       'Cue_A_Reward_noRun',       {'Cue A','Reward','LicksOutcome','RunInv'};...
%                       'Uncued_Reward',            {'Uncued','Reward'}};
%                                   indexp=indexp+1;
% Group_Plot{indexp,1}='Running_AnticipLick';
% Group_Plot{indexp,2}={'AnticipLick_Cue_A_Reward_Run',         {'Cue A','Reward','LicksCue','LicksOutcome','Run'};...
%                       'AnticipLick_Cue_A_Reward_noRun',       {'Cue A','Reward','LicksCue','LicksOutcome','RunInv'};...
%                       'Uncued_Reward',            {'Uncued','Reward'}};
% end
% if Analysis.Parameters.Pupillometry
% indexp=indexp+1;
% Group_Plot{indexp,1}='CuePupil';
% Group_Plot{indexp,2}={'Cue_A_Reward_Pupil',      {'Cue A','Reward','LicksOutcome','Pupil','PupilNaN'};...
%                     'Cue_A_Reward_noPupil',       {'Cue A','Reward','LicksOutcome','PupilInv','PupilNaN'};...
%                     'Uncued_Reward',                 {'Uncued','Reward'}};
%                 indexp=indexp+1;
% Group_Plot{indexp,1}='CuePupil_AnticipLick';
% Group_Plot{indexp,2}={'AnticipLick_Cue_A_Reward_Pupil',      {'Cue A','Reward','LicksCue','LicksOutcome','Pupil','PupilNaN'};...
%                     'AnticipLick_Cue_A_Reward_noPupil',       {'Cue A','Reward','LicksCue','LicksOutcome','PupilInv','PupilNaN'};...
%                     'Uncued_Reward',                 {'Uncued','Reward'}};
% end              
% Correlation
% indexc=indexc+1;
% Group_Corr{indexc,1}='ExpectationCorrelation';
% Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
%                         'CueB_Omission',            {'Cue B'};...
%                         'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};      
%  
%%        
    case {'RewardB','RewardB_noUncued'}
Group_Test={'type_3','type_3','type_3','type_1'};

if ~illustrationTest
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Reward',      {'Cue B','LicksCue','Reward','LicksOutcome','FirstLick'};...
                    'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                    'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome','FirstLick'}};
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
end

indexp=indexp+1;
Group_Plot{indexp,1}='RewardExp2';
Group_Plot{indexp,2}={  'CueB_Reward',              {'Cue B','Reward','LicksOutcome'};...
                        'CueA_Omission',            {'Cue A'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Reward';
Group_Plot{indexp,2}={  'Habit_Reward'      {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'NotColl'           {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Habit_Omission',   {'Uncued','Omission'}};
% Arousal
% if Analysis.Parameters.Wheel
%     indexp=indexp+1;
% Group_Plot{indexp,1}='Running';
% Group_Plot{indexp,2}={'Cue_B_Reward_Run',           {'Cue B','Reward','LicksOutcome','Run'};...
%                       'Cue_B_Reward_noRun',         {'Cue B','Reward','LicksOutcome','RunInv'};...
%                       'Uncued_Reward',              {'Uncued','Reward'}};
% end
if Analysis.Parameters.Pupillometry
indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={'Cue_B_Reward_CuePupil',      {'Cue B','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                    'Cue_B_Reward_CuenoPupil',       {'Cue B','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
                    'Uncued_Reward',                 {'Uncued','Reward'}};
end    
% Correlation 
indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={  'CueB_Reward',              {'Cue B','Reward','LicksOutcome'};...
                        'CueA_Omission',            {'Cue A'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};      
        
   
%%  
    case 'RewardAPunishBValues'
Group_Test={'type_1','type_1','type_1','type_4'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';        
Group_Plot{indexp,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome','FirstLick'};...
                      'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'AnticipLick_CueA_Punish',        {'Cue A','LicksCue','Punish'};...
                      'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
	                  'Uncued_Punish',                  {'Uncued','Punish'}};
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';        
Group_Plot{indexp,2}={'CueA_Reward',      {'Cue A','Reward','LicksOutcome','FirstLick'};...
                      'CueB_Reward',      {'Cue B','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',    {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'CueA_Punish',        {'Cue A','Punish'};...
                      'CueB_Punish',        {'Cue B','Punish'};...
	                  'Uncued_Punish',      {'Uncued','Punish'}};  

indexp=indexp+1;
Group_Plot{indexp,1}='Omission';        
Group_Plot{indexp,2}={'CueA_Omission',        {'type_3'};...
                      'CueB_Omission',        {'type_6'};...
	                  'Uncued_Omission',      {'type_9'}};   
                  
                  
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'CueA',                          {'Cue A'};...
                      'CueB',                          {'Cue B'};...
                      'NoCue',                          {'Uncued'}};

indexp=indexp+1;
Group_Plot{indexp,1}='Cues_Licks';
Group_Plot{indexp,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
                    'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
                    'AnticipLick_CueB',               {'Cue B','LicksCue'};...
                    'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome','FirstLick'};...
                        'CueB_Reward',              {'Cue B','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};                   
%%                  
    case 'RewardBPunishAValues'
Group_Test={'type_4','type_4','type_4','type_1'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome','FirstLick'};...
                      'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome','FirstLick'}};

indexp=indexp+1;
Group_Plot{indexp,1}='Cues_Licks';
Group_Plot{indexp,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
                    'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
                    'AnticipLick_CueB',               {'Cue B','LicksCue'};...
                    'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};

indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'AnticipLick_CueB_Punish',        {'Cue B','LicksCue','Punish'};...
                      'NoAnticipLick_CueA_Punish',      {'Cue A','LicksCueInv','Punish'};...
	                  'Uncued_Punish',                  {'Uncued','Punish'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'CueA',                          {'Cue A'};...
                      'CueB',                          {'Cue B'};...
                      'NoCue',                          {'Uncued'}};
                  
indexp=indexp+1;
Group_Plot{indexp,1}='Omission';        
Group_Plot{indexp,2}={'CueA_Omission',        {'type_3'};...
                      'CueB_Omission',        {'type_6'};...
	                  'Uncued_Omission',      {'type_9'}};   

indexp=indexp+1;
Group_Plot{indexp,1}='OmissionExp';        
Group_Plot{indexp,2}={'CueA_Omission',        {'type_3'};...
                      'CueB_Omission',        {'type_6'};...
	                  'Uncued_Omission',      {'type_9'}};  

indexp=indexp+1;
Group_Plot{indexp,1}='RewExpNoLicks';        
Group_Plot{indexp,2}={'CueA_Reward',      {'Cue A','Reward','LicksOutcome','FirstLick'};...
                      'CueB_Reward',      {'Cue B','Reward','LicksOutcome','FirstLick'};...
                      'Uncued_Reward',    {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExpNoLicks';        
Group_Plot{indexp,2}={'CueA_Punish',        {'Cue A','Punish'};...
                      'CueB_Punish',        {'Cue B','Punish'};...
	                  'Uncued_Punish',      {'Uncued','Punish'}};  
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome','FirstLick'};...
                        'CueB_Reward',              {'Cue B','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};

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
Group_Plot{1,1}='RewardExpectation';
Group_Plot{1,2}={'CueA_Reward',        {'Cue A','Reward','LicksOutcome'};...
                'CueA_Omission',      {'Cue A','Omission'};...
                'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
Group_Plot{2,1}='PunExp';
Group_Plot{2,2}={'CueB_Punish',      {'Cue B','Punish'};...
          'CueB_Omission',    {'Cue B','Omission'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};  
Group_Plot{3,1}='Cues';
Group_Plot{3,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
Group_Corr{1,1}='Behavior';
Group_Corr{1,2}={'Cue_A_Reward_Pupil',                  {'Cue A','Reward','LicksOutcome','Pupil','PupilNaN'};...
           'Cue_A_Reward_noPupil',                {'Cue A','Reward','LicksOutcome','PupilInv','PupilNaN'};...
           'Uncued_Reward',                 {'Uncued','Reward'}};
       
    case 'RewardBPunishA'
Group_Test={'type_1','type_1','type_1','type_3'};
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';        
Group_Plot{indexp,2}={'CueB_Reward',        {'Cue B','Reward','LicksOutcome','FirstLick'};...
                      'CueB_Omission',      {'Cue B','Omission'};...
                      'Uncued_Reward',      {'Uncued','Reward','LicksOutcome','FirstLick'}};
indexp=indexp+1;
Group_Plot{indexp,1}='PunExp';        
Group_Plot{indexp,2}={'CueA_Punish',        {'Cue A','LicksCue','Punish'};...
                      'CueA_Omission',      {'Cue A','Omission'};...
	                  'Uncued_Punish',      {'Uncued','Punish'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                          {'Cue A'};...
                      'Cue_B',                          {'Cue B'};...
                      'NoCue',                          {'Uncued'}};
% Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome','FirstLick'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};
%%
    case {'RewardACBValues','RewardBACValues'}
indexp=indexp+1;
% Group_Plot{indexp,1}='Cues';
% Group_Plot{indexp,2}={'CueA',                    {'Cue A'};...
%           'CueB',                           {'Cue B'};...
%           'CueC',                           {'Cue C'}}; 
% indexp=indexp+1;
Group_Plot{indexp,1}='Rewards';
Group_Plot{indexp,2}={'CueA_Rew',                {'Cue A','Reward','LicksOutcome'};...
          'CueB_Rew',                       {'Cue B','Reward','LicksOutcome'};...
          'CueC_Rew',                       {'Cue C','Reward','LicksOutcome'}}; 
%       
      % Correlation
indexc=indexc+1;
Group_Corr{indexc,1}='BehaviorCorrelation';
Group_Corr{indexc,2}={'CueA_Rew',           {'Cue A','Reward','LicksOutcome'};...
          'CueB_Rew',                       {'Cue B','Reward','LicksOutcome'};...
          'CueC_Rew',                       {'Cue C','Reward','LicksOutcome'}}; 
      
% Arousal
% if Analysis.Parameters.Wheel
%     indexp=indexp+1;
% Group_Plot{indexp,1}='Running';
% Group_Plot{indexp,2}={'Cue_A_Reward_Run',         {'Cue A','Reward','LicksOutcome','Run'};...
%                       'Cue_A_Reward_noRun',       {'Cue A','Reward','LicksOutcome','RunInv'}};                                  
% end

% if Analysis.Parameters.Pupillometry
% indexp=indexp+1;
% Group_Plot{indexp,1}='CueAPupil';
% Group_Plot{indexp,2}={'Cue_A_Reward_Pupil',      {'Cue A','Reward','LicksOutcome','Pupil','PupilNaN'};...
%                     'Cue_A_Reward_noPupil',       {'Cue A','Reward','LicksOutcome','PupilInv','PupilNaN'}};
% %                 indexp=indexp+1;
% % Group_Plot{indexp,1}='CueCPupil';
% % Group_Plot{indexp,2}={'Cue_C_Reward_Pupil',      {'Cue C','Reward','LicksOutcome','Pupil','PupilNaN'};...
% %                     'Cue_C_Reward_noPupil',       {'Cue C','Reward','LicksOutcome','PupilInv','PupilNaN'}};
% end
      
      

end
end
