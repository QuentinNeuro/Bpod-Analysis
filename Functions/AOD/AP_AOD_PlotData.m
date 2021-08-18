AP_AOD_PlotData2(Analysis,S);

function AP_AOD_PlotData2(Analysis,A_AOD)
XTime=timeWindow;
YLicks=[0 10];
YFluo=[-1 2];

ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*1/10 ScrSze(4)*1/10 ScrSze(3)*8/10 ScrSze(4)*8/10];
figure('Name',FigTitle,'Position', FigSze, 'numbertitle','off');

%% Figure
%type to plot:
trialsToPlot={'type_1','type_3','type_4'};
for thisC=cellsToPlot
    figure()
    counter=0;
    for t=1:size(trialsToPlot,2)
        thisTT=cell2mat(trialsToPlot(t));
        thisFilter=Analysis.Filters.(thisTT);
        subplot(4,3,1+counter)
        title(thisTT);
        plot(Analysis.(thisTT).Licks.Bin,Analysis.(thisTT).Licks.AVG,'-k')
        hold on
        plot([0 0],YLicks,'r')
        plot([-2 -1.5],[YLicks(2) YLicks(2)],'-b')
        xlim(XTime);ylim(YLicks);
        subplot(4,3,[4 7]+counter)
        imagesc(A_AOD.time,1:sum(thisFilter),A_AOD.perCell.data{1,thisC}(:,thisFilter)')
        hold on
        plot([0 sum(thisFilter)],YFluo,'r')
        plot([-2 -1.5],[0 0],'-b')
        xlim(XTime);
        subplot(4,3,10+counter)
        plot(A_AOD.time,nanmean(A_AOD.perCell.data{1,thisC}(:,thisFilter),2),'-k')
        hold on
        plot([0 0],YFluo,'r')
        plot([-2 -1.5],[YFluo(2) YFluo(2)],'-b')
        xlim(XTime);ylim(YFluo);
        counter=counter+1;
    end
end

figure()
for thisTT=1:max(Analysis.Core.TrialTypes)
    thisType=sprintf('type_%.0d',thisTT)
    thisFilter=Analysis.Filters.(thisType);
    A_AOD.perTrials.(thisType).data=A_AOD.perTrials.dataAVG(:,thisFilter);
    A_AOD.perTrials.(thisType).dataAVG=nanmean(A_AOD.perTrials.(thisType).data,2);
    plot(A_AOD.time,A_AOD.perTrials.(thisType).dataAVG);
    hold on
end
legend({'CueRew','CueOm','NeuCue','UncRew','UncOm'})
end