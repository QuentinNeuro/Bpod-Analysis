function handles=AP_Parameters_Update(handles,LauncherParam)

%% Plots
handles.PlotSummary1=LauncherParam.PlotSummary1;
handles.PlotSummary2=LauncherParam.PlotSummary2;
handles.PlotFiltersSingle=LauncherParam.PlotFiltersSingle;
handles.PlotFiltersSummary=LauncherParam.PlotFiltersSummary; 
handles.PlotFiltersBehavior=LauncherParam.PlotFiltersBehavior;
handles.Illustrator=LauncherParam.Illustrator;
handles.Transparency=LauncherParam.Transparency;
handles.TE4CellBase=LauncherParam.TrialEvents4CellBase;
handles.SpikesAnalysis=LauncherParam.SpikesAnalysis;
handles.SpikesFigure=LauncherParam.SpikesFigure;

handles.PlotEdges=LauncherParam.PlotX;
handles.NidaqRange=LauncherParam.PlotYNidaq;
end