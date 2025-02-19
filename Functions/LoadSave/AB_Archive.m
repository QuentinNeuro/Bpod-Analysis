function AB_Archive(Analysis,SessionData,LP)
NidaqWheel=Analysis.Parameters.Wheel.NidaqField;
NidaqPhoto=Analysis.Parameters.Photometry.NidaqField;

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
try
    if isfield(SessionData,NidaqPhoto{1})
    for thisTrial=1:SessionData.nTrials
        SessionData.(NidaqPhoto{1}){1,thisTrial}=Analysis.Core.Photometry{1,thisTrial}{1, 1}';  
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.Data.SamplingRateDecimated;
    SessionData.Modulation=Analysis.Parameters.Photometry.Modulation;
    end
    if size(Analysis.Parameters.Photometry.Channels,2)>1
        switch Analysis.Parameters.Photometry.Channels{2}
            case '405'
        for thisTrial=1:SessionData.nTrials
            SessionData.(NidaqPhoto{1}){1,thisTrial}(:,2)=Analysis.Core.Photometry{1,thisTrial}{2,1}';  
        end 
        end
    end
        
    if isfield(SessionData,NidaqPhoto{2})
    for thisTrial=1:SessionData.nTrials
        SessionData.(NidaqPhoto{2}){1,thisTrial}=Analysis.Core.Photometry{1,thisTrial}{2, 1}';  
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.Data.SamplingRateDecimated;
    end
    if isfield(SessionData,NidaqWheel)
    for thisTrial=1:SessionData.nTrials
        SessionData.(NidaqWheel){1,thisTrial}=Analysis.Core.Wheel{1,thisTrial}';
    end
    SessionData.DecimatedSampRate=Analysis.Parameters.Data.SamplingRateDecimated;
    end
    
    save(DirFile,'SessionData');  
catch
    disp('Could not archive this SessionData')
end
end
end