function thisData = AP_Analyze_Peaks(thisData,thisCue,trialTypes,subFilters,thisSesh)
%  AP_ANALYZE_PEAKS analyzes peaks identified by AP_FIND_PEAKS.
%  Function first locates first peaks post-cue and post-reward then 
%  determines the mean or median peak prominence (depending on input) and 
%  jitter following each event for each trial type. Spontaneous events are 
%  then analyzed to compare prominence size of non-evoked events (time 
%  distance following cue or reward necessary to classify an event as 
%  spontaneous is defined by spontTime).
%  thisData:   structure containing matrix of trialized, reward-aligned
%              photometry data and all calculated peak data.
%  thisCue:    cue time for this session relative to reward.
%  trialTypes: cell array of trial type names.
%  subFilters: structure of component filters to build trial-type filters.
%  thisSesh:      array of trial indices for single session.

%% remove blank trial types

trialTypes =trialTypes(~contains(trialTypes,'blank'));

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
    filters         =zeros(length(filterNames),size(thisData.Time,1));
    for filt        =1:length(filterNames)
    subFilt         =subFilters.(filterNames{filt})';
    filters(filt,:) =subFilt(thisSesh);
    end
    intersection    =all(filters,1);                                        % intersection of sub-filters
    filterContainer(trialType)=intersection; 
end

%% identify cue- and reward-evoked responses and quantify prominence

thisData.firstPtime.Rew     =nan(size(thisData.Time,1),1);
thisData.firstPprom.Rew     =nan(size(thisData.Time,1),1);
thisData.firstJitter.Rew    =nan(length(trialTypes),1)';
thisData.firstPtime.Cue     =nan(size(thisData.Time,1),1);
thisData.firstPprom.Cue     =nan(size(thisData.Time,1),1);
thisData.firstJitter.Cue    =nan(length(trialTypes),1)';
thisData.firstPtime.Spont   =nan(size(thisData.Time,1),1);
thisData.firstPprom.Spont   =nan(size(thisData.Time,1),1);

for tt                          =1:length(trialTypes)
    trialType                   =trialTypes{tt};
    filter                      =filterContainer(trialType);
    ptimes                      =thisData.ptimes(filter,:);                 % peak time matrix for all trials of trial type
    normpproms                  =thisData.pproms(filter,:);                 % peak prom matrix for all trials of trial type  
    %%%%%%%%%% normpproms       =thisData.normproms(filter,:);
    if contains(trialType,'Reward')
    ptimesPostRew               =find(ptimes>=0);                           % linear indices of peaks after reward
    [rowRew,colRew]             =ind2sub(size(ptimes),ptimesPostRew);       % convert linear indices to (row,column) matrix coordinates
    [uniqRew,idxRew]            =unique(rowRew);                            % first occurrence of each row (trial) + index of occurrence
    firstPtimeRew               =arrayfun(@(i) ptimes(uniqRew(i),       ... % utilize first (row, col) coordinate to find first peak times for each trial
                                        colRew(idxRew(i))),             ...
                                       (1:length(uniqRew)).');
    firstPpromRew               =arrayfun(@(i) normpproms(uniqRew(i),   ... % utilize first (row, col) coordinate to find first peak proms (normalized) for each trial
                                        colRew(idxRew(i))),             ...
                                       (1:length(uniqRew)).');
    jitterRew                   =std(firstPtimeRew);                        % jitter defined as std of timing
    trialsFilt                  =find(filter);                              % indices of trials matching filter 
    uniqTrialsRew               =trialsFilt(uniqRew);                       % indices of trials matching filter with peaks in desired region
    thisData.firstPtime.Rew(uniqTrialsRew)=firstPtimeRew;
    thisData.firstPprom.Rew(uniqTrialsRew)=firstPpromRew;
    thisData.firstJitter.Rew(tt)=jitterRew;
    end
    if contains(trialType,'Cue')
    ptimesPostCue               =find((ptimes>=thisCue) & (ptimes<0));      % linear indices of peaks after cue
    [rowCue,colCue]             =ind2sub(size(ptimes),ptimesPostCue);       % convert linear indices to (row,column) matrix coordinates
    [uniqCue,idxCue]            =unique(rowCue);                            % first occurrence of each row (trial) + index of occurrence
    firstPtimeCue               =arrayfun(@(i) ptimes(uniqCue(i),       ... % utilize first (row, col) coordinate to find first peak times for each trial
                                        colCue(idxCue(i))),             ...
                                       (1:length(uniqCue)).');
    firstPpromCue               =arrayfun(@(i) normpproms(uniqCue(i),   ... % utilize first (row, col) coordinate to find first peak proms (normalized) for each trial
                                        colCue(idxCue(i))),             ...
                                       (1:length(uniqCue)).');
    jitterCue                   =std(firstPtimeCue);                        % jitter defined as std of timing
    trialsFilt                  =find(filter);                              % indices of trials matching filter 
    uniqTrialsCue               =trialsFilt(uniqCue);                       % indices of trials matching filter with peaks in desired region
    thisData.firstPtime.Cue(uniqTrialsCue)=firstPtimeCue;
    thisData.firstPprom.Cue(uniqTrialsCue)=firstPpromCue;
    thisData.firstJitter.Cue(tt)=jitterCue;
    end
end

ptimes                      =thisData.ptimes;                               % peak time matrix for all trials of trial type
normpproms                  =thisData.pproms;                               % peak prom matrix for all trials of trial type  
%%%%%%%%%% normpproms       =thisData.normproms;
spontPeriod                 =[(thisData.Time(1,1)+0.25),(thisCue-0.25)];
ptimesSpont                 =find((ptimes>=spontPeriod(1)) &            ...
                                  (ptimes<=spontPeriod(2)));                % linear indices of spontaneous peaks
[rowSpont,colSpont]         =ind2sub(size(ptimes),ptimesSpont);             % convert linear indices to (row,column) matrix coordinates
[uniqSpont,idxSpont]        =unique(rowSpont);                              % first occurrence of each row (trial) + index of occurrence
firstPtimeSpont             =arrayfun(@(i) ptimes(uniqSpont(i),         ... % utilize first (row, col) coordinate to find first peak times for each trial
                                    colSpont(idxSpont(i))),             ...
                                   (1:length(uniqSpont)).');
firstPpromSpont             =arrayfun(@(i) normpproms(uniqSpont(i),     ... % utilize first (row, col) coordinate to find first peak proms (normalized) for each trial
                                    colSpont(idxSpont(i))),             ...
                                   (1:length(uniqSpont)).');
thisData.firstPtime.Spont(uniqSpont)=firstPtimeSpont;
thisData.firstPprom.Spont(uniqSpont)=firstPpromSpont;
