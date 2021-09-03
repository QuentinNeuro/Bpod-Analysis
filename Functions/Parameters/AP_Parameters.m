function Par=AP_Parameters(SessionData,Pup,LP,Name,Par)
% Function to extract the parameters used in the recording
% Uses : AP_Parameters_Behavior to detect the task being performed
%        AP_Parameters_Photometry to detect the parameters for the
%        photometry recordings
% Used by Analysis_Photometry

%% Nidaq Fields
Par.WheelField='NidaqWheelData';
Par.PhotometryField='NidaqData';
Par.Photometry2Field='Nidaq2Data';

%% Parameters from Launcher
FieldsLP_P=fieldnames(LP.P);
for thisField=1:size(FieldsLP_P,1)
    Par.(FieldsLP_P{thisField})=LP.P.(FieldsLP_P{thisField});
end

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
Par.StateToZero     =Par.(LP.P.StateToZero);
%% Licks
if isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port1In')
    Par.LickPort='Port1In';
elseif isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port2In')
    Par.LickPort='Port2In';
else
    Par.LickPort=LP.D.LickPort; %Default
end
% Par.LickEdges=LP.P.PlotX;
Par.Bin=0.25;

%% DAQ parameters and plotting
% Processing
if isfield(SessionData,'DecimatedSampRate')
    Par.NidaqSamplingRate=SessionData.DecimatedSampRate;
    Par.NidaqDecimatedSR=SessionData.DecimatedSampRate;
% 	if SessionData.DecimatedSampRate<Par.NidaqDecimatedSR
%         Par.NidaqDecimatedSR=SessionData.DecimatedSampRate;
%         disp('Archive SR is lower than requested SR - using archive SR by default')
%     end
else
    if isfield(SessionData.TrialSettings(1).GUI,'NidaqSamplingRate')
        Par.NidaqSamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    else
        Par.NidaqSamplingRate=LP.D.SamplingRate; % Default
    end
end
Par.NidaqDecimateFactor=ceil(Par.NidaqSamplingRate/Par.NidaqDecimatedSR);
%% Photometry
Par=AP_Parameters_Photometry(Par,SessionData,LP);
if isfield(SessionData,'DecimatedSampRate') % Already demodulated
	Par.Modulation=0;
end

%% Wheel 
Par.Wheel=0;
Par.WheelCounterNbits=32;
Par.WheelEncoderCPR=1024;
Par.WheelDiameter=14; %cm
if isfield(SessionData,Par.WheelField)
    Par.Wheel=1;
end
switch Par.Rig
    case 'Photometry5'
        Par.WheelPolarity=1;
    otherwise
        Par.WheelPolarity=-1;
end
%% Pupillometry
Par=AP_Parameters_Pupillometry(Par,Pup,SessionData);
%% Overwritting
FieldsLP_OW=fieldnames(LP.OW);
for thisField=1:size(FieldsLP_OW,1)
    if ~isempty(LP.OW.(FieldsLP_OW{thisField})) || ~isfield(Par,FieldsLP_OW{thisField})
    Par.(FieldsLP_OW{thisField})=LP.OW.(FieldsLP_OW{thisField});
    end
end
%
Par.NidaqBaselinePoints=Par.NidaqBaseline*Par.NidaqDecimatedSR;
if Par.NidaqBaselinePoints(1)==0
    Par.NidaqBaselinePoints(1)=1;
end
end  