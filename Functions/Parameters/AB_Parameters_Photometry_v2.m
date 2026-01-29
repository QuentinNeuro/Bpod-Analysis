function Par=AB_Parameters_Photometry_v2(Par,SessionData)

% Initialize
Par.Photometry.Version=SessionData.TrialSettings(1).GUI.PhotometryVersion;
Par.Photometry.Photometry(Par.Behavior.nSessions)=0;

if isfield(SessionData,'Photometry')
    % this session has photometry
    Par.Photometry.Photometry(Par.Behavior.nSessions)=1;
    Par.Data.RecordingType='Photometry';

%% Save sessionData fields and settings
    Par.Photometry.settings=SessionData.Photometry.settings;
    Par.Photometry.output=SessionData.Photometry.output;
    Par.Photometry.input=SessionData.Photometry.input;

%% Populate analysis specific fields
    Par.Photometry.SamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    Par.Photometry.Modulation=SessionData.TrialSettings(1).GUI.Modulation;
%% Get the input/output and GUI mapping from sessionData file 
    Par.Photometry.DataField=SessionData.Photometry.input.list; % in Photometry.Data -> adjust in Core.
    Par.Photometry.OutputField=SessionData.Photometry.output.list; % in Photometry.Data -> adjust in Core.
    Par.Photometry.recordedMod=1;

    chCounter=1;
    for ch=Par.Photometry.OutputField
        chName=cell2mat(ch);
        Par.Photometry.AmpField{chCounter}=SessionData.Photometry.output.(chName).amplitude;
        Par.Photometry.FreqField{chCounter}=SessionData.Photometry.output.(chName).frequency;
        Par.Photometry.Phase=SessionData.TrialSettings(1).GUI.modPhase;
        chCounter=chCounter+1;
    end

%% Names the channels for analysis script
Par.Photometry.Channels{1}='470';
Par.Photometry.Multiplex(1)=1;

if SessionData.TrialSettings(1).GUI.Isobestic405
    Par.Photometry.Channels{end+1}='405';
    Par.Photometry.Multiplex(end+1)=2;
end
if and(SessionData.TrialSettings(1).GUI.RedChannel,SessionData.TrialSettings(1).GUI.DbleFibers)
    Par.Photometry.Channels{end+1}='565';
    Par.Photometry.Channels{end+1}='470b';
    Par.Photometry.Channels{end+1}='565b';
    Par.Photometry.Multiplex(end+1)=1;
    Par.Photometry.Multiplex(end+1)=1;
    Par.Photometry.Multiplex(end+1)=1;
else
if SessionData.TrialSettings(1).GUI.RedChannel
    Par.Photometry.Channels{end+1}='565';
    Par.Photometry.Multiplex(end+1)=1;
end
if SessionData.TrialSettings(1).GUI.DbleFibers
    Par.Photometry.Channels{end+1}='470b';
    Par.Photometry.Multiplex(end+1)=1;
end
end
%% Data already demodulated from archiving script
if isfield(SessionData,'Archive') || isfield(SessionData,'DecimatedSampRate') % Already demodulated
    Par.Photometry.SamplingRate=SessionData.DecimatedSampRate;
    Par.Photometry.Archive=1;
else
    Par.Photometry.Archive=0;
end

else
    Par.Photometry.Photometry(Par.Behavior.nSessions)=0;
end

end