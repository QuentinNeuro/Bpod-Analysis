function handles=AP_Parameters_Photometry(handles,SessionData,DefaultParam)

%% 
% if isfield(SessionData.TrialSettings(1).GUI,'LED1_Name')
%     LEDNames={SessionData.TrialSettings(1).GUI.LED1_Name SessionData.TrialSettings(1).GUI.LED1b_Name SessionData.TrialSettings(1).GUI.LED2_Name};
% else
    LEDNames=DefaultParam.PhotoChNames;
% end
handles.Zscore=DefaultParam.Zscore;
%% Auto-Detection
if isfield(SessionData.TrialSettings(1).GUI,'PhotometryVersion')
    if SessionData.TrialSettings(1).GUI.Photometry
% General parameters        
    handles.SpikesAnalysis=0;
    handles.SpikesFigure=0;
    handles.Photometry=1;
    handles.Modulation=SessionData.TrialSettings(1).GUI.Modulation;
    if size(SessionData.(handles.PhotometryField){1,1},2)>1
        handles.recordedMod=1;
    else
        handles.recordedMod=0;
    end
% Fiber1 - 470    
    handles.PhotoCh={'470'};
    handles.PhotoChNames{1}=LEDNames{1};
    handles.PhotoField={handles.PhotometryField};
    handles.PhotoAmpField={'LED1_Amp'};
    handles.PhotoFreqField={'LED1_Freq'};
	handles.PhotoModulData=2;
% Fiber1 - 405
if SessionData.TrialSettings(1).GUI.Isobestic405
    handles.PhotoCh{length(handles.PhotoCh)+1}={'405'};
    handles.PhotoChNames{length(handles.PhotoChNames)+1}=LEDNames{2};
    handles.PhotoField{length(handles.PhotoField)+1}={handles.PhotometryField};
    handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED2_Amp'};
    handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED2_Freq'};
    handles.PhotoModulData=[handles.PhotoModulData 3];
end
% Fiber1 - 565
if SessionData.TrialSettings(1).GUI.RedChannel
    handles.PhotoCh{length(handles.PhotoCh)+1}={'565'};
    handles.PhotoChNames{length(handles.PhotoChNames)+1}=LEDNames{2};
    handles.PhotoField{length(handles.PhotoField)+1}={handles.Photometry2Field};
    handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED2_Amp'};
    handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED2_Freq'};
    handles.PhotoModulData=[handles.PhotoModulData 2];
end
% Fiber 2 - 470
if SessionData.TrialSettings(1).GUI.DbleFibers
    handles.PhotoCh{length(handles.PhotoCh)+1}={'470b'};
    handles.PhotoChNames{length(handles.PhotoChNames)+1}=LEDNames{3};
    handles.PhotoField{length(handles.PhotoField)+1}={handles.Photometry2Field};
    handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED1b_Amp'};
    handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED1b_Freq'};
    handles.PhotoModulData=[handles.PhotoModulData 2];
end
% No Photometry Data    
else
handles.Photometry=0;
handles.PhotoCh={};    
    end
    
%% Old version of bpod protocols    
else
if isfield(SessionData,handles.PhotometryField)
    handles.SpikesAnalysis=0;
    handles.SpikesFigure=0;
    handles.Photometry=1;
% First Channel
    handles.PhotoCh={'470'};
    handles.PhotoChNames{1}=LEDNames{1};
    handles.PhotoField={handles.PhotometryField};
    handles.PhotoAmpField={'LED1_Amp'};
    handles.PhotoFreqField={'LED1_Freq'};
	handles.Modulation=1;
	handles.recordedMod=1;
	handles.PhotoModulData=2;
% test if Laser/Lock-in Amplifier (old bpod/photometry)  
if isfield(SessionData.TrialSettings(1).GUI,'Photometry')==0   %% kinda test version of bpod protocol, if not laser/lockin
    handles.Modulation=0;
else
    if SessionData.TrialSettings(1).GUI.LED1_Amp==0
            handles.Modulation=0;
        else
            switch size(SessionData.NidaqData{1,1},2)
                case 1                                      %% LED commads not recorded
                    handles.recordedMod=0;
                case 2
                    if max(SessionData.(handles.PhotometryField){1,1}(:,2))<0.9*SessionData.TrialSettings(1).GUI.LED1_Amp
                            handles.Modulation=0;
                    end
            end
    end
end
% 405    
    if isfield(SessionData.TrialSettings(1).GUI,'LED2_Amp') % can be absent in some early version of Bpod parameters
        if SessionData.TrialSettings(1).GUI.LED2_Amp~=0
            handles.PhotoCh{length(handles.PhotoCh)+1}={'405'};
            handles.PhotoChNames{length(handles.PhotoChNames)+1}=LEDNames{2};
            handles.PhotoField{length(handles.PhotoField)+1}={handles.PhotometryField};
            handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED2_Amp'};
            handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED2_Freq'};
            handles.PhotoModulData=[handles.PhotoModulData 3];
            handles.Modulation=1;
            handles.recordedMod=1;
        end
    end
% Dual Fibers / PhotoDetet
    if isfield(SessionData,handles.Photometry2Field)
        handles.PhotoCh{length(handles.PhotoCh)+1}={'470b'};
        handles.PhotoChNames{length(handles.PhotoChNames)+1}=LEDNames{3};
        handles.PhotoField{length(handles.PhotoField)+1}={handles.Photometry2Field};
        handles.PhotoAmpField{length(handles.PhotoAmpField)+1}={'LED1b_Amp'};
        handles.PhotoFreqField{length(handles.PhotoFreqField)+1}={'LED1b_Freq'};
        handles.PhotoModulData=[handles.PhotoModulData 2];
        handles.Modulation=1;
        handles.recordedMod=1;
    end
else % No Photometry field
	handles.Photometry=0;
    handles.PhotoCh={};
end
end
end