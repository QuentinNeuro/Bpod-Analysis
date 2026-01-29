function AB_Archive(Analysis,SessionData,LP)
%% Function to create a demodulated / decimated version of the DAQ-acquired data
% Work for photometry and wheel inputs

try
if isfield(SessionData,'DecimatedSampRate') || isfield(SessionData,'Archive')
       disp('SessionData file already archived')
else

%% Directory
DirArchive=[cd filesep];
if ~LP.ArchiveOW
    DirArchive=[DirArchive 'Archive' filesep];
    if ~isfolder(DirArchive)
    mkdir(DirArchive);
    end
end
DirFile=[DirArchive Analysis.Parameters.Name '.mat'];

%% Archiving
% Photometry
if Analysis.Parameters.Photometry.Photometry
    dataField_Photo=Analysis.Parameters.Photometry.DataField;
    multiplex=Analysis.Parameters.Photometry.Multiplex;
    % New DAQ script
    if Analysis.Parameters.Photometry.Version>=2
        for c=1:size(dataField_Photo,2)
            for t=1:SessionData.nTrials
                SessionData.Photometry.Data.(dataField_Photo{c}){multiplex(c),t}=Analysis.Core.Photometry{1,t}(c,:)';  
            end
        end
    else
        for c=1:size(dataField_Photo,2)
            for t=1:SessionData.nTrials
                SessionData.(dataField_Photo{c}){1,t}(:,multiplex(c))=Analysis.Core.Photometry{1,t}(c,:)';
            end
        end
    end
end
% Wheel
if Analysis.Parameters.Wheel.Wheel
    if Analysis.Parameters.Wheel.Version>=2
        for t=1:SessionData.nTrials
            SessionData.Wheel.Data{1,t}=Analysis.Core.Wheel{1,t}';
        end
    else
        dataField_Wheel=Analysis.Parameters.Wheel.DataField;
        for t=1:SessionData.nTrials
            SessionData.(dataField_Wheel){1,t}=Analysis.Core.Wheel{1,t}';
        end
    end
end
% Save
SessionData.Archive=1;
SessionData.DecimatedSampRate=Analysis.Parameters.Data.SamplingRateDecimated;

save(DirFile,'SessionData'); 
end

catch
disp('Could not archive this SessionData')
end