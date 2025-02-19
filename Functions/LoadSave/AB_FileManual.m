function [Analysis,DB_Stat,Feedback]=AB_FileManual(LP,DB,DB_Stat)
Feedback='';
[LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(LP.FileList)==0
	LP.FileToOpen=cellstr(LP.FileList);
    LP.Analysis_type='Single';
	Analysis=Analysis_Bpod(LP); 
else

switch LP.Analysis_type
    case 'Single'
         for i=1:length(LP.FileList)
%             TuningYMAX=[]; % for auditory tuning
            LP.FileToOpen=LP.FileList(i);
            try
            Analysis=Analysis_Bpod(LP);
            catch
            disp([LP.FileToOpen ' NOT ANALYZED']);
            end 
            close all;
            % DataBase
            if DB.DataBase
                DB_Stat=Database_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB.Group);
                DB_Stat.LP=LP;
                disp(Analysis.Parameters.CueTimeReset)
            end
            % if sum(Analysis.Filters.Tag_Early)>0
            %     try
            % Feedback.Session{i}=Analysis.Parameters.Files;
            % Feedback.DataTag{i}=Analysis.Tagging.AllCells.Data_Cell(Analysis.Filters.Tag_Early,:);
            % Feedback.DataUR{i}=Analysis.Uncued_Reward_Tag_Early.AllCells.Data_Cell;
            % % Feedback.DataCR{i}=Analysis.HVS_Reward_Tag_Early.AllCells.Data_Cell;
            % Feedback.DataCR{i}=Analysis.CS_Reward_Tag_Early.AllCells.Data_Cell;
            %     catch
            %         disp([LP.FileToOpen 'could not be added to spikes']);
            %     end
            % end
         end    

	case 'Group'
        LP.FileToOpen=LP.FileList;
        Analysis=Analysis_Bpod(LP);
        if DB.DataBase
            disp('Cannot add data to database in Group mode')
        end
end
end
end
