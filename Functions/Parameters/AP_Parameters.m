function [handles,DefaultParam]=AP_Parameters(SessionData,Pup,DefaultParam,Name)
% Function to extract the parameters used in the recording
% Uses : AP_Parameters_Behavior to detect the task being performed
%        AP_Parameters_Photometry to detect the parameters for the
%        photometry recordings
% Used by Analysis_Photometry

%% Nidaq Fields
handles.WheelField='NidaqWheelData';
handles.PhotometryField='NidaqData';
handles.Photometry2Field='Nidaq2Data';

%% General
% Animal Name
USindex=strfind(Name,'_');
if isempty(USindex)==0
    handles.Animal=Name(1:USindex(1)-1);
else
    handles.Animal=DefaultParam.Name;
end
switch DefaultParam.Analysis_type
    case 'Group'
handles.Name=handles.Animal;
    otherwise
handles.Name=Name;
end
% Rig Name
try
    handles.Rig=SessionData.TrialSettings(1).Names.Rig;
catch
    handles.Rig=DefaultParam.Rig;
end
% Plots
handles.PlotSummary1=DefaultParam.PlotSummary1;
handles.PlotSummary2=DefaultParam.PlotSummary2;
handles.PlotFiltersSingle=DefaultParam.PlotFiltersSingle;
handles.PlotFiltersSummary=DefaultParam.PlotFiltersSummary; 
handles.PlotFiltersBehavior=DefaultParam.PlotFiltersBehavior;
handles.Illustrator=DefaultParam.Illustrator;
handles.Transparency=DefaultParam.Transparency;
handles.TE4CellBase=DefaultParam.TrialEvents4CellBase;
handles.SpikesAnalysis=DefaultParam.SpikesAnalysis;
handles.SpikesFigure=DefaultParam.SpikesFigure;

%% Behavior specific : Plots, States and Timing
handles=AP_Parameters_Behavior(handles,SessionData,DefaultParam,Name);
% Phase
try
    handles.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    handles.Phase=DefaultParam.Phase;
end
% Trial types and Names
handles.nTrials=SessionData.nTrials;
handles.nbOfTrialTypes=max(SessionData.TrialTypes);
if isfield(SessionData.TrialSettings(1),'TrialsNames')
    handles.TrialNames=SessionData.TrialSettings(1).TrialsNames;
else
if isfield(SessionData.TrialSettings(1),'TirlasNames')
    handles.TrialNames=SessionData.TrialSettings(1).TirlasNames;
else
    handles.TrialNames=DefaultParam.TrialNames;
end
end
%% Timing
handles.StateToZero     =handles.(DefaultParam.StateToZero);
handles.ZeroFirstLick   =DefaultParam.ZeroFirstLick;
handles.ReshapedTime=DefaultParam.ReshapedTime;
% Overwritting
if ~isempty(DefaultParam.CueTimeReset)
handles.CueTimeReset    =DefaultParam.CueTimeReset;
end
if ~isempty(DefaultParam.OutcomeTimeReset)
    handles.OutcomeTimeReset=DefaultParam.OutcomeTimeReset;
end
if ~isempty(DefaultParam.NidaqBaseline)
    handles.NidaqBaseline=DefaultParam.NidaqBaseline;
end

%% Licks
if isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port1In')
    handles.LickPort='Port1In';
elseif isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port2In')
    handles.LickPort='Port2In';
else
    handles.LickPort=DefaultParam.LickPort;
end
handles.LicksCue=DefaultParam.LicksCue;
handles.LicksOutcome=DefaultParam.LicksOutcome;
handles.LickEdges=DefaultParam.PlotX;
handles.Bin=0.25;

%% DAQ parameters and plotting
% Plots
handles.PlotX=DefaultParam.PlotX;
handles.PlotY_photo=DefaultParam.PlotY_photo;
% Processing
if isfield(SessionData.TrialSettings(1).GUI,'NidaqSamplingRate')
    handles.NidaqSamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
else
    handles.NidaqSamplingRate=DefaultParam.SamplingRate;
end
handles.NidaqDecimatedSR=DefaultParam.NewSamplingRate;
handles.NidaqDecimateFactor=handles.NidaqSamplingRate/handles.NidaqDecimatedSR;
switch DefaultParam.Analysis_type
    case 'Group'
handles.NidaqDuration=DefaultParam.NidaqDuration;
    otherwise
if isfield(SessionData.TrialSettings(1).GUI,'NidaqDuration')
	handles.NidaqDuration=SessionData.TrialSettings(1).GUI.NidaqDuration;
else
    handles.NidaqDuration=DefaultParam.NidaqDuration;
end
end
% Baseline Points
handles.NidaqBaselinePoints=handles.NidaqBaseline*handles.NidaqDecimatedSR;
if handles.NidaqBaselinePoints(1)==0
    handles.NidaqBaselinePoints(1)=1;
end
handles.ZeroAtZero=DefaultParam.ZeroAtZero;
%% Photometry
handles=AP_Parameters_Photometry(handles,SessionData,DefaultParam);
%% Wheel 
handles.Wheel=0;
handles.WheelCounterNbits=32;
handles.WheelEncoderCPR=1024;
handles.WheelThreshold=DefaultParam.WheelThreshold;
handles.WheelState=DefaultParam.WheelState;
handles.WheelDiameter=14; %cm
handles.WheelPolarity=-1;
if isfield(SessionData,handles.WheelField)
    handles.Wheel=1;
end
%% Pupillometry
handles.Pupillometry=0;
handles.PupilThreshold=DefaultParam.PupilThreshold;
handles.PupilState=DefaultParam.PupilState;
if ~isempty(Pup)
    if handles.nTrials==Pup.Parameters.nTrials
                handles.Pupillometry=1;
                handles.Pupillometry_Parameters=Pup.Parameters;    
    else
        disp('not the same number of trials analyzed for Bpod and for pupillometry');
        handles.Pupillometry=0;
    end
    handles.nTrials=SessionData.nTrials;
end
end  