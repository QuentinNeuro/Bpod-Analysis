function [Analysis,DB_Stat]=AB_FileManual(LP,DB,DB_Stat)

[LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
% try
if iscell(LP.FileList)==0
	LP.FileToOpen=cellstr(LP.FileList);
    LP.Analysis_type='Single';
	Analysis=Analysis_Bpod(LP); 
else

switch LP.Analysis_type
    case 'Single'
         for i=1:length(LP.FileList)
            LP.FileToOpen=LP.FileList(i);
            try
            Analysis=Analysis_Bpod(LP);
            catch
            disp([LP.FileToOpen ' NOT ANALYZED']);
            end 
            close all;
            % DataBase
            if DB.DataBase
                DB_Stat.LP=LP;
                switch Analysis.Parameters.Data.RecordingType
                    case 'Photometry'
                        switch Analysis.Parameters.Behavior.Behavior
                            case 'CuedOutcome'
                DB_Stat=Database_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB.Group);
                            case 'AuditoryTuning'
                DB_Stat=Database_Generate_AuditoryTuning(Analysis,DB_Stat,DB.Group);
                        end
                    case 'Spikes'
                DB_Stat=Database_Generate_Spikes(Analysis,DB_Stat);
                    case 'AOD'
                 DB_Stat=Database_Generate_AOD(Analysis,DB_Stat);
                end
                DB_Stat.LP=LP;
            end
         end    

	case 'Group'
        LP.FileToOpen=LP.FileList;
        Analysis=Analysis_Bpod(LP);
        if DB.DataBase
            disp('Cannot add data to database in Group mode')
        end
end
end
% catch
%     disp('Please select valid file')
%     Analysis=[];DB_Stat=[];
%     return
% end
end
