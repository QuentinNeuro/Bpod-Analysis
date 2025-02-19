function AP_Save(Analysis,LauncherParam)
%% Directory
% Analysis.Parameters.Files=LauncherParam.FileToOpen;
DirAnalysis=[LauncherParam.PathName 'Analysis' filesep];
if isfolder(DirAnalysis)==0
    mkdir(DirAnalysis);
end
%% File name
FileName=Analysis.Parameters.Plot.Legend;
if LauncherParam.Save==1
    FileName=[FileName '_core'];
end
%% Save
DirFile=[DirAnalysis FileName '.mat'];
save(DirFile,'Analysis');
end