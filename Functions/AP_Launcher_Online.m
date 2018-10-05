function LauncherParam=AP_Launcher_Online(LauncherParam,BpodSystem)
[thisPath,thisName,thisExt]=fileparts(BpodSystem.DataPath);
LauncherParam.FileList=[thisName thisExt];
LauncherParam.PathName=thisPath;
% ByDefault parameters    
LauncherParam.Analysis_type='Single';
LauncherParam.Save=0;
LauncherParam.Load=0;
% Figures - Can be changed upon loading
LauncherParam.PhotoChNames={'Fiber1' 'Color2' 'Fiber2'};%%{'470-BLA' 'none' '470-VS'};
LauncherParam.PlotSummary1=0;
LauncherParam.PlotSummary2=0;
LauncherParam.PlotFiltersSingle=0; %AP_Filter_GroupToPlot #1 Output
LauncherParam.PlotFiltersSummary=0;
LauncherParam.PlotFiltersBehavior=0; %AP_Filter_GroupToPlot #2 Ouput
LauncherParam.Illustrator=0;
LauncherParam.Transparency=1;
% Axis - Can be changed upon loading
LauncherParam.PlotYNidaq=[-2 5];
LauncherParam.PlotX=[-4 4];
end