function Analysis=AB_GoNogo_Performance(Analysis)

%% Data
tSequence=Analysis.Core.TrialNumbers;
ttSequence=Analysis.Core.TrialTypes;
if isfield(Analysis.Core.BpodSettings{1,1},'BlocSequence')
bSequence=Analysis.Core.BpodSettings{1,1}.BlocSequence;
blocID=[Analysis.Core.BpodSettings{1, 1}.GUI.Bloc1; ...
        Analysis.Core.BpodSettings{1, 1}.GUI.Bloc2;...
        Analysis.Core.BpodSettings{1, 1}.GUI.Bloc3];
if length(bSequence)>length(tSequence)
    bSequence=bSequence(tSequence);
end
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

fGo=Analysis.Filters.Go;
fNoGo=Analysis.Filters.NoGo;
fGo_State=Analysis.Filters.Go_State;
fNoGo_State=Analysis.Filters.NoGo_State;

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

subplot(2,1,2); hold on
xp=tSequence(fGo);
y=movmedian(licks(fGo),5);
plot(xp,y,'-k')
xp=tSequence(fNoGo);
y=movmedian(licks(fNoGo),5);
plot(xp,y,'--k')

%% Run through blocs
for b=1:length(blocID)
    try
    thisBloc=bSequence==b;
    thisTrials=tSequence(thisBloc);
    thisTrialType=ttSequence(thisBloc);
    thisfGo=fGo(thisBloc);
    thisfNoGo=fNoGo(thisBloc);
    thisfGo_State=fGo_State(thisBloc);
    thisfNoGo_State=fNoGo_State(thisBloc);

    hit=logical(thisfGo.*thisfGo_State);
    miss=logical(thisfGo.*thisfNoGo_State);
    FA=logical(thisfNoGo.*thisfGo_State);
    CR=logical(thisfNoGo.*thisfNoGo_State);
    goTrial=unique(thisTrialType(thisfGo));
    nogoTrial=unique(thisTrialType(thisfNoGo));
% Performance calculation
    lickRate=[mean(licks(thisTrials(thisfGo))),mean(licks(thisTrials(thisfNoGo)))];
    hitRate(b)=sum(hit)/sum(thisfGo);
    FARate(b)=sum(FA)/sum(thisfNoGo);
% dprime
    epsilon = 1e-5;
    hr4d= min(max(hitRate(b), epsilon), 1 - epsilon);
    fa4d= min(max(FARate(b), epsilon), 1 - epsilon);
    dprime(b)=norminv(hr4d)-norminv(fa4d);

% Figure
    subplot(2,1,1);
    xp=thisTrials(hit);
    yl=licks(xp);
    if ~isempty(xp)
        subplot(2,1,1);
        plot(xp,1,[cueID_color(goTrial) stateID_shape(1)],'MarkerFaceColor',cueID_color(goTrial))
        subplot(2,1,2);
        plot(xp,yl,[cueID_color(goTrial) stateID_shape(1)],'MarkerFaceColor',cueID_color(goTrial))
    end

    xp=thisTrials(miss);
    yl=licks(xp);
    if ~isempty(xp)
        subplot(2,1,1);
        plot(xp,0,[cueID_color(goTrial) stateID_shape(1)])
        subplot(2,1,2);
        plot(xp,yl,[cueID_color(goTrial) stateID_shape(1)])
    end

    xp=thisTrials(FA);
    yl=licks(xp);
    if ~isempty(xp)
        subplot(2,1,1);
        plot(xp,1,[cueID_color(nogoTrial) stateID_shape(2)])
        subplot(2,1,2);
        plot(xp,yl,[cueID_color(nogoTrial) stateID_shape(2)])
    end

    xp=thisTrials(CR);
    yl=licks(xp);
    if ~isempty(xp)
        subplot(2,1,1);
        plot(xp,0,[cueID_color(nogoTrial) stateID_shape(2)],'MarkerFaceColor',cueID_color(nogoTrial))
        subplot(2,1,2);
        plot(xp,yl,[cueID_color(nogoTrial) stateID_shape(2)],'MarkerFaceColor',cueID_color(nogoTrial))
    end

    subplot(2,1,1);
    plot(thisTrials,1.1*ones(size(thisTrials)),['-' bloc_color(b)])
    text(thisTrials(5),1.4,sprintf('blocID %d', blocID(b)));
    text(thisTrials(5),1.2,sprintf('hit-FA : %.2f, d-prime : %.2f',hitRate(b)-FARate(b), dprime(b)));
    subplot(2,1,2);
% Lick rate
    subplot(2,1,2);
    plot(thisTrials,9*ones(size(thisTrials)),['-' bloc_color(b)])
    text(thisTrials(5),10,sprintf('go : %.2f , nogo : %.2f (Hz)',lickRate(1),lickRate(2)));
    catch
    end
end
subplot(2,1,1);
legend('Cue1','Cue2','Cue3','GoCue','NogoCue')
xlim([0 length(tSequence)])
ylim([-0.2 1.8]);
yticks([0 1])
yticklabels({'NoLicks' 'Licks'})
ylabel('Behavior')
subplot(2,1,2);
legend('GoCue','NoGoCue')
xlim([0 length(tSequence)])
ylim([-0.2 11])
xlabel('Trial numbers')
ylabel('Lickrate (Hz)')

Analysis.Performance.HitRate=hitRate;
Analysis.Performance.FARate=FARate;
Analysis.Performance.prime=dprime;
dprime
end
