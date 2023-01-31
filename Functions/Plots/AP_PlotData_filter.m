function Analysis=AP_PlotData_filter(Analysis,thistype)
%AP_PlotData_filter generates a figure from the licks and the photometry
%data of 'channelnb' contained in the structure 'Analysis.(thistype)'. 
%The figure shows, for the sorted trial types specified by 'thistype' :
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Parameters
%
%function designed by Quentin 2017 for Analysis_Photometry

FigTitle=['Filter ' thistype];
illustrationTest=Analysis.Parameters.Illustration(2);

%% Close figures
try
    close FigTitle;
end

%% Data
[timeAVG,dataAVG,semAVG,labelYData]=AP_PlotData_SelectorAVG(Analysis,thistype);
[timeRaster,trialRaster,dataRaster,labelYRaster]=AP_PlotData_SelectorRaster(Analysis,thistype);

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(Analysis.(thistype).Name,'_',' '),Analysis.(thistype).nTrials);
labelx='Time (s)';   
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
transparency=0;
% Automatic definition of axes
maxtrial=Analysis.(thistype).nTrials;
if ~illustrationTest
if maxtrial<20
    maxtrial=20;
else
    maxtrial=20;
end
end
%Lick AVG y axes
maxrate=max(Analysis.(thistype).Licks.AVG);
if maxrate<10
    maxrate=10;
end
thisPlotY=Analysis.Parameters.PlotY_photo;

nbOfPlotsY=3+3*size(dataAVG,2);
nbOfPlotsX=1;

%% Plot
scrsz = get(groot,'ScreenSize');
figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

%% Licking Data
subplot(nbOfPlotsY,nbOfPlotsX,[1 2]); hold on;
title(Title);
% Raster
plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r','MarkerSize',4);
plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m','MarkerSize',4);  
ylabel(labely1);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
% Average
subplot(nbOfPlotsY,nbOfPlotsX,3); hold on;
shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',transparency);
plot([0 0],[0 maxrate+1],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[maxrate maxrate],'-b','LineWidth',2);
ylabel(labely2); xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);

%% Neuronal Data
if ~isempty(dataAVG)
    if ~Analysis.Parameters.Photometry
        maxtrial=max(trialRaster{1});
    end
    counter=0;
    for thisC=1:size(dataAVG,2)
% Average
        thisSubPlot=6+counter;
        subplot(nbOfPlotsY,nbOfPlotsX,thisSubPlot); hold on;
        shadedErrorBar(timeAVG{thisC},dataAVG{thisC},semAVG{thisC},'-k',transparency);
        if isnan(thisPlotY(thisC,:))
            axis tight;
            thisPlotY(thisC,:)=get(gca,'YLim');
        end
        plot([0 0],thisPlotY,'-r');
        plot(Analysis.(thistype).Time.Cue(1,:),[thisPlotY(thisC,2) thisPlotY(thisC,2)],'-b','LineWidth',2);
        ylabel(labelYData); xlabel(labelx);
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisPlotY(thisC,:));
    
% Raster
        thisSubPlot=[4 5]+counter;
        subplot(nbOfPlotsY,nbOfPlotsX,thisSubPlot); hold on;
        imagesc(timeRaster{thisC},trialRaster{thisC},dataRaster{thisC},thisPlotY(thisC,:));
        if Analysis.Parameters.Photometry
            plot(Analysis.(thistype).Time.Outcome(:,1),trialRaster{thisC},'.r','MarkerSize',4);
            plot(Analysis.(thistype).Time.Cue(:,1),trialRaster{thisC},'.m','MarkerSize',4);
        else
            plot(Analysis.(thistype).Time.Outcome(1,1)*ones(size(trialRaster{thisC})),trialRaster{thisC},'.r','MarkerSize',4);
            plot(Analysis.(thistype).Time.Cue(1,1)*ones(size(trialRaster{thisC})),trialRaster{thisC},'.m','MarkerSize',4);
        end  
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = labelYRaster;
        ylabel(labelYRaster);
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
        counter=counter+3;
    end
end    
end