
trialNames =Analysis.Parameters.TrialNames;
trialTypes =trialNames(~contains(trialNames,'blank'));

%% define filters using pre-existing sub-filters

filterContainer                    =containers.Map;
filterContainer('Cue A Reward')    ={'Cue_A','Reward','LicksOutcome'};
filterContainer('Cue A Omission')  ={'Cue_A','Omission'};
filterContainer('Cue B Reward')    ={'Cue_B','Reward','LicksOutcome'};
filterContainer('Cue B Omission')  ={'Cue_B','Omission'};
filterContainer('Cue C Reward')    ={'Cue_C','Reward','LicksOutcome'};
filterContainer('Cue C Omission')  ={'Cue_C','Omission'};
filterContainer('Uncued Reward')   ={'Uncued','Reward','LicksOutcome'};
filterContainer('Uncued Omission') ={'Uncued','Omission'};
filterContainer('Reward')          ={'Reward','LicksOutcome'};
filterContainer('Habituation')     ={'type_2'};

for tt              =1:length(trialTypes)
    trialType       =trialTypes{tt};
    filterNames     =filterContainer(trialType);
    filters         =zeros(length(filterNames),Analysis.Parameters.nTrials);
    for filt        =1:length(filterNames)
    subFilt         =Analysis.Filters.(filterNames{filt})';
    filters(filt,:) =subFilt;
    end
    intersection    =all(filters,1);                                        % intersection of sub-filters
    filterContainer(trialType)=intersection; 
end

%% plot random trial
figure(1);
tiledlayout(3,2);
nexttile([2,2]);

randtrial =round((Analysis.Parameters.nTrials)*rand(1)); % completely random trial

photodata =Analysis.AllData.Photo_470.DFF(randtrial,:); 
time      =Analysis.AllData.Photo_470.Time(randtrial,:);

% trace
plot(time,photodata,'displayName','Trace','LineWidth',1)
ylim([-10 20])
hold on

% peaks + minima 
nan_idxs =~isnan(Analysis.AllData.Photo_470.plocs(randtrial,:));
nan_locs =find(nan_idxs);
for i    =1:length(nan_locs) % for each peak in random trial
    idx  =nan_locs(i);
    xline(Analysis.AllData.Photo_470.ptimes(randtrial,idx),":r",{i},                 ...
         'displayName','Peak Location')
    xline(Analysis.AllData.Photo_470.mtimes(randtrial,idx),":g",'LineWidth',1.5,     ...
         'displayName','Minima Location')
    line([Analysis.AllData.Photo_470.ptimes(randtrial,idx),                          ...
          Analysis.AllData.Photo_470.ptimes(randtrial,idx)],                         ...
         [Analysis.AllData.Photo_470.pheights(randtrial,idx),                        ...
          Analysis.AllData.Photo_470.pheights(randtrial,idx)-                        ...
          Analysis.AllData.Photo_470.pproms(randtrial,idx)], ...
         'LineWidth',1,'Color',"k",'displayName','Prominence')
end
hold off

% first rew peaks
if ~isnan(Analysis.AllData.Photo_470.firstPtime.Rew(randtrial))
rewFiltA =filterContainer('Cue A Reward');
rewFiltB =filterContainer('Cue B Reward');
rewFiltC =filterContainer('Cue C Reward');
if any([rewFiltA(randtrial),rewFiltB(randtrial),rewFiltC(randtrial)])
xline(Analysis.AllData.Photo_470.firstPtime.Rew(randtrial),             ...
      'Color',[17 17 17]/255,'LineWidth',10,'Alpha',0.25);
ylims=ylim;
text(Analysis.AllData.Photo_470.firstPtime.Rew(randtrial)+0.01,         ...
     ylims(1)+1.2,'Rew','FontSize',13)
end
end

% first cue peaks
if ~isnan(Analysis.AllData.Photo_470.firstPtime.Cue(randtrial))
cueFiltA1 =filterContainer('Cue A Reward');
cueFiltB1 =filterContainer('Cue B Reward');
cueFiltC1 =filterContainer('Cue C Reward');
cueFiltA2 =filterContainer('Cue A Omission');
cueFiltB2 =filterContainer('Cue B Omission');
cueFiltC2 =filterContainer('Cue C Omission');
if any([cueFiltA1(randtrial),cueFiltB1(randtrial),cueFiltC1(randtrial), ...
        cueFiltA2(randtrial),cueFiltB2(randtrial),cueFiltC2(randtrial)])
xline(Analysis.AllData.Photo_470.firstPtime.Cue(randtrial),             ...
      'Color',[17 17 17]/255,'LineWidth',10,'Alpha',0.25);
ylims=ylim;
text(Analysis.AllData.Photo_470.firstPtime.Cue(randtrial)+0.01,         ...
     ylims(1)+1.2,'Cue','FontSize',13)
end
end

% first spont peaks
if ~isnan(Analysis.AllData.Photo_470.firstPtime.Spont(randtrial))
xline(Analysis.AllData.Photo_470.firstPtime.Spont(randtrial),           ...
      'Color',[17 17 17]/255,'LineWidth',10,'Alpha',0.25);
ylims=ylim;
text(Analysis.AllData.Photo_470.firstPtime.Spont(randtrial)+0.01,       ...
     ylims(1)+1.2,'Spontaneous','FontSize',13)
end

% style
set(gca,'FontSize',15)
ylabel('Z-score','FontSize',20)
xlabel('Time (s) aligned to reward','FontSize',20)
tt='type_%i';
trialType=Analysis.(sprintf(tt,Analysis.AllData.TrialTypes(randtrial))).Name;
titlestr='%s: %s';
titlestr=sprintf(titlestr,Analysis.Parameters.Animal,                   ...
                 trialType);
title(titlestr,'FontSize',25)
legend('Trace','Peak Location','Minima Location','Prominence',          ...
       'Location','southeast')