function [Group_Plot,Group_Corr,Group_Test]=AP_Sensor_GroupToPlot(Analysis)
% GTP   : Group for general plotting purposing
% GTR  : Group for regression
% GTT   : Group for testing performance using A_Performance
%function designed by Quentin 2017
Group_Test={};
Group_Plot={};
indexp=0;
Group_Corr={};
indexc=0;

switch Analysis.Parameters.Phase
%%
    case 'L1-CuedReward' 
% Performance - should be 3 trial types, see AP_Sensor_Performance
Group_Test={'type_1','type_1','type_1','type_2'};
% Plot
        indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={'AnticipLick_Cued_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome'};...
                      'NoAnticipLick_Cued_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
% Arousal
if Analysis.Parameters.Wheel
    indexp=indexp+1;
Group_Plot{indexp,1}='Running';
Group_Plot{indexp,2}={  'Cue_A_Reward_Run',             {'Cue A','Reward','LicksOutcome','Run'};...
                        'Cue_A_Reward_noRun',         	{'Cue A','Reward','LicksOutcome','RunInv'};...
                        'Uncued_Reward',                {'Uncued','Reward'}};
end
if Analysis.Parameters.Pupillometry
    indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={  'Cue_A_Reward_CuePupil',        {'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                        'Cue_A_Reward_CuenoPupil',    	{'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'};...
                        'Uncued_Reward',              	{'Uncued','Reward'}};
end
% Correlations
        indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={'Cued_Reward',                    {'Cue A','Reward','LicksOutcome'};...
                      'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome'}};
%%                   
          case 'L2-RewardSize' 
% Performance
Group_Test={'type_1','type_1'};
% Plot
indexp=indexp+1;
Group_Plot{indexp,1}='RewardSize';
Group_Plot{indexp,2}={'Cued_Reward',               	{'type_1','LicksOutcome'};...
                    'BiggerReward',                	{'type_3','LicksOutcome'};...
                    'SmallerReward',              	{'type_2','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={'AnticipLick_Cued_Reward',   	{'type_1','LicksCue','LicksOutcome'};...
                    'NoAnticipLick_Cued_Reward', 	{'type_1','LicksCueInv','LicksOutcome'}};
% Correlations
        indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={'Cued_Reward',                {'type_1','LicksOutcome'};...
                    'BiggerReward',                 {'type_3','LicksOutcome'};...
                    'SmallerReward',                {'type_2','LicksOutcome'}};

%%
    case 'L3-SecondaryCue'
% Performance
Group_Test={};
% Plot
indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={'noAnticip_Licks',       	{'type_1','LicksCueInv','Licks2ndCueInv','LicksOutcome'};...
              'Cue1_Licks',                  	{'type_1','LicksCue','Licks2ndCueInv','LicksOutcome'};...
              'Cue2_Licks',                  	{'type_1','Licks2ndCue','LicksCueInv','LicksOutcome'};...
              'Cue12_Licks',                    {'type_1','LicksCue','Licks2ndCue','LicksOutcome'}};

%%     
    case 'V1-Probability'
% Performance
Group_Test={'type_1','type_1','type_1','type_2'};
% Plot
        indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={'CueA_Reward',            {'Cue A','Reward','LicksOutcome'};...
                      'CueB_Reward',            {'Cue B','Reward','LicksOutcome'}};
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                  {'Cue A'};...
                      'Cue_B',               	{'Cue B'}};            
% Arousal
if Analysis.Parameters.Wheel
    indexp=indexp+1;
Group_Plot{indexp,1}='Running';
Group_Plot{indexp,2}={'Cue_A_Reward_Run',   	{'Cue A','Reward','LicksOutcome','Run'};...
                      'Cue_A_Reward_noRun',   	{'Cue A','Reward','LicksOutcome','RunInv'}};
end
if Analysis.Parameters.Pupillometry
    indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={'Cue_A_Reward_CuePupil', 	{'Cue A','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                'Cue_A_Reward_CuenoPupil',     	{'Cue A','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};
end 
% Correlations
        indexc=indexc+1;
Group_Corr{indexc,1}='ExpectationCorrelation';
Group_Corr{indexc,2}={'CueA_Reward',            {'Cue A','Reward','LicksOutcome'};...
                      'CueB_Reward',         	{'Cue B','Reward','LicksOutcome'}};

    case 'V2-Extinction'
% Performance
Group_Test={'type_2','type_2','type_1','type_2'};
% Plot
        indexp=indexp+1;
Group_Plot{indexp,1}='RewardExpectation';
Group_Plot{indexp,2}={'AnticipLick_CueB_Reward', 	{'Cue B','LicksCue','Reward','LicksOutcome'};...
                      'NoAnticipLick_CueB_Reward', 	{'Cue B','LicksCueInv','Reward','LicksOutcome'}};    
indexp=indexp+1;
Group_Plot{indexp,1}='Cues';
Group_Plot{indexp,2}={'Cue_A',                      {'Cue A'};...
                      'Cue_B',                      {'Cue B'}}; 
% Arousal
if Analysis.Parameters.Wheel
    indexp=indexp+1;
Group_Plot{indexp,1}='Running';
Group_Plot{indexp,2}={'Cue_B_Reward_Run',         	{'Cue B','Reward','LicksOutcome','Run'};...
                      'Cue_B_Reward_noRun',        	{'Cue B','Reward','LicksOutcome','RunInv'}};
 end
if Analysis.Parameters.Pupillometry
    indexp=indexp+1;
Group_Plot{indexp,1}='CuePupil';
Group_Plot{indexp,2}={'Cue_B_Reward_CuePupil',    	{'Cue B','Reward','LicksOutcome','CuePupil','PupilNaN'};...
                       'Cue_B_Reward_CuenoPupil',   {'Cue B','Reward','LicksOutcome','CuePupilInv','PupilNaN'}};
end        
          
    case 'S-RewPun'
disp('S-RewPun not ready')
return       
end
end
