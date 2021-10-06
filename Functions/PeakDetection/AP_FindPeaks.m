function peaksStruct=AP_FindPeaks(data,time,trhesholdProm,tresholdMultiplier)
%  AP_FIND_PEAKS locates peaks looking leftwards only.
%  Function first utilizes built-in findpeaks to locate all peaks 
%  without thresholding. After localizing peaks, only prominent peaks 
%  (relative to left-sided signal search) will remain, thresholded by
%  a minimum prominence of input minprom (percentile peak comparitor)
%  multiplied by input multiplier (transformed to %). 
%  data         trialized time fluo matrix
%  minprom:     minimum "prominence" of peak to be recorded (percentile)
%  multiplier:  multiplier for thresholding peaks; transformed to %

%% Arguments
if nargin  < 3
    multiplier = 50;
end

if nargin  < 2
    minprom = 95;
end

if nargin  < 1
    disp('No photodata inputted.')
end

%% find all peak prominences + find peak threshold
[pks,locs]    =arrayfun(@(i) findpeaks(data(i,:)), (1:size(data,1)).',    ...
                            'UniformOutput', false);
lengths       =arrayfun(@(i) numel(pks{i}), 1:size(pks,1));
maxPeaks      =max(lengths);
func          =@(x) [x, nan(1,maxPeaks{f,ss}-numel(x))];                % NaN pad
pks           =cell2mat(cellfun(func,pks,'UniformOutput',false));       % transform to matrix    
locs          =cell2mat(cellfun(func,locs,'UniformOutput',false));
ipeaks        =1;
lpeakloc      =ones(size(M,1),1);           
pproms        =nan(size(pks,1),size(pks,2));                
while ipeaks         <=maxPeaks
    cpeak             =pks(:,ipeaks);                                   % trial peak heights
    cpeakloc          =locs(:,ipeaks);                                  % trial peak locs
    nanidxs           =isnan(cpeak);
    cpeak(nanidxs)    =0;                                               % remove nans
    cpeakloc(nanidxs) =lpeakloc(nanidxs);                               % remove nans
    Mslice            =arrayfun(@(i) data(i,lpeakloc(i):cpeakloc(i)),  ...
                               (1:size(data,1)).','UniformOutput',     ...
                                false);
    lengths           =arrayfun(@(i) numel(Mslice{i}),              ...
                                1:size(Mslice,1));             
    maxLength         =max(lengths);
    func              =@(i) [i, nan(1,maxLength-numel(i))];  
    Mslice            =cell2mat(cellfun(func,Mslice,'UniformOutput',false));
    absmin            =min(Mslice,[],2,'omitnan');                      % minima for proms
    absmin(nanidxs)   =0;                                               % ensure no peaks at nans
    dpeak             =cpeak-absmin;                                    % "proms"
    lpeakloc          =cpeakloc;                                        % update peak
    nanidxs           =~dpeak;
    dpeak(nanidxs)    =nan;
    pproms(:,ipeaks)  =dpeak;
    ipeaks=ipeaks+1;
end
perctl                  =prctile(pproms,minprom,'all');
thresh                  =perctl*multiplier;
unfilteredpproms        =pproms;

%% peak detection + peak refinement
    ipeaks       =1;
    lpeakloc     =ones(size(data,1),1);           
    pproms       =nan(size(pks,1),size(pks,2));
    plocs        =nan(size(pks,1),size(pks,2));
    ptimes       =nan(size(pks,1),size(pks,2));
    pproms       =nan(size(pks,1),size(pks,2));
    pheights     =nan(size(pks,1),size(pks,2));
    mlocs        =nan(size(pks,1),size(pks,2));
    mtimes       =nan(size(pks,1),size(pks,2));
    pmins        =nan(size(pks,1),size(pks,2));
    while ipeaks         <=maxPeaks
        cpeak             =pks(:,ipeaks);                                   % trial peak heights
        cpeakloc          =locs(:,ipeaks);                                  % trial peak locs
        nanidxs           =isnan(cpeak);
        cpeak(nanidxs)    =0;                                               % remove nans
        cpeakloc(nanidxs) =lpeakloc(nanidxs);                               % remove nans
        Mslice            =arrayfun(@(i) data(i,lpeakloc(i):cpeakloc(i)),  ...
                                   (1:size(data,1)).','UniformOutput',     ...
                                    false);
        lengths           =arrayfun(@(i) numel(Mslice{i}),              ...
                                    1:size(Mslice,1));             
        maxLength         =max(lengths);
        func              =@(i) [i, nan(1,maxLength-numel(i))];  
        Mslice            =cell2mat(cellfun(func,Mslice,'UniformOutput',false));
        [absmin,minloc]   =min(Mslice,[],2,'omitnan');                      % minima for proms
        minloc            =lpeakloc+minloc-1;
        absmin(nanidxs)   =0;                                               % ensure no peaks at nans
        dpeak             =cpeak-absmin;                                    % "proms"
        lpeakloc          =cpeakloc;                                        % update peak
        nanidxs           =~dpeak;
        dpeak(nanidxs)    =nan;
        thresholdedidxs   =(dpeak>=thresh{f,ss});
        if any(thresholdedidxs)
        thresholdedtrials          =find(thresholdedidxs);
        thresholdedplocs           =cpeakloc(thresholdedidxs);
        linearpidxs                =sub2ind(size(M),thresholdedtrials', ...
                                           (thresholdedplocs'));
        cpeaktime                  =nan(size(pks(:,ipeaks)));
        cpeaktime(thresholdedidxs) =time(linearpidxs);
        thresholdedmlocs           =minloc(thresholdedidxs);
        linearmidxs                =sub2ind(size(M),thresholdedtrials', ...
                                           (thresholdedmlocs'));
        mtime                      =nan(size(pks(:,ipeaks)));
        mtime(thresholdedidxs)     =time(linearmidxs);
        cpeakloc(~thresholdedidxs) =nan;
        dpeak(~thresholdedidxs)    =nan;
        cpeak(~thresholdedidxs)    =nan;
        minloc(~thresholdedidxs)   =nan;
        absmin(~thresholdedidxs)   =nan;
        ptimes(:,ipeaks)           =cpeaktime;
        plocs(:,ipeaks)            =cpeakloc;
        pproms(:,ipeaks)           =dpeak;
        pheights(:,ipeaks)         =cpeak;
        mlocs(:,ipeaks)            =minloc;
        mtimes(:,ipeaks)           =mtime;
        pmins(:,ipeaks)            =absmin;
        end
        ipeaks=ipeaks+1;
    end
    allplocs        =plocs;
    allptimes       =ptimes;
    allpproms       =pproms;
    allpheights     =pheights;
    allmlocs        =mlocs;
    allmtimes       =mtimes;
    allpmins        =pmins;

end