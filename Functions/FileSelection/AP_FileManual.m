function [Analysis,DB_Stat]=AP_FileManual(LP,DB,DB_Stat)

[LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(LP.FileList)==0
	LP.FileToOpen=cellstr(LP.FileList);
    LP.Analysis_type='Single';
	Analysis=Analysis_Photometry(LP); 
else

switch LP.Analysis_type
    case 'Single'
         for i=1:length(LP.FileList)
%             TuningYMAX=[]; % for auditory tuning
            LP.FileToOpen=LP.FileList(i);
            try
            Analysis=Analysis_Photometry(LP);
            catch
            disp([LP.FileToOpen ' NOT ANALYZED']);
            end 
            close all;
            % DataBase
            if DB.DataBase
                DB_Stat=DB_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB.Group);
                DB_Stat.LP=LP;
                disp(Analysis.Parameters.CueTimeReset)
            end
%             AllAnimals{i}=Analysis.Parameters.Animal;
%             AllTuning{i}=TuningYMAX;
         end    

	case 'Group'
        LP.FileToOpen=LP.FileList;
        Analysis=Analysis_Photometry(LP);
        if DB.DataBase
            disp('Cannot add data to database in Group mode')
        end
end
end
end
