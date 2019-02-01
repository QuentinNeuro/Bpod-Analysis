function [GTP,GTPB,GTT]=AP_Sensor_GroupToPlot(Analysis)
%
%
%function designed by Quentin 2018
GTP={};
GTPB={};
GTT={};
index=0;
indexb=0;

switch Analysis.Parameters.Phase
%%
    case 'L1-CuedReward' 
% Performance - should be 3 trial types, see AP_Sensor_Performance
GTT={'type_1','type_1','type_1','type_2'};
% Plot
        index=index+1;
GTP{index,1}='RewardExpectation';
GTP{index,2}={'AnticipLick_Cued_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
%               'NoAnticipLick_Cued_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
              'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
index=index+1;
GTP{index,1}='Cues';
GTP{index,2}={'Cue_A',                          {'Cue A'};...
              'NoCue',                          {'Uncued'}};
% Arousal
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_A_Reward_Run',               {'Cue A','Reward','LicksOutcome','Run'};...
           'Cue_A_Reward_noRun',                  {'Cue A','Reward','LicksOutcome','RunInv'};...
           'Uncued_Reward',                       {'Uncued','Reward'}};
end
if Analysis.Parameters.Pupillometry
    indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_A_Reward_CuePupil',                  {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
           'Cue_A_Reward_CuenoPupil',                {'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
           'Uncued_Reward',                          {'Uncued','Reward'}};
end

%%                   
          case 'L2-RewardSize' 
% Performance
GTT={'type_1','type_1'};
% Plot
index=index+1;
GTP{index,1}='RewardSize';
GTP{index,2}={'Cued_Reward',        {'type_1','LicksCue','LicksOutcome'};...
              'BiggerReward',       {'type_2','LicksCue','LicksOutcome'};...
              'SmallerReward',      {'type_3','LicksCue','LicksOutcome'}};
index=index+1;
GTP{index,1}='RewardExpectation';
GTP{index,2}={'AnticipLick_Cued_Reward',        {'type_1','LicksCue','LicksOutcome'};...
              'NoAnticipLick_Cued_Reward',      {'type_1','LicksCueInv','LicksOutcome'}};
% Arousal 
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_A_Reward_Run',               {'type_1','Reward','LicksOutcome','Run'};...
           'Cue_A_Reward_noRun',                  {'type_1','Reward','LicksOutcome','RunInv'}};...
end
if Analysis.Parameters.Pupillometry
    indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_A_Reward_CuePupil',                  {'type_1','Reward','LicksOutcome','CuePupil','PupilNaN'};...
           'Cue_A_Reward_CuenoPupil',                {'type_1','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};...
end

%%
    case 'L3-SecondaryCue'
% Performance
GTT={};
% Plot
index=index+1;
GTP{index,1}='RewardExpectation';
GTP{index,2}={'noAnticip_Licks',        {'type_1','LicksCueInv','Licks2ndCueInv','LicksOutcome'};...
              'Cue1_Licks',             {'type_1','LicksCue','Licks2ndCueInv','LicksOutcome'};...
              'Cue2_Licks',             {'type_1','Licks2ndCue','LicksCueInv','LicksOutcome'};...
              'Cue12_Licks',            {'type_1','LicksCue','Licks2ndCue','LicksOutcome'}};
% Arousal 
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_A_Reward_Run',               {'type_1','Reward','LicksOutcome','Run'};...
                'Cue_A_Reward_noRun',                  {'type_1','Reward','LicksOutcome','RunInv'}};...
end
if Analysis.Parameters.Pupillometry
    indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_A_Reward_CuePupil',                  {'type_1','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                'Cue_A_Reward_CuenoPupil',                {'type_1','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};...
end
%%     
    case 'V1-Probability'
% Performance
GTT={'type_1','type_1','type_1','type_2'};
% Plot
        index=index+1;
GTP{index,1}='RewardExpectation';
GTP{index,2}={'CueA_Reward',        {'Cue A','Reward','LicksOutcome'};...
              'CueB_Reward',        {'Cue B','Reward','LicksOutcome'}};
index=index+1;
GTP{index,1}='Cues';
GTP{index,2}={'Cue_A',                          {'Cue A'};...
              'Cue_B',                          {'Cue B'}};            
% Arousal
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_A_Reward_Run',                    {'Cue A','Reward','LicksOutcome','Run'};...
           'Cue_A_Reward_noRun',                  {'Cue A','Reward','LicksOutcome','RunInv'}};
end
if Analysis.Parameters.Pupillometry
    indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_A_Reward_CuePupil',                  {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
           'Cue_A_Reward_CuenoPupil',                {'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};
end           
    case 'V2-Extinction'
% Performance
GTT={'type_2','type_2','type_1','type_2'};
% Plot
        index=index+1;
GTP{index,1}='RewardExpectation';
GTP{index,2}={'AnticipLick_CueB_Reward',        {'Cue B','LicksCue','Reward','LicksOutcome'};...
              'NoAnticipLick_CueB_Reward',      {'Cue B','LicksCueInv','Reward','LicksOutcome'}};    
index=index+1;
GTP{index,1}='Cues';
GTP{index,2}={'Cue_A',                          {'Cue A'};...
              'Cue_B',                          {'Cue B'}}; 
% Arousal
if Analysis.Parameters.Wheel
    indexb=indexb+1;
GTPB{indexb,1}='Running';
GTPB{indexb,2}={'Cue_B_Reward_Run',                    {'Cue A','Reward','LicksOutcome','Run'};...
           'Cue_B_Reward_noRun',                  {'Cue A','Reward','LicksOutcome','RunInv'}};
 end
if Analysis.Parameters.Pupillometry
    indexb=indexb+1;
GTPB{indexb,1}='CuePupil';
GTPB{indexb,2}={'Cue_B_Reward_CuePupil',                  {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
           'Cue_B_Reward_CuenoPupil',                {'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};
end        
          
    case 'S-RewPun'
disp('S-RewPun not ready')
return       
end
end
