function AP_PlotSummary(Analysis,channelnb,varargin)
%AP_PlotSummary generates a figure to compare the trial types specified as
%input. Each input argument is a cell array containing one or specified multiple
%trial types (works up to 4 groups). The figure shows :
%1) The average lick rates
%2) The average photometry data from 'channelnb'
%3) A table with DFF value for the cue and outcome
%4) A plot showing bleaching
%
%function designed by Quentin 2016 for Analysis_Photometry

thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot Summary %s',char(Analysis.Parameters.PhotoChNames{channelnb}));

%% Plot Parameters
nbofgroups=nargin-2;
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
for i=1:nbofgroups
    thisgroup=sprintf('thisgroup_%.0d',i);
	GP.(thisgroup).types=cell2mat(varargin(i));
    if ischar(GP.(thisgroup).types)
        GP.(thisgroup).types=A_NameToTrialNumber(Analysis,GP.(thisgroup).types);
    end
    k=1;
    for j=GP.(thisgroup).types 
        if ~isnan(j)
        GP.(thisgroup).title(k)=Analysis.Parameters.TrialNames(j);
        else
        GP.(thisgroup).title(k)={'unknown'};
        end
    k=k+1;    
    end 
end

labelx='Time (sec)';   
xTime=Analysis.Parameters.PlotX;
transparency=Analysis.Parameters.Transparency;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Licks Rate (Hz)';
maxrate=10;

if Analysis.Parameters.Zscore
    labelyFluo='Z-scored Fluo';
else
    labelyFluo='DF/Fo (%)';
end
PlotY_photo=Analysis.Parameters.PlotY_photo;

%% Table Parameters
TableTitles={'Trial Type','Cue Max DF/F(%)','Cue AVG DF/F(%)','SEM','Outcome Max DF/F(%)','Outcome AVG DF/F(%)','SEM','nb of trials','ignored trials'};
for i=1:Analysis.Parameters.nbOfTrialTypes
    thistype        =   sprintf('type_%.0d',i);
    TableData{i,1}	=   Analysis.(thistype).Name;
    TableData{i,2}	=   Analysis.(thistype).(thisChStruct).CueAVG_MAX;
    TableData{i,3}	=   Analysis.(thistype).(thisChStruct).CueAVG_AVG;
    TableData{i,4}	=   Analysis.(thistype).(thisChStruct).CueAVG_SEM;
    TableData{i,5}	=   Analysis.(thistype).(thisChStruct).OutcomeAVG_MAX;
    TableData{i,6} =    Analysis.(thistype).(thisChStruct).OutcomeAVG_AVG;
    TableData{i,7} =    Analysis.(thistype).(thisChStruct).OutcomeAVG_SEM;
    TableData{i,8} =    Analysis.(thistype).nTrials;
    TableData{i,9} =    Analysis.(thistype).IgnoredTrials;
end

%% Figure
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

%% Table
spt=subplot(3,4,[9 11]);
pos=get(spt,'position');
delete(spt);

TypeWidth=100;
NbWidth=(pos(3)-TypeWidth)/(length(TableTitles)-1);
TableColumnWidth{1}=TypeWidth;
for i=2:length(TableTitles)
    TableColumnWidth{i}=70;
end

t=uitable('ColumnWidth',TableColumnWidth,'Data',TableData,'ColumnName',TableTitles);
set(t,'units','normalized');
set(t,'position',pos);

%% Bleach plot
subplot(3,4,12);
plot(Analysis.AllData.(thisChStruct).Bleach,'-k');
title('Bleaching')
xlabel('Trial Nb');
ylabel('Normalized Fluo');

%% Group plot
for i=1:nbofgroups
	thisgroup=sprintf('thisgroup_%.0d',i);
% Population of the plots
    if ~isnan(GP.(thisgroup).types)
    k=1;
    for j=GP.(thisgroup).types
        thistype=sprintf('type_%.0d',j);
        subplot(3,4,i); hold on;
        hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
        hp(k)=hs.mainLine;
        subplot(3,4,i+4); hold on;
        shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{k},transparency);
        k=k+1;
    end
% Makes Plot pretty
    subplot(3,4,i); hold on;
	if i==1
        ylabel(labely1);
    end
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
    title(num2str(GP.(thisgroup).types));
	legend(hp,GP.(thisgroup).title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;

    subplot(3,4,i+4); hold on;
    if i==1
        ylabel(labelyFluo);
    end
    xlabel(labelx);
    
    if ~isnan(PlotY_photo(channelnb,:))
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(channelnb,:));
    plot([0 0],PlotY_photo(channelnb,:),'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[PlotY_photo(channelnb,2) PlotY_photo(channelnb,2)],'-b','LineWidth',2);
    else
         axis tight
         set(gca,'XLim',xTime,'XTick',xtickvalues);
         thisYLim=get(gca,'YLim');
         plot([0 0],thisYLim,'-r');
         plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
    end  
    end
end
end