function AP_PlotData_Filter_corrDFF(Analysis,thistype,channelnb)

if nargin==2
    channelnb=1;
end
thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-PlotSingle %s',char(Analysis.Parameters.PhotoCh{channelnb}));

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(Analysis.(thistype).Name,'_',' '),Analysis.(thistype).nTrials);
labelx='Time (sec)';   
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);

maxtrial=Analysis.(thistype).nTrials;
yraster=1:Analysis.(thistype).nTrials;
PlotY_photo=Analysis.Parameters.PlotY_photo;
TempLgd={'TA','TB'};
%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
LgdFig=uicontrol('style','text');
set(LgdFig,'String',FigureLegend,'Position',[10,5,500,20]); 

%% row 1 DFF
% Time
subplot(4,5,2); hold on;
title(Title);
shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,'-k',0);
if isnan(PlotY_photo(channelnb,:))
    axis tight;
    PlotY_photo(channelnb,:)=get(gca,'YLim');
end
plot([0 0],PlotY_photo,'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[PlotY_photo(channelnb,2) PlotY_photo(channelnb,2)],'-b','LineWidth',2);
xlabel(labelx); ylabel('DF/Fo (%)');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(channelnb,:));

% Raster
subplot(4,5,1); hold on;
title('Raster');
imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yraster,Analysis.(thistype).(thisChStruct).DFF,PlotY_photo(channelnb,:));
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
xlabel(labelx); ylabel('DF/Fo (%)');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');

% Correlation
subplot(4,5,3); hold on;
title('Correlations');
x=Analysis.(thistype).(thisChStruct).OutcomeZ; y=Analysis.(thistype).(thisChStruct).CueZ;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DF/Fo (%)'); ylabel('Cue DF/Fo (%)');
axis tight

%% row 2 Licks 
% Raster
subplot(4,5,6); hold on;
plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
xlabel(labelx); ylabel('Licks');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
% Time
subplot(4,5,7); hold on;
shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',0); 
axis tight
thisYLimLicks=get(gca,'YLim');
plot([0 0],thisYLimLicks,'-r');
plot(Analysis.(thistype).Time.Cue(1,:)+Analysis.Parameters.CueTimeReset,[thisYLimLicks(2) thisYLimLicks(2)],'-b','LineWidth',2);
plot(Analysis.(thistype).Time.Outcome(1,:)+Analysis.Parameters.OutcomeTimeReset,[thisYLimLicks(2) thisYLimLicks(2)],'-b','LineWidth',2);
xlabel(labelx); ylabel('Lick rate (Hz)');
set(gca,'XLim',xTime,'XTick',xtickvalues);
% Correlations
subplot(4,5,8); hold on;
title('Outcome DFF vs Cue');
x=Analysis.(thistype).(thisChStruct).OutcomeZ;y=Analysis.(thistype).Licks.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DF/Fo (%)'); ylabel('Cue Licks (Hz)');
axis tight

subplot(4,5,9); hold on;
title('Cue DFF vs Cue');
x=Analysis.(thistype).(thisChStruct).CueZ;y=Analysis.(thistype).Licks.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Cue DF/Fo (%)'); ylabel('Cue Licks (Hz)');
axis tight

subplot(4,5,10); hold on;
title('Outcome DFF vs Outcome');
x=Analysis.(thistype).(thisChStruct).OutcomeZ;y=Analysis.(thistype).Licks.Outcome;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DF/Fo (%)'); ylabel('Outcome Licks (Hz)');
axis tight

%% row 3 Running
if Analysis.Parameters.Wheel
% Time
subplot(4,5,12); hold on;
shadedErrorBar(Analysis.(thistype).Wheel.Time(1,:),Analysis.(thistype).Wheel.DistanceAVG,Analysis.(thistype).Wheel.DistanceSEM,'-k',0);
axis tight;
thisYLimRun=get(gca,'YLim');
plot(Analysis.(thistype).Time.Cue(1,:)+Analysis.Parameters.CueTimeReset,[thisYLimRun(2) thisYLimRun(2)],'-b','LineWidth',2);
plot(Analysis.(thistype).Time.Outcome(1,:)+Analysis.Parameters.OutcomeTimeReset,[thisYLimRun(2) thisYLimRun(2)],'-b','LineWidth',2);
plot([0 0],thisYLimRun,'-r');
xlabel(labelx); ylabel('Run (cm)');
set(gca,'XLim',xTime,'XTick',xtickvalues);
      
% Raster
subplot(4,5,11); hold on;
imagesc(Analysis.(thistype).Wheel.Time(1,:),yraster,Analysis.(thistype).Wheel.Distance,thisYLimRun);
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
xlabel(labelx); ylabel('Run (cm)');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');

% Correlation
subplot(4,5,13); hold on;
x=Analysis.(thistype).(thisChStruct).OutcomeZ; y=Analysis.(thistype).Wheel.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DFF (%)'); ylabel('Cue Run (cm/sec)');
axis tight

subplot(4,5,14); hold on;
x=Analysis.(thistype).(thisChStruct).CueZ;y=Analysis.(thistype).Wheel.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Cue DFF (%)'); ylabel('Cue Run (cm/sec)');
axis tight

subplot(4,5,15); hold on;
x=Analysis.(thistype).(thisChStruct).OutcomeZ;y=Analysis.(thistype).Wheel.Outcome;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DFF (%)'); ylabel('Outcome Run (cm/sec)');
axis tight
end
%% row 4 Pupillometry
if Analysis.Parameters.Pupillometry
% Time
subplot(4,5,17); hold on;
shadedErrorBar(Analysis.(thistype).Pupil.Time(1,:),Analysis.(thistype).Pupil.PupilAVG,Analysis.(thistype).Pupil.PupilSEM,'-k',0);
axis tight;
thisYLimPup=get(gca,'YLim');
plot(Analysis.(thistype).Time.Cue(1,:)+Analysis.Parameters.CueTimeReset,[thisYLimPup(2) thisYLimPup(2)],'-b','LineWidth',2);
plot(Analysis.(thistype).Time.Outcome(1,:)+Analysis.Parameters.OutcomeTimeReset,[thisYLimPup(2) thisYLimPup(2)],'-b','LineWidth',2);
plot([0 0],thisYLimPup,'-r');
xlabel(labelx); ylabel('DP/Po)');
set(gca,'XLim',xTime,'XTick',xtickvalues);
% Raster
subplot(4,5,16); hold on;
imagesc(Analysis.(thistype).Pupil.Time(1,:),yraster,Analysis.(thistype).Pupil.PupilDPP,thisYLimPup);
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.005 pos(4)]);
xlabel(labelx);ylabel('DP/Po');
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
% Correlations
subplot(4,5,18); hold on;
x=Analysis.(thistype).(thisChStruct).OutcomeZ;y=Analysis.(thistype).Pupil.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DFF (%)'); ylabel('Cue Pupil (%)');
axis tight

subplot(4,5,19); hold on;
x=Analysis.(thistype).(thisChStruct).CueZ;y=Analysis.(thistype).Pupil.Cue;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Cue DFF (%)'); ylabel('Cue Pupil (%)');
axis tight

subplot(4,5,20); hold on;
model=fitlm(x,y);
plot(x,model.Fitted,'-r');
plot(x,y,'ok','markerSize',5);
thisleg{1}=sprintf('y=%.1f*x+%.1f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.2d',model.Rsquared.Ordinary,model.Coefficients.pValue(2));
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg,'FitBoxToText','on');
anno.Color='red'; legend('off');
xlabel('Outcome DFF (%)'); ylabel('Outcome Pupil (%)');
axis tight
end
end