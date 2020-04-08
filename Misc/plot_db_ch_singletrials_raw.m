%Analysis.AllData.nTrials
thistypeNb=[];
NbOfTrials=5;
if ~isempty(thistypeNb)
trialtypeNb=Analysis.AllData.TrialTypes==thistypeNb;
trialnb=find(trialtypeNb,NbOfTrials);
else
    trialnb=1:NbOfTrials;
end
DFF=0;
Zscore=1;
LimY=[];
SR=Analysis.Parameters.NidaqDecimatedSR;
Baseline=1:SR;
counter=1;

figure()
for i=trialnb
    thisPhoto1=Analysis.AllData.Raw{1,i}.Photometry{1,1};
    thisPhoto2=Analysis.AllData.Raw{1,i}.Photometry{1,2};
    thisDuration=length(thisPhoto1)/SR;
    thisTime=0:1/SR:thisDuration-1/SR;
    thisLicks=Analysis.AllData.Raw{1,i}.Lick;
    if DFF
        thisPhoto1=(thisPhoto1-mean(thisPhoto1(Baseline)))/mean(thisPhoto1(Baseline));
        thisPhoto2=(thisPhoto2-mean(thisPhoto2(Baseline)))/mean(thisPhoto2(Baseline));
    end
    if Zscore
        thisPhoto1=(thisPhoto1-mean(thisPhoto1(Baseline)))/std(thisPhoto1(Baseline));
        thisPhoto2=(thisPhoto2-mean(thisPhoto2(Baseline)))/std(thisPhoto2(Baseline));
    end
    thismax1=max(thisPhoto1);
    LicksY=ones(length(thisLicks),1)*(thismax1+1);
    subplot(NbOfTrials,1,counter)
    hold on
    title(sprintf('trial nb %.0d',i))
    yyaxis left
    plot(thisTime,thisPhoto1,'-k')
    plot(thisLicks,LicksY,'v')
    hold on
    yyaxis right
    plot(thisTime,thisPhoto2,'-b');
    counter=counter+1
end
