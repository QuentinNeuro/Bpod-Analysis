function AP_PlotData_Filter_Summary(Analysis,FigTitle,Group)

%% Check trialTypes inside group
nbOfTypes=size(Group,2);
dataTest=[]; tcounter=1;
while isempty(dataTest) || tcounter<=nbOfTypes
    thistype=Group{tcounter};
    if Analysis.(thistype).nTrials
    [~,dataTest,~,~]=AP_PlotData_SelectorAVG(Analysis,thistype); 
    end
    tcounter=tcounter+1;
end
if isempty(dataTest) && tcounter==nbOfTypes
        disp(['Cannot create filter summary plot for ' FigTitle'])
        disp('Check AP_PlotData_Filter')
    return
end

%% Plot Parameters
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
FigTitle=strrep(FigTitle,'_',' ');
labelx='Time (sec)';   
xTime=Analysis.Parameters.Plot.xTime;
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Parameters.Plot.Transparency;
labely1='Licks Rate (Hz)';
maxrate=10;
PlotY_photo=Analysis.Parameters.Plot.yPhoto;
nbOfPlotsY=1+size(dataTest,2);
nbOfPlotsX=1;

%% Figure
scrsz = get(groot,'ScreenSize');
figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Plot.Legend,'Position',[10,5,500,20]); 

%% Group plot
k=1;
for i=1:nbOfTypes
	thistype=Group{i};
if Analysis.(thistype).nTrials
    handle.title{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
% Licks
    subplot(nbOfPlotsY,nbOfPlotsX,1); hold on;
    hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
    hp(k)=hs.mainLine;
% Neuronal Data
    [timeAVG,dataAVG,semAVG,labelYData]=AP_PlotData_SelectorAVG(Analysis,thistype);
    for thisCh=1:size(dataAVG,2)
        subplot(nbOfPlotsY,nbOfPlotsX,1+thisCh); hold on;
        shadedErrorBar(timeAVG{thisCh},dataAVG{thisCh},semAVG{thisCh},color4plot{k},transparency);
    end
    k=k+1;
end
end
% Makes Plot pretty
    subplot(nbOfPlotsY,nbOfPlotsX,1); hold on;
	ylabel(labely1);
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
	title(FigTitle);
    legend(hp,handle.title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
    
    for thisCh=1:size(dataAVG,2)
        subplot(nbOfPlotsY,nbOfPlotsX,1+thisCh); hold on;
        ylabel(labelYData{thisCh});
        xlabel(labelx);
        if isnan(PlotY_photo(thisCh,:))
            axis tight
            PlotY_photo(thisCh,:)=get(gca,'YLim');
        end
        plot([0 0],PlotY_photo(thisCh,:),'-r');
        plot(Analysis.AllData.Time.Cue(1,:),[PlotY_photo(thisCh,2) PlotY_photo(thisCh,2)],'-b','LineWidth',2);
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    end
end