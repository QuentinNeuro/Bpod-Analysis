function [GTP,GTPB]=AP_CuedOutcome_GroupToPlot(Analysis)
%
%
%function designed by Quentin 2017
GTT={};
GTS={};
GTP={};
GTP_Behav={};
index=0;
indexb=0;

indexb=indexb+1;
GTPB{indexb,1}='RewardTest';
GTPB{indexb,2}={'Cued_Reward',        {'type_1','LicksCue','LicksOutcome'}};


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
% index=index+1;
% GTP{index,1}='RewExp';
% GTP{index,2}={  'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
%                 'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
%                 'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
index=index+1;
GTP{index,1}='RewExp2';
GTP{index,2}={  'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                'CueB_Omission',            {'Cue B'};...
                'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};        
% index=index+1;
% GTP{index,1}='Cues';
% GTP{index,2}={'Cue_A',                    {'Cue A'};...
%             'Cue_B',                      {'Cue B'};...
%             'NoCue',                      {'Uncued'}};
%index=index+1;
% GTP{index,1}='Cues_Licks2';
% GTP{index,2}={'AnticipLick_CueA',      	{'Cue A','LicksCue'};...
%           'NoAnticipLick_CueA',       	{'Cue A','LicksCueInv'};...
%           'AnticipLick_CueB',             {'Cue B','LicksCue'};...
%           'NoAnticipLick_CueB',       	{'Cue B','LicksCueInv'}};
      
% Arousal
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_A_Reward_Run',      	{'Cue A','Reward','LicksOutcome','Run'};...
                'Cue_A_Reward_noRun',       {'Cue A','Reward','LicksOutcome','RunInv'};...
                'Uncued_Reward',            {'Uncued','Reward'}};
end
if Analysis.Parameters.Pupillometry
indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_A_Reward_CuePupil',    {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
           'Cue_A_Reward_CuenoPupil',       {'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
           'Uncued_Reward',                 {'Uncued','Reward'}};
end     
      
%        
    case 'RewardB'
GTP{1,1}='RewExp';        
GTP{1,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
          'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{3,1}='Cues_Licks';
GTP{3,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};  
GTPB{1,1}='Behavior';
GTPB{1,2}={'Cue_B_reward',                  {'Cue B','Reward','LicksOutcome'};...
           'Uncued_Reward',                 {'Uncued','LicksOutcome'};...
           'Cue_B_omission',                {'Cue B','Omission'}};
      
    case 'PunishA'
GTP{1,1}='PunExp';        
GTP{1,2}={'CueA_Punish',                    {'Cue A','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};     
      
    case 'PunishB'
GTP{1,1}='PunExp';        
GTP{1,2}={'CueA_Punish',                    {'Cue B','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
GTP{2,1}='Cues';
GTP{2,2}={'Cue_A',                          {'Cue B'};...
          'Cue_B',                          {'Cue A'};...
          'NoCue',                          {'Uncued'}};     
      
      
    case 'RewardAPunishB'
GTP{1,1}='RewExp';
GTP{1,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
          'AnticipLick_CueA_Omission',      {'Cue A','LicksCue','Omission'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='PunExp';
GTP{2,2}={'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
          'NoAnticipLick_CueB_Omission',    {'Cue B','LicksCueInv','Omission'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};  
GTP{3,1}='Cues';
GTP{3,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTPB{1,1}='Behavior';
GTPB{1,2}={'Cue_A_Reward_Pupil',                  {'Cue A','Reward','LicksOutcome','Pupil','PupilNaN'};...
           'Cue_A_Reward_noPupil',                {'Cue A','Reward','LicksOutcome','PupilInv','PupilNaN'};...
           'Uncued_Reward',                 {'Uncued','Reward'}};

    case 'RewardAPunishBValues'
GTP{1,1}='RewExp';        
GTP{1,2}={'CueA_Reward',        {'Cue A','Reward','LicksOutcome'};...
          'CueB_Reward',        {'Cue B','Reward','LicksOutcome'};...
          'Uncued_Reward',      {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='PunExp';        
GTP{2,2}={'CueA_Pun',        {'Cue A','Punish'};...
          'CueB_Pun',        {'Cue B','Punish'};...
          'Uncued_Pun',      {'Uncued','Punish'}};
% GTP{1,1}='RewExp';
% GTP{1,2}={'CueA_Reward',                    {'Cue A','Reward','LicksOutcome'};...
%           'CueB_Reward',                    {'Cue B','Reward','LicksOutcome'};...
%           'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
% GTP{2,1}='RewExp2';
% GTP{2,2}={'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
%           'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'};...
%           'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
% GTP{3,1}='PunExp';
% GTP{3,2}={'AnticipLick_CueA_Punish',        {'Cue A','LicksCue','Punish'};...
%           'NoAnticipLick_CueB_Punish',      {'Cue B','LicksCueInv','Punish'};...
%           'Uncued_Punish',                  {'Uncued','Punish'}};  
% GTP{4,1}='Cues';
% GTP{4,2}={'Cue_A',                          {'Cue A'};...
%           'Cue_B',                          {'Cue B'};...
%           'NoCue',                          {'Uncued'}};
% GTP{5,1}='Cues_Licks';
% GTP{5,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
%           'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
%           'AnticipLick_CueB',               {'Cue B','LicksCue'};...
%           'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};
% GTPB{1,1}='Behavior_Reward';
% GTPB{1,2}=GTP{1,2};
  
    case 'RewardBPunishAValues'
% GTP{1,1}='RewExp';        
% GTP{1,2}={'CueA_Reward',        {'Cue A','Reward','LicksOutcome'};...
%           'CueB_Reward',        {'Cue B','Reward','LicksOutcome'};...
%           'Uncued_Reward',      {'Uncued','Reward','LicksOutcome'}};
% GTP{2,1}='PunExp';        
% GTP{2,2}={'CueA_Pun',        {'Cue A','Punish'};...
%           'CueB_Pun',        {'Cue B','Punish'};...
%           'Uncued_Pun',      {'Uncued','Punish'}};
GTP{1,1}='RewExp';
GTP{1,2}={'CueA_Reward',                    {'Cue A','Reward','LicksOutcome'};...
          'CueB_Reward',                    {'Cue B','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{2,1}='RewExp2';
GTP{2,2}={'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
          'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
          'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
GTP{3,1}='PunExp';
GTP{3,2}={'NoAnticipLick_CueA_Punish',      {'Cue A','LicksCueInv','Punish'};... 
          'AnticipLick_CueB_Punish',        {'Cue B','LicksCue','Punish'};...
          'Uncued_Punish',                  {'Uncued','Punish'}};
GTP{4,1}='Cues';
GTP{4,2}={'Cue_A',                          {'Cue A'};...
          'Cue_B',                          {'Cue B'};...
          'NoCue',                          {'Uncued'}};
GTP{5,1}='Cues_Licks';
GTP{5,2}={'AnticipLick_CueA',               {'Cue A','LicksCue'};...
          'NoAnticipLick_CueA',             {'Cue A','LicksCueInv'};...
          'AnticipLick_CueB',               {'Cue B','LicksCue'};...
          'NoAnticipLick_CueB',             {'Cue B','LicksCueInv'}};  
GTPB{1,1}='Behavior_Reward';
GTPB{1,2}=GTP{1,2};

%%
    case 'RewardACBValues'
GTP{1,1}='Cues';
GTP{1,2}={'CueA',                           {'Cue A'};...
          'CueB',                           {'Cue B'};...
          'CueC',                           {'Cue C'}}; 
GTP{2,1}='Rewards';
GTP{2,2}={'CueA_Rew',                       {'Cue A','Reward','LicksOutcome'};...
          'CueB_Rew',                       {'Cue B','Reward','LicksOutcome'};...
          'CueC_Rew',                       {'Cue C','Reward','LicksOutcome'}};        

end
end
