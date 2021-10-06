function thisData = AP_Find_Peaks(thisData, thisSesh, minprom, multiplier)
%  AP_FIND_PEAKS locates peaks looking leftwards only.
%  Function first utilizes built-in findpeaks to locate all peaks 
%  without thresholding. After localizing peaks, only prominent peaks 
%  (relative to left-sided signal search) will remain, thresholded by
%  a minimum prominence of input minprom (percentile peak comparitor)
%  multiplied by input multiplier (transformed to %). 
%  thisData:      structure containing matrix of trialized, normalized,
%                 reward-aligned photometry data
%  thisSesh:      array of trial indices for single session; defaults to
%                 array of all trial numbers
%  minprom:       minimum "prominence" of peak to be recorded (percentile)
%  multiplier:    multiplier for thresholding peaks; transformed to %

%% args

if nargin  < 4
    multiplier = 50;
end

if nargin  < 3
    minprom = 90;
end

if nargin  < 2
    thisSesh = (1:size(thisData.Time,1));
end

if nargin  < 1
    disp('No photodata inputted.')
end

%% calculate all peak prominences + peak threshold

thisData.Time =thisData.Time(thisSesh,:);
thisData.DFF  =thisData.DFF(thisSesh,:);
multiplier    =multiplier/100;                                              % convert thresh to %
[pks,locs]    =arrayfun(@(i) findpeaks(thisData.DFF(i,:)),              ...
                       (1:size(thisData.DFF,1)).', 'UniformOutput', false); % unfiltered pks and locs
lengths       =arrayfun(@(i) numel(pks{i}), 1:size(pks,1));
maxPeaks      =max(lengths);                                                % max # unfiltered peaks
func          =@(x) [x, nan(1,maxPeaks-numel(x))];                          % NaN pad to create equal length vectors
pks           =cell2mat(cellfun(func,pks,'UniformOutput',false));           % transform to matrix of pks   
locs          =cell2mat(cellfun(func,locs,'UniformOutput',false));          % matrix of locs
ipeak         =1;
lpeakloc      =ones(size(thisData.DFF,1),1);           
pproms        =nan(size(pks,1),size(pks,2));     

while ipeak          <=maxPeaks
    cpeak             =pks(:,ipeak);                                        % trial peak heights
    cpeakloc          =locs(:,ipeak);                                       % trial peak locs
    nanidxs           =isnan(cpeak);
    cpeak(nanidxs)    =0;                                                   % replace nans with 0s
    cpeakloc(nanidxs) =lpeakloc(nanidxs);                                   % replace nans with prior loc
    thisDataSlice     =arrayfun(@(i)                                    ... % slice each trial between last and current locs
                                thisData.DFF(i,lpeakloc(i):cpeakloc(i)),...
                               (1:size(thisData.DFF,1)).','UniformOutput',false);
    lengths           =arrayfun(@(i) numel(thisDataSlice{i}),           ... % max slice length
                                1:size(thisDataSlice,1));             
    maxLength         =max(lengths);
    func              =@(i) [i, nan(1,maxLength-numel(i))];                 % nan-pad slices to create equal length vectors
    thisDataSlice     =cell2mat(cellfun(func,thisDataSlice,             ... % create matrix of sliced data
                               'UniformOutput',false));
    absmin            =min(thisDataSlice,[],2,'omitnan');                   % minima for calculating proms
    dpeak             =cpeak-absmin;                                        % "proms"
    dpeak(nanidxs)    =nan;                                                 % ensure no peaks at nans
    lpeakloc          =cpeakloc;                                            % update peak
    pproms(:,ipeak)   =dpeak;
    ipeak=ipeak+1;
end

perctl  =prctile(pproms,minprom,'all');
thresh  =perctl*multiplier;

%% peak detection + peak refinement
                           
[pks,locs]    =arrayfun(@(i) findpeaks(thisData.DFF(i,:)),              ...
                       (1:size(thisData.DFF,1)).', 'UniformOutput', false); % unfiltered pks and locs
lengths       =arrayfun(@(i) numel(pks{i}), 1:size(pks,1));
maxPeaks      =max(lengths);                                                % max # unfiltered peaks
func          =@(x) [x, nan(1,maxPeaks-numel(x))];                          % NaN pad to create equal length vectors
pks           =cell2mat(cellfun(func,pks,'UniformOutput',false));           % transform to matrix of pks   
locs          =cell2mat(cellfun(func,locs,'UniformOutput',false));          % matrix of locs
ipeak         =1;
lpeakloc      =ones(size(thisData.DFF,1),1);           
plocs         =nan(size(pks,1),size(pks,2));
ptimes        =nan(size(pks,1),size(pks,2));
pproms        =nan(size(pks,1),size(pks,2));
pheights      =nan(size(pks,1),size(pks,2));
mlocs         =nan(size(pks,1),size(pks,2));
mtimes        =nan(size(pks,1),size(pks,2));
pmins         =nan(size(pks,1),size(pks,2));
%ptrace        =cell(size(pks,1),1);

while ipeak          <=maxPeaks
    cpeak             =pks(:,ipeak);                                        % trial peak heights
    cpeakloc          =locs(:,ipeak);                                       % trial peak locs
    nanidxs           =isnan(cpeak);
    cpeak(nanidxs)    =0;                                                   % replace nans with 0s
    cpeakloc(nanidxs) =lpeakloc(nanidxs);                                   % replace nans with prior loc
    thisDataSlice     =arrayfun(@(i)                                    ... % slice each trial between last and current locs
                                thisData.DFF(i,lpeakloc(i):cpeakloc(i)),...
                               (1:size(thisData.DFF,1)).','UniformOutput',false);
    lengths           =arrayfun(@(i) numel(thisDataSlice{i}),           ... % max slice length
                                1:size(thisDataSlice,1));             
    maxLength         =max(lengths);
    func              =@(i) [i, nan(1,maxLength-numel(i))];                 % nan-pad slices to create equal length vectors                           
    thisDataSlice     =cell2mat(cellfun(func,thisDataSlice,             ... % create matrix of sliced data
                               'UniformOutput',false));
    [absmin,minloc]   =min(thisDataSlice,[],2,'omitnan');                   % minima for calculating proms                 
    minloc            =lpeakloc+minloc-1;
    absmin(nanidxs)   =0; 
    dpeak             =cpeak-absmin;                                        % "proms"
    dpeak(nanidxs)    =nan;                                                 % ensure no peaks at nans
    lpeakloc          =cpeakloc;                                            % update peak
    pproms(:,ipeak)   =dpeak;
    thresholdedidxs   =(dpeak>=thresh);
    if any(thresholdedidxs)                                                
    thresholdedtrials          =find(thresholdedidxs);
    thresholdedplocs           =cpeakloc(thresholdedidxs);
    linearpidxs                =sub2ind(size(thisData.DFF),             ...
                                        thresholdedtrials',(thresholdedplocs'));
    cpeaktime                  =nan(size(pks(:,ipeak)));
    cpeaktime(thresholdedidxs) =thisData.Time(linearpidxs)';
    thresholdedmlocs           =minloc(thresholdedidxs);
    linearmidxs                =sub2ind(size(thisData.DFF),             ...
                                        thresholdedtrials',(thresholdedmlocs'));
    mtime                      =nan(size(pks(:,ipeak)));
    mtime(thresholdedidxs)     =thisData.Time(linearmidxs);
    cpeakloc(~thresholdedidxs) =nan;
    dpeak(~thresholdedidxs)    =nan;
    cpeak(~thresholdedidxs)    =nan;
    minloc(~thresholdedidxs)   =nan;
    absmin(~thresholdedidxs)   =nan;
    ptimes(:,ipeak)            =cpeaktime;
    plocs(:,ipeak)             =cpeakloc;
    pproms(:,ipeak)            =dpeak;
    pheights(:,ipeak)          =cpeak;
    mlocs(:,ipeak)             =minloc;
    mtimes(:,ipeak)            =mtime;
    pmins(:,ipeak)             =absmin;
    end
    ipeak=ipeak+1;
end

thisData.plocs        =plocs;
thisData.ptimes       =ptimes;
thisData.pproms       =pproms;
thisData.pheights     =pheights;
thisData.mlocs        =mlocs;
thisData.mtimes       =mtimes;
thisData.pmins        =pmins;
thisData.normproms    =pproms/median(pproms,'all','omitnan');               % single-fiber and session normalized data
thisData.normpheights =pheights/median(pheights,'all','omitnan');           % single-fiber and session normalized data