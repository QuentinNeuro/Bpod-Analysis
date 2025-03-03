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
            if DB.DataBase==1
                DB_Stat=Database_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB.Group);
                DB_Stat.LP=LP;
                disp(Analysis.Parameters.CueTimeReset)
            elseif DB.DataBase==2
                try
                thisFilter=Analysis.Filters.(DB.Group);
                DB_Stat.Session{i}=Analysis.Parameters.Files;
                DB_Stat.DataTag{i}=Analysis.Tagging.AllCells.Data_Cell(thisFilter,:);
                DB_Stat.DataUR{i}=Analysis.Uncued_Reward.AllCells.Data_Cell(thisFilter,:);
                if isfield(Analysis,'AnticipLick_HVS_Reward')
                    DB_Stat.DataCR{i}=Analysis.AnticipLick_HVS_Reward.AllCells.Data_Cell(thisFilter,:);
                    DB_Stat.DataLVR{i}=Analysis.NoAnticipLick_LVS_Reward.AllCells.Data_Cell(thisFilter,:);
                    DB_Stat.DataHVS{i}=Analysis.AnticipLick_HV.AllCells.Data_Cell(thisFilter,:);
                    DB_Stat.DataLVS{i}=Analysis.NoAnticipLick_LV.AllCells.Data_Cell(thisFilter,:);
                elseif isfield('CS_Reward')
                    DB_Stat.DataCR=Analysis.CS_Reward.AllCells.Data_Cell(thisFilter,:);
                    DB_Stat.DataHVS{i}=Analysis.CS.AllCells.Data_Cell(thisFilter,:);
                    DB_Stat.DataLVS{i}=Analysis.NS.AllCells.Data_Cell(thisFilter,:);
                end
                catch
                    disp([LP.FileToOpen 'could not be added to spikes']);
                end
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
