function Par=AB_Parameters_Photometry_v0(Par,SessionData)

DataField={'NidaqData' ; 'Nidaq2Data'};
%% Run inside AP_Parameters_Photometry for data acquired using old Bpod protocol version
Par.Photometry.Version=0.1;
Par.Photometry.Channels={}; 
Par.Photometry.Photometry(Par.Behavior.nSessions)=0;
if any(isfield(SessionData,DataField))
    Par.Photometry.Photometry(Par.Behavior.nSessions)=1;
    Par.Data.RecordingType='Photometry';
%% SamplingRate
if isfield(SessionData,'DecimatedSampRate')
    Par.Photometry.SamplingRate=SessionData.DecimatedSampRate;
    Par.Photometry.Archive=1;
else
    Par.Photometry.Archive=0;
    if isfield(SessionData.TrialSettings(1).GUI,'NidaqSamplingRate')
        Par.Photometry.SamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    else
        Par.Photometry.SamplingRate=LP.D.Data.SamplingRate; % Default
    end
end

%% 
try
if isfield(SessionData,DataField{1})
    Par.Photometry.Phase=0;
    Par.Photometry.Modulation=1;
	Par.Photometry.recordedMod=1;
% Fiber1 - 470
    Par.Photometry.Channels{1}='470';
    Par.Photometry.DataField{1}=DataField{1};
    Par.Photometry.AmpField{1}='LED1_Amp';
    Par.Photometry.FreqField{1}='LED1_Freq';
	Par.Photometry.Multiplex=1;
% test if Laser/Lock-in Amplifier (old bpod/photometry)  
    if ~isfield(SessionData.TrialSettings(1).GUI,'Photometry')   %% kinda test version of bpod protocol, if not laser/lockin
        Par.Photometry.Modulation=0;
    else
        if SessionData.TrialSettings(1).GUI.LED1_Amp==0
            Par.Photometry.Modulation=0;
        else
            switch size(SessionData.NidaqData{1,1},2)
                case 1                                      %% LED commads not recorded
                    Par.Photometry.recordedMod=0;
                case 2
                    if max(SessionData.(DataField{1}){1,1}(:,2))<0.9*SessionData.TrialSettings(1).GUI.LED1_Amp
                            Par.Photometry.Modulation=0;
                    end
            end
        end
    end
% 405    
    if isfield(SessionData.TrialSettings(1).GUI,'LED2_Amp') % can be absent in some early version of Bpod parameters
        if SessionData.TrialSettings(1).GUI.LED2_Amp~=0
            Par.Photometry.Channels{end+1}='405';
            Par.Photometry.DataField{end+1}=DataField{1};
            Par.Photometry.AmpField{end+1}='LED2_Amp';
            Par.Photometry.FreqField{end+1}='LED2_Freq';
            Par.Photometry.Multiplex(end+1)=2;
            Par.Photometry.Modulation=1;
            Par.recordedMod=1;
        end
    end
% Dual Fibers / PhotoDetet
    if isfield(SessionData,DataField{2})
        Par.Photometry.Channels{end+1}='470b';
        Par.Photometry.DataField{end+1}=DataField{2};
        Par.Photometry.AmpField{end+1}='LED1b_Amp';
        Par.Photometry.FreqField{end+1}='LED1b_Freq';
        Par.Photometry.Multiplex(end+1)=1;
        Par.Modulation=1;
        Par.recordedMod=1;
    end
end
    disp('Photometry parameter extraction : success')
catch
    disp('Photometry parameter extraction : failed')
    Par.Data.RecordingType={};
end
end

%% Original code
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