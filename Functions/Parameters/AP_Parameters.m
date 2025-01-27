function Par=AP_Parameters(SessionData,Pup,LP,Name,Par)
% Function to extract the parameters used in the recording
% Uses : AP_Parameters_Behavior to detect the task being performed
%        AP_Parameters_Photometry to detect the parameters for the
%        photometry recordings
% Used by Analysis_Photometry

%% Parameters from Launcher
FieldsLP_P=fieldnames(LP.P);
for thisField=1:size(FieldsLP_P,1)
    Par.(FieldsLP_P{thisField})=LP.P.(FieldsLP_P{thisField});
end

Par.Photometry.NidaqField={'NidaqData' ; 'Nidaq2Data'};
Par.Wheel.NidaqField='NidaqWheelData';

%% General
% Animal Name
USindex=strfind(Name,'_');
if ~isempty(USindex)
    Par.Animal=Name(1:USindex(1)-1);
else
    Par.Animal=LP.D.Name; % Default
end
switch LP.Analysis_type
    case 'Group'
Par.Name=Par.Animal;
    otherwise
Par.Name=Name;
end
% Rig Name
try
    Par.Rig=SessionData.TrialSettings(1).Names.Rig;
catch
    Par.Rig=LP.D.Rig; %Default
end
% File
if ~isfield(Par,'Files')
    Par.Files{1}=Name;
else
    Par.Files{end+1}=Name;
end
%% Behavior specific : Plots, States and Timing
Par=AP_Parameters_Behavior(Par,SessionData,LP,Name);
Par.Timing.StateToZero     =Par.Behavior.(Par.Timing.StateToZero);
%% Licks
if isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port1In')
    Par.Licks.Port='Port1In';
% elseif isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port2In')
%     Par.LickPort='Port2In';
else
    Par.Licks.Port=LP.D.Licks.Port; %Default
end
Par.Licks.BinSize=0.25;
if isempty(Par.Timing.CueTimeLick)
    Par.Timing.CueTimeLick=Par.Timing.CueTimeReset;
end

%% DAQ parameters and plotting
% Processing
if isfield(SessionData,'DecimatedSampRate')
    Par.Data.NidaqSamplingRate=SessionData.DecimatedSampRate;
%     Par.NidaqDecimatedSR=SessionData.DecimatedSampRate;
	if SessionData.DecimatedSampRate<Par.Data.NidaqDecimatedSR
        Par.Data.NidaqDecimatedSR=SessionData.DecimatedSampRate;
        disp('Archive SR is lower than requested SR - using archive SR by default')
    end
else
    if isfield(SessionData.TrialSettings(1).GUI,'NidaqSamplingRate')
        Par.Data.NidaqSamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    else
        Par.Data.NidaqSamplingRate=LP.D.SamplingRate; % Default
    end
end
Par.Data.NidaqDecimateFactor=ceil(Par.Data.NidaqSamplingRate/Par.Data.NidaqDecimatedSR);

%% Photometry
Par=AP_Parameters_Photometry(Par,SessionData);
Par.nCells=0;
if isfield(SessionData,'DecimatedSampRate') % Already demodulated
	Par.Photometry.Modulation=0;
end

%% Wheel 
Par.Wheel.Wheel=0;
Par.Wheel.CounterNbits=32;
Par.Wheel.EncoderCPR=1024;
Par.Wheel.Diameter=14; %cm
if isfield(SessionData,Par.Wheel.NidaqField) || LP.P.Prime.Wheel
    Par.Wheel.Wheel=1;
end
switch Par.Rig
    case 'Photometry5'
        Par.Wheel.Polarity=1;
    otherwise
        Par.Wheel.Polarity=-1;
end

%% Stimulation
if isfield(SessionData.TrialSettings(1).GUI,'Optogenetic')
        Par.Stimulation=SessionData.TrialSettings(1).GUI.Optogenetic;
    else
        Par.Stimulation=LP.D.Stimulation; % Default
end

%% Pupillometry
Par=AP_Parameters_Pupillometry(Par,Pup,SessionData);

%% Overwritting
% FieldsLP_OW=fieldnames(LP.OW);
% for thisField=1:size(FieldsLP_OW,1)
%     if ~isempty(LP.OW.(FieldsLP_OW{thisField})) || ~isfield(Par,FieldsLP_OW{thisField})
%     Par.(FieldsLP_OW{thisField})=LP.OW.(FieldsLP_OW{thisField});
%     end
% end
%
Par.Data.NidaqBaselinePoints=Par.Data.NidaqBaseline*Par.Data.NidaqDecimatedSR;
if Par.Data.NidaqBaselinePoints(1)==0
    Par.Data.NidaqBaselinePoints(1)=1;
end
end  