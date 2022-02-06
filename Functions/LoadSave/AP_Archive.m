function AP_Archive(Analysis,SessionData,LP)
WheelField=Analysis.Parameters.WheelField;
PhotoField=Analysis.Parameters.PhotometryField;
Photo2Field=Analysis.Parameters.Photometry2Field;

DirArchive=[cd filesep];
if ~LP.ArchiveOW
    DirArchive=[DirArchive 'Archive' filesep];
    if ~isfolder(DirArchive)
    mkdir(DirArchive);
    end
end
DirFile=[DirArchive Analysis.Parameters.Name '.mat'];

if isfield(SessionData,'DecimatedSampRate')
   disp('SessionData file already archived')
else
% try
    if isfield(SessionData,PhotoField)
    for thisTrial=1:SessionData.nTrials
        SessionData.(PhotoField){1,thisTrial}=Analysis.Core.Photometry{1,thisTrial}{1, 1};  
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.NidaqDecimatedSR;
    SessionData.Modulation=Analysis.Parameters.Modulation;
    end
    if size(Analysis.Parameters.PhotoCh,2)>1
        if Analysis.Parameters.PhotoCh{2}{:}(3)=='5'
        for thisTrial=1:SessionData.nTrials
            SessionData.(PhotoField){1,thisTrial}(:,2)=Analysis.Core.Photometry{1,thisTrial}{2, 1}(1:length(SessionData.(PhotoField){1,thisTrial}(:,1)));  
        end 
        end
    end
        
    if isfield(SessionData,Photo2Field)
    for thisTrial=1:SessionData.nTrials
        SessionData.(Photo2Field){1,thisTrial}=Analysis.Core.Photometry{1,thisTrial}{2, 1};  
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.NidaqDecimatedSR;
    end
    if isfield(SessionData,WheelField)
    for thisTrial=1:SessionData.nTrials
        SessionData.(WheelField){1,thisTrial}=Analysis.Core.Wheel{1,thisTrial};
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.NidaqDecimatedSR;
    end
    
    save(DirFile,'SessionData');  
% catch
%     disp('Could not archive this SessionData')
% end
end
end