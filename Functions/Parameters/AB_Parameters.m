function Par=AB_Parameters(SessionData,LP,Name,Par)
% Function to extract the parameters used in the recording
% Uses : AP_Parameters_Behavior to detect the task being performed
%        AP_Parameters_Photometry to detect the parameters for the
%        photometry recordings
% Used by Analysis_Photometry


%% Parameters from Launcher
if ~isfield(Par,'Data')
P_F1=fieldnames(LP.P);
for f1=1:size(P_F1,1)
    if isstruct(LP.P.(P_F1{f1}))
        P_F2=fieldnames(LP.P.(P_F1{f1}));
        for f2=1:size(P_F2,1)
            Par.(P_F1{f1}).(P_F2{f2})=LP.P.(P_F1{f1}).(P_F2{f2});
        end
    else
    Par.(P_F1{f1})=LP.P.(P_F1{f1});
    end
end
end

%% Behavior
Par=AB_Parameters_Behavior(Par,SessionData,LP,Name);

%% Licks
if isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port1In')
    Par.Licks.Port='Port1In';
% elseif isfield(SessionData.RawEvents.Trial{1, 1}.Events,'Port2In')
%     Par.LickPort='Port2In';
else
    Par.Licks.Port=LP.D.Licks.Port; %Default
end
Par.Licks.BinSize=0.25;

%% Photometry
Par=AB_Parameters_Photometry(Par,SessionData);

%% Wheel 
Par=AB_Parameters_Wheel(Par,SessionData,LP);

%% Pupillometry
Par=AB_Parameters_Pupillometry(Par,SessionData);

%% Data
Par.Data.nCells=0;
Par.Data.Baseline=[0.2 1.2];
if ~any(Par.Photometry.Photometry)
    if isempty(Par.Data.Label)
        Par.Data.Label=[];
    else
        Par.Data.Label=Par.Data.Label{1};
    end
end

%% Stimulation
if isfield(SessionData.TrialSettings(1).GUI,'Optogenetic')
        Par.Stimulation.Stimulation=SessionData.TrialSettings(1).GUI.Optogenetic;
    else
        Par.Stimulation.Stimulation=0; % Default
end

%% Overwritting
OW_F1=fieldnames(LP.OW);
for f1=1:size(OW_F1,1)
    if isstruct(LP.P.(OW_F1{f1}))
        OW_F2=fieldnames(LP.OW.(OW_F1{f1}));
        for f2=1:size(OW_F2,1)
            if ~isempty(LP.OW.(OW_F1{f1}).(OW_F2{f2}))
            Par.(OW_F1{f1}).(OW_F2{f2})=LP.OW.(OW_F1{f1}).(OW_F2{f2});
            end
        end
    elseif ~isempty(LP.P.(OW_F1{f1}))
            Par.(OW_F1{f1})=LP.OW.(OW_F1{f1});
    end
end
end