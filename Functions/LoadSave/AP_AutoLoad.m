function LP=AP_AutoLoad(LP)
% Helper function to decide the type of files being opened
% and the recording method used to acquire neuronal data;

%% Default Parameters
LP.Load=LP.D.Load;
LP.PRecordingType=LP.D.Data.RecordingType;
recTypes={'Spikes','AOD','Prime','Miniscope'};
testRecTypes=0;
%% load the first file
FileName=LP.FileToOpen{1,1};
cd(LP.PathName); load(FileName); 

%% Bpod recording file
if exist('SessionData','var')
    LP.Load=0;
    if isfield('SessionData','NidaqData')
        LP.P.Data.RecordingType='Photometry';
        testRecTypes=testRecTypes+1;
    end
    if ~isempty(ls('dff_*')) || ~isempty(ls('raw_*')) || ~isempty(ls('calcium_*'))
        LP.P.Data.RecordingType='AOD';
        testRecTypes=testRecTypes+1;
    end
    if ~isempty(ls('rec_extract*'))
        LP.P.Data.RecordingType='Miniscope';
        testRecTypes=testRecTypes+1;
    end
    if ~isempty(ls('TT_*'))
        LP.P.Data.RecordingType='Spikes';
        testRecTypes=testRecTypes+1;
    end
    if ~isempty(ls('*PMT_*')) % could also use SessionData.GUI.Prime;
        LP.P.Prime.Wheel=1;
        LP.P.Data.RecordingType='Prime';
        testRecTypes=testRecTypes+1;
    end
%% Analysis file
else
    if exist('Analysis','var')
    LP.Load=1;
    if isfield(Analysis.Parameters,'LauncherVer')
        LP.P.Data.RecordingType=Analysis.Parameters.Data.RecordingType;
    else
        
    % version control
    if isfield(Analysis.Parameters,'Photometry')
        if isstruct(Analysis.Parameters.Photometry)
            if Analysis.Parameters.Photometry.Photometry
                LP.P.Data.RecordingType='Photometry';
                testRecTypes=testRecTypes+1;
            end
        elseif Analysis.Parameters.Photometry
            LP.P.Data.RecordingType='Photometry';
            testRecTypes=testRecTypes+1;
        end
    end
    for rt=1:size(recTypes,2)
        if isfield(Analysis.Parameters,recTypes{rt})
            if Analysis.Parameters.(recTypes{rt}).(recTypes{rt})
                LP.P.Data.RecoringType=recTypes{rt};
                testRecTypes=testRecTypes+1;
            end
        end
    end
    end
    else
        error('Please load a Bpod file or an Analysis file');
    end
end

%% Test whether something went wrong
if testRecTypes>1
    disp('AutoLoad function has failed, will use default parameters')
    LP.P.Data.RecordingType=LP.D.Data.RecordingType;
end
end




