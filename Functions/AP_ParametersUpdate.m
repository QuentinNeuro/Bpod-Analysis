function handles=AP_ParametersUpdate(handles,DefaultParam)

%% Plots
handles.PlotSummary1=DefaultParam.PlotSummary1;
handles.PlotSummary2=DefaultParam.PlotSummary2;
handles.PlotFiltersSingle=DefaultParam.PlotFiltersSingle;
handles.PlotFiltersSummary=DefaultParam.PlotFiltersSummary; 
handles.PlotFiltersBehavior=DefaultParam.PlotFiltersBehavior;
handles.Illustrator=DefaultParam.Illustrator;
handles.Transparency=DefaultParam.Transparency;
handles.TE4CellBase=DefaultParam.TrialEvents4CellBase;

handles.PlotEdges=DefaultParam.PlotX;
handles.NidaqRange=DefaultParam.PlotYNidaq;
end