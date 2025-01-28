function Par=AP_Parameters_Photometry(Par,SessionData)
Par.Photometry.Photometry=0;
Par.Photometry.Channels={};   

%% Auto-Detection
if isfield(SessionData.TrialSettings(1).GUI,'PhotometryVersion')
    if SessionData.TrialSettings(1).GUI.Photometry
% General parameters        
    Par.Photometry.Photometry=1;
    Par.Photometry.Modulation=SessionData.TrialSettings(1).GUI.Modulation;
    if size(SessionData.(Par.Photometry.NidaqField{1}){1,1},2)>1
        Par.Photometry.recordedMod=1;
    else
        Par.Photometry.recordedMod=0;
    end
    if isfield(SessionData.TrialSettings(1).GUI,'modPhase')
        Par.Photometry.Phase=SessionData.TrialSettings(1).GUI.modPhase;
    else
        Par.Photometry.Phase=0;
    end
% Fiber1 - 470    
    Par.Photometry.Channels{1}='470';
    Par.Photometry.PhotoField{1}=Par.Photometry.NidaqField{1};
    Par.Photometry.AmpField{1}='LED1_Amp';
    Par.Photometry.FreqField{1}='LED1_Freq';
	Par.Photometry.ModulData=2;
% Fiber1 - 405
if SessionData.TrialSettings(1).GUI.Isobestic405
    Par.Photometry.Channels{end+1}='405';
    Par.Photometry.PhotoField{end+1}=Par.Photometry.NidaqField{1};
    Par.Photometry.AmpField{end+1}='LED2_Amp';
    Par.Photometry.FreqField{end+1}='LED2_Freq';
    Par.Photometry.ModulData(end+1)=3;
end
% Fiber1 - 565
if SessionData.TrialSettings(1).GUI.RedChannel
    Par.Photometry.Channels{end+1}='565';
    Par.Photometry.PhotoField{end+1}=Par.Photometry.NidaqField{2};
    Par.Photometry.AmpField{end+1}='LED2_Amp';
    Par.Photometry.FreqField{end+1}='LED2_Freq';
    Par.Photometry.ModulData(end+1)=2;
end
% Fiber 2 - 470
if SessionData.TrialSettings(1).GUI.DbleFibers
    Par.Photometry.Channels{end+1}='470b';
    Par.Photometry.PhotoField{end+1}=Par.Photometry.NidaqField{2};
    Par.Photometry.AmpField{end+1}='LED1b_Amp';
    Par.Photometry.FreqField{end+1}='LED1b_Freq';
    Par.Photometry.ModulData(end+1)=2;
end
%% Data already demodulated from archiving script
if isfield(SessionData,'DecimatedSampRate') % Already demodulated
	Par.Photometry.Modulation=0;
end
end
else
    disp('Old Bpod protocol detected, attempting to extract photometry parameters')
    Par=AP_Parameters_Photometry_VC(Par,SessionData);
end