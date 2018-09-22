function [GTP,GTPB]=AP_GoNogo_GroupToPlot(Analysis)
%
%
%function designed by Quentin 2017
GTP={};
GTPB={};
index=0;

index=index+1;
GTP{index,1}='CueAvsCueB_EasyTrials';
GTP{index,2}={'CueA_Go_Hit',                {'type_1','Go'};...
          'CueA_Go_Miss',                   {'type_1','Nogo'};...
          'CueB_Nogo_CorrectRej',           {'type_2','Nogo'};...
          'CueB_Nogo_FalseAlarm',           {'type_2','Go'}}; 
index=index+1;
GTP{index,1}='CueA_Run';
GTP{index,2}={'CueA_Go_Hit_Run',            {'type_1','Go','Run'};...
          'CueA_Go_Hit_NoRun',            	{'type_1','Go','RunInv'};...
          'CueA_Go_Miss_Run',               {'type_1','Nogo','Run'};...
          'CueA_Go_Miss_NoRun',             {'type_1','Nogo','RunInv'}};
index=index+1;
GTP{index,1}='CueB_Run';
GTP{index,2}={'CueB_Nogo_FalseAlarm_Run',      	{'type_2','Go','Run'};...
          'CueB_Nogo_FalseAlarm_NoRun',    	{'type_2','Go','RunInv'};...
          'CueB_Nogo_CorrectRej_Run',       {'type_2','Nogo','Run'};...
          'CueB_Nogo_CorrectRej_NoRun',     {'type_2','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueA_Pupil';
GTP{index,2}={'CueA_Go_Hit_Pupil',          {'type_1','Go','Pupil','PupilNaN'};...
          'CueA_Go_Hit_noPupil',            {'type_1','Go','PupilInv','PupilNaN'};...
          'CueA_Go_Miss_Pupil',             {'type_1','Nogo','Pupil','PupilNaN'};...
          'CueA_Go_Miss_NoPupil',           {'type_1','Nogo','PupilInv','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueB_Pupil';
GTP{index,2}={'CueB_Nogo_FalseAlarm_Pupil',      	{'type_2','Go','Pupil','PupilNaN'};...
          'CueB_Nogo_FalseAlarm_NoPupil',    	{'type_2','Go','PupilInv','PupilNaN'};...
          'CueB_Nogo_CorrectRej_Pupil',       {'type_2','Nogo','Pupil','PupilNaN'};...
          'CueB_Nogo_CorrectRej_NoPupil',     {'type_2','Nogo','PupilInv','PupilNaN'}};

if Analysis.Parameters.nbOfTrialTypes==4
          index=index+1;
GTP{index,1}='CueCvsCueD_HardTrials';
GTP{index,2}={'CueC_Go_Hit',                    {'type_3','Go'};...
            'CueC_Go_Miss',                   {'type_3','Nogo'};...
            'CueD_Nogo_CorrectRej',           {'type_4','Nogo'};...
            'CueD_Nogo_FalseAlarm',           {'type_4','Go'}}; 
      index=index+1;
GTP{index,1}='CueC_Run';
GTP{index,2}={'CueC_Go_Hit_Run',                {'type_3','Go','Run'};...
            'CueC_Go_Hit_NoRun',              {'type_3','Go','RunInv'};
            'CueC_Go_Miss_Run',               {'type_3','Nogo','Run'};...
            'CueC_Go_Miss_NoRun',             {'type_3','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueD_Run';
GTP{index,2}={'CueD_Nogo_FalseAlarm_Run',      	{'type_4','Go','Run'};...
          'CueD_Nogo_FalseAlarm_NoRun',    	{'type_4','Go','RunInv'};
          'CueD_Nogo_CorrectRej_Run',       {'type_4','Nogo','Run'};...
          'CueD_Nogo_CorrectRej_NoRun',     {'type_4','Nogo','RunInv'}};
      index=index+1;
GTP{index,1}='CueC_Pupil';
GTP{index,2}={'CueC_Go_Hit_Pupil',                {'type_3','Go','Pupil','PupilNaN'};...
          'CueC_Go_Hit_NoPupil',              {'type_3','Go','PupilInv','PupilNaN'};
          'CueC_Go_Miss_Pupil',               {'type_3','Nogo','Pupil','PupilNaN'};...
          'CueC_Go_Miss_NoPupil',             {'type_3','Nogo','PupilInv','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueD_Pupil';
GTP{index,2}={'CueD_Nogo_FalseAlarm_Pupil',       {'type_4','Go','Pupil','PupilNaN'};...
          'CueD_Nogo_FalseAlarm_NoPupil',     {'type_4','Go','PupilInv','PupilNaN'};
          'CueD_Nogo_CorrectRej_Pupil',       {'type_4','Nogo','Pupil','PupilNaN'};...
          'CueD_Nogo_CorrectRej_NoPupil',     {'type_4','Nogo','PupilInv','PupilNaN'}};
      
      index=index+1;
GTP{index,1}='CueAvsCueB_CleanPupil';
GTP{index,2}={'CueA_Go_Hit_OKPupil',         {'type_1','Go','PupilNaN'};...
          'CueA_Go_Miss_OKPupil',            {'type_1','Nogo','PupilNaN'};
          'CueB_Nogo_FalseAlarm_OKPupil',    {'type_2','Go','PupilNaN'};...
          'CueB_Nogo_CorrectRej_OKPupil',    {'type_2','Nogo','PupilNaN'}};
      index=index+1;
GTP{index,1}='CueCvsCueD_CleanPupil';
GTP{index,2}={'CueC_Go_Hit_OKPupil',         {'type_3','Go','PupilNaN'};...
          'CueC_Go_Miss_OKPupil',            {'type_3','Nogo','PupilNaN'};
          'CueD_Nogo_FalseAlarm_OKPupil',    {'type_4','Go','PupilNaN'};...
          'CueD_Nogo_CorrectRej_OKPupil',    {'type_4','Nogo','PupilNaN'}};    
end
end
end