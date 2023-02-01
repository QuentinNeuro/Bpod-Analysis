function peaks=AP_FindPeak(data,time,minprom, multiplier)

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

%% calculate all peak prominences + peak threshold
multiplier    =multiplier/100;                                              % convert thresh to %
[pks,locs]    =arrayfun(@(i) findpeaks(data(i,:)),              ...
                       (1:size(data,1)).', 'UniformOutput', false); % unfiltered pks and locs
lengths       =arrayfun(@(i) numel(pks{i}), 1:size(pks,1));
maxPeaks      =max(lengths);                                                % max # unfiltered peaks
func          =@(x) [x, nan(1,maxPeaks-numel(x))];                          % NaN pad to create equal length vectors
pks           =cell2mat(cellfun(func,pks,'UniformOutput',false));           % transform to matrix of pks   
locs          =cell2mat(cellfun(func,locs,'UniformOutput',false));          % matrix of locs
ipeak         =1;
lpeakloc      =ones(size(data,1),1);           
pproms        =nan(size(pks,1),size(pks,2));     

while ipeak          <=maxPeaks
    cpeak             =pks(:,ipeak);                                        % trial peak heights
    cpeakloc          =locs(:,ipeak);                                       % trial peak locs
    nanidxs           =isnan(cpeak);
    cpeak(nanidxs)    =0;                                                   % replace nans with 0s
    cpeakloc(nanidxs) =lpeakloc(nanidxs);                                   % replace nans with prior loc
    thisDataSlice     =arrayfun(@(i)                                    ... % slice each trial between last and current locs
                                data(i,lpeakloc(i):cpeakloc(i)),...
                               (1:size(data,1)).','UniformOutput',false);
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
                           
[pks,locs]    =arrayfun(@(i) findpeaks(data(i,:)),              ...
                       (1:size(data,1)).', 'UniformOutput', false); % unfiltered pks and locs
lengths       =arrayfun(@(i) numel(pks{i}), 1:size(pks,1));
maxPeaks      =max(lengths);                                                % max # unfiltered peaks
func          =@(x) [x, nan(1,maxPeaks-numel(x))];                          % NaN pad to create equal length vectors
pks           =cell2mat(cellfun(func,pks,'UniformOutput',false));           % transform to matrix of pks   
locs          =cell2mat(cellfun(func,locs,'UniformOutput',false));          % matrix of locs
ipeak         =1;
lpeakloc      =ones(size(data,1),1);           
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
                                data(i,lpeakloc(i):cpeakloc(i)),...
                               (1:size(data,1)).','UniformOutput',false);
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
    linearpidxs                =sub2ind(size(data),             ...
                                        thresholdedtrials',(thresholdedplocs'));
    cpeaktime                  =nan(size(pks(:,ipeak)));
    cpeaktime(thresholdedidxs) =time(linearpidxs)';
    thresholdedmlocs           =minloc(thresholdedidxs);
    linearmidxs                =sub2ind(size(data),             ...
                                        thresholdedtrials',(thresholdedmlocs'));
    mtime                      =nan(size(pks(:,ipeak)));
    mtime(thresholdedidxs)     =time(linearmidxs);
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

peaks.plocs        =plocs;
peaks.ptimes       =ptimes;
peaks.pproms       =pproms;
peaks.pheights     =pheights;
peaks.mlocs        =mlocs;
peaks.mtimes       =mtimes;
peaks.pmins        =pmins;
peaks.normproms    =pproms/median(pproms,'all','omitnan');               % single-fiber and session normalized data
peaks.normpheights =pheights/median(pheights,'all','omitnan');           % single-fiber and session normalized data