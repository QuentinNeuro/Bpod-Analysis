function Par=AB_Parameters_Photometry_v1(Par,SessionData)

DataField={'NidaqData' ; 'Nidaq2Data'};

Par.Photometry.Version=SessionData.TrialSettings(1).GUI.PhotometryVersion;
Par.Photometry.Channels={}; 
Par.Photometry.Photometry(Par.Behavior.nSessions)=0;
if any(isfield(SessionData,DataField))
    Par.Photometry.Photometry(Par.Behavior.nSessions)=1;
    Par.Data.RecordingType='Photometry';
%% SamplingRate
    Par.Photometry.SamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    Par.Photometry.Modulation=SessionData.TrialSettings(1).GUI.Modulation;

    if isfield(SessionData.TrialSettings(1).GUI,'modPhase')
        Par.Photometry.Phase=SessionData.TrialSettings(1).GUI.modPhase;
    else
        Par.Photometry.Phase=0;
    end
% Fiber1 - 470    
    Par.Photometry.Channels{1}='470';
    Par.Photometry.DataField{1}=DataField{1};
    Par.Photometry.AmpField{1}='LED1_Amp';
    Par.Photometry.FreqField{1}='LED1_Freq';
	Par.Photometry.Multiplex=1;
% Fiber1 - 405
if SessionData.TrialSettings(1).GUI.Isobestic405
    Par.Photometry.Channels{end+1}='405';
    Par.Photometry.DataField{end+1}=DataField{1};
    Par.Photometry.PhotoField{end+1}=Par.Photometry.DataField{1};
    Par.Photometry.AmpField{end+1}='LED2_Amp';
    Par.Photometry.FreqField{end+1}='LED2_Freq';
    Par.Photometry.Multiplex(end+1)=2;
end
% Fiber1 - 565
if SessionData.TrialSettings(1).GUI.RedChannel
    Par.Photometry.Channels{end+1}='565';
    Par.Photometry.DataField{end+1}=DataField{2};
    Par.Photometry.AmpField{end+1}='LED2_Amp';
    Par.Photometry.FreqField{end+1}='LED2_Freq';
    Par.Photometry.Multiplex(end+1)=1;
end
% Fiber 2 - 470
if SessionData.TrialSettings(1).GUI.DbleFibers
    Par.Photometry.Channels{end+1}='470b';
    Par.Photometry.DataField{end+1}=DataField{2};
    Par.Photometry.AmpField{end+1}='LED1b_Amp';
    Par.Photometry.FreqField{end+1}='LED1b_Freq';
    Par.Photometry.Multiplex(end+1)=1;
end
%% Data already demodulated from archiving script
if isfield(SessionData,'Archive') || isfield(SessionData,'DecimatedSampRate') % Already demodulated
    Par.Photometry.SamplingRate=SessionData.DecimatedSampRate;
    Par.Photometry.Archive=1;
else
    Par.Photometry.Archive=0;
end
end
end