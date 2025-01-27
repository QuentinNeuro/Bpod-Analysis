function Par=AP_Parameters_Photometry(Par,SessionData)

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
% No Photometry Data    
else
Par.Photometry.Photometry=0;
Par.Photometry.Channels={};    
    end
else
    Par.Photometry.Photometry=0;
    Par.Photometry.Channels={};  
    disp('Old Bpod protocols not yet compatible with AnalysisLauncher version 2 and up');
    disp('check AP_Parameters_Photometry');
end

% end
% %% Old version of bpod protocols    
% else
% if isfield(SessionData,Par.PhotometryField)
%     Par.SpikesAnalysis=0;
%     Par.SpikesFigure=0;
%     Par.Photometry=1;
% % First Channel
%     Par.PhotoCh={'470'};
%     Par.PhotoChNames{1}=Labels{1};
%     Par.PhotoField={Par.PhotometryField};
%     Par.PhotoAmpField={'LED1_Amp'};
%     Par.PhotoFreqField={'LED1_Freq'};
% 	Par.Modulation=1;
% 	Par.recordedMod=1;
% 	Par.PhotoModulData=2;
% % test if Laser/Lock-in Amplifier (old bpod/photometry)  
% if isfield(SessionData.TrialSettings(1).GUI,'Photometry')==0   %% kinda test version of bpod protocol, if not laser/lockin
%     Par.Modulation=0;
% else
%     if SessionData.TrialSettings(1).GUI.LED1_Amp==0
%             Par.Modulation=0;
%         else
%             switch size(SessionData.NidaqData{1,1},2)
%                 case 1                                      %% LED commads not recorded
%                     Par.recordedMod=0;
%                 case 2
%                     if max(SessionData.(Par.PhotometryField){1,1}(:,2))<0.9*SessionData.TrialSettings(1).GUI.LED1_Amp
%                             Par.Modulation=0;
%                     end
%             end
%     end
% end
% % 405    
%     if isfield(SessionData.TrialSettings(1).GUI,'LED2_Amp') % can be absent in some early version of Bpod parameters
%         if SessionData.TrialSettings(1).GUI.LED2_Amp~=0
%             Par.PhotoCh{length(Par.PhotoCh)+1}={'405'};
%             Par.PhotoChNames{length(Par.PhotoChNames)+1}=Labels{2};
%             Par.PhotoField{length(Par.PhotoField)+1}={Par.PhotometryField};
%             Par.PhotoAmpField{length(Par.PhotoAmpField)+1}={'LED2_Amp'};
%             Par.PhotoFreqField{length(Par.PhotoFreqField)+1}={'LED2_Freq'};
%             Par.PhotoModulData=[Par.PhotoModulData 3];
%             Par.Modulation=1;
%             Par.recordedMod=1;
%         end
%     end
% % Dual Fibers / PhotoDetet
%     if isfield(SessionData,Par.Photometry2Field)
%         Par.PhotoCh{length(Par.PhotoCh)+1}={'470b'};
%         Par.PhotoChNames{length(Par.PhotoChNames)+1}=Labels{3};
%         Par.PhotoField{length(Par.PhotoField)+1}={Par.Photometry2Field};
%         Par.PhotoAmpField{length(Par.PhotoAmpField)+1}={'LED1b_Amp'};
%         Par.PhotoFreqField{length(Par.PhotoFreqField)+1}={'LED1b_Freq'};
%         Par.PhotoModulData=[Par.PhotoModulData 2];
%         Par.Modulation=1;
%         Par.recordedMod=1;
%     end
% else % No Photometry field
% 	Par.Photometry=0;
%     Par.PhotoCh={};
% end
% end
% end