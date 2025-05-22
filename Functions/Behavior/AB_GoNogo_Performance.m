function AB_GoNogo_Performance(Analysis)

%% Data
tSequence=Analysis.Core.TrialNumbers;
ttSequence=Analysis.Core.TrialTypes;
if isfield(Analysis.Core.BpodSettings{1,1},'BlocSequence')
bSequence=Analysis.Core.BpodSettings{1,1}.BlocSequence;
blocID=[Analysis.Core.BpodSettings{1, 1}.GUI.Bloc1; ...
        Analysis.Core.BpodSettings{1, 1}.GUI.Bloc2;...
        Analysis.Core.BpodSettings{1, 1}.GUI.Bloc3];
else
    bSequence=ones(size(tSequence));
    blocID=15;
end

switch Analysis.Parameters.Behavior.Phase
    case 'GoNoGo Trace'
    licks=Analysis.AllData.Licks.DelayAVG;
    otherwise
    licks=Analysis.AllData.Licks.CueAVG;
end

% Figure
cueID_color='brgbrg';
stateID_shape='os';
bloc_color='kbk';

%% Initialize
ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*1/10 ScrSze(4)*1/10 ScrSze(3)*8/10 ScrSze(4)*8/10];
figure('Position', FigSze, 'numbertitle','off');
subplot(2,1,1); hold on
plot(-1,0,[cueID_color(1) 'o'],'MarkerFaceColor',cueID_color(1))
plot(-1,0,[cueID_color(2) 'o'],'MarkerFaceColor',cueID_color(2))
plot(-1,0,[cueID_color(3) 'o'],'MarkerFaceColor',cueID_color(3))
plot(-1,0,['k' stateID_shape(1)])
plot(-1,0,['k' stateID_shape(2)])

%% Run through blocs
for b=1:length(blocID)
    thisBloc=bSequence==b;
    thisTrials=tSequence(thisBloc);
    thisTrialType=ttSequence(thisBloc);
    fGo=Analysis.Filters.Go(thisBloc);
    fNoGo=Analysis.Filters.NoGo(thisBloc);
    fGo_State=Analysis.Filters.Go_State(thisBloc);
    fNoGo_State=Analysis.Filters.NoGo_State(thisBloc);

    hit=logical(fGo.*fGo_State);
    miss=logical(fGo.*fNoGo_State);
    FA=logical(fNoGo.*fGo_State);
    CR=logical(fNoGo.*fNoGo_State);
    
    goTrial=unique(thisTrialType(fGo));
    nogoTrial=unique(thisTrialType(fNoGo));

    hitRate=sum(hit)/sum(fGo);
    FARate=sum(FA)/sum(fNoGo);
    dprime=norminv(hitRate)-norminv(FARate)
    
% Figure
    subplot(2,1,1);
    x=thisTrials(hit);
    if ~isempty(x)
        plot(x,1,[cueID_color(goTrial) '-'  stateID_shape(1)],'MarkerFaceColor',cueID_color(goTrial))
    end
    x=thisTrials(miss);
    if ~isempty(x)
        plot(x,0,[cueID_color(goTrial) '-' stateID_shape(1)],'MarkerFaceColor',cueID_color(goTrial))
    end
    x=thisTrials(FA);
    if ~isempty(x)
        plot(x,1,[cueID_color(nogoTrial) '-' stateID_shape(2)],'MarkerFaceColor',cueID_color(nogoTrial))
    end
    x=thisTrials(CR);
    if ~isempty(x)
        plot(x,0,[cueID_color(nogoTrial) '-' stateID_shape(2)],'MarkerFaceColor',cueID_color(nogoTrial))
    end
    plot(thisTrials,1.1*ones(size(thisTrials)),['-' bloc_color(b)])
    text(mean(thisTrials),1.4,sprintf('blocID %d', blocID(b)));
    text(mean(thisTrials),1.2,sprintf('hit-FA : %.2f, d-prime : %.2f',hitRate-FARate, dprime));

    subplot(2,1,2); hold on
    xg=thisTrials(fGo);
    yg=licks(fGo);
    plot(xg,yg,[cueID_color(goTrial) stateID_shape(1)],'MarkerFaceColor',cueID_color(goTrial))
    xng=thisTrials(fNoGo);
    yng=licks(fNoGo);
    plot(xng,yng,[cueID_color(nogoTrial) stateID_shape(2)],'MarkerFaceColor',cueID_color(nogoTrial))

    plot(thisTrials,9*ones(size(thisTrials)),['-' bloc_color(b)])
    text(thisTrials(5),10,sprintf('go : %.2f , nogo : %.2f (Hz)',mean(yg),mean(yng)));

end
subplot(2,1,1);
legend('Cue1','Cue2','Cue3','GoCue','NogoCue','Location','northwest')
xlim([0 length(tSequence)])
ylim([-0.2 1.8]);
yticks([0 1])
yticklabels({'NoLicks' 'Licks'})
ylabel('Behavior')
subplot(2,1,2);
xlim([0 length(tSequence)])
ylim([-0.2 11])
xlabel('Trial numbers')
ylabel('Lickrate (Hz)')

end
