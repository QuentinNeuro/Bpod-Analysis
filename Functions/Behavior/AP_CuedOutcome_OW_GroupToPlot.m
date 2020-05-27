function [Group_Plot,Group_Corr,Group_Test]=AP_CuedOutcome_OW_GroupToPlot(Analysis)

Group_Test={};
Group_Plot={};
indexp=0;
Group_Corr={};
indexc=0;

indexp=indexp+1;
Group_Plot{indexp,1}='Reward';
Group_Plot{indexp,2}={  'RewardColl'        {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'RewardNotColl'     {'Uncued','Reward','LicksOutcomeInv'};...
                        'Habit_Omission',   {'Uncued','Omission'}};
              
% 
% 
% Group_Test={'type_1','type_1','type_1','type_3'};
% indexp=indexp+1;
% Group_Plot{indexp,1}='RewardExpectation';
% Group_Plot{indexp,2}={  'AnticipLick_CueA_Reward',        {'Cue A','LicksCue','Reward','LicksOutcome','FirstLick'};...
%                         'NoAnticipLick_CueA_Reward',      {'Cue A','LicksCueInv','Reward','LicksOutcome','FirstLick'};...
%                         'Uncued_Reward',                  {'Uncued','Reward','LicksOutcome','FirstLick'}};
%                     indexp=indexp+1;
% Group_Plot{indexp,1}='Cues';
% Group_Plot{indexp,2}={'Cue_A',                      {'Cue A'};...
%                       'Cue_B',                      {'Cue B'};...
%                       'NoCue',                      {'Uncued'}};


end