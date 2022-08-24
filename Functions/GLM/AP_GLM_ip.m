xglm=[];
yglm=[];

thisTrial=2;
thisPhoto='Photo_470';

time=Analysis.AllData.(thisPhoto).Time(thisTrial,:);
fluo=Analysis.AllData.(thisPhoto).DFF(thisTrial,:);
wheel=Analysis.AllData.Wheel.Distance(thisTrial,:);
pupil=Analysis.AllData.Pupil.PupilDPP(thisTrial,:);

licks=zeros(1,length(fluo));
events=Analysis.AllData.Licks.Events{1,thisTrial};
for thisL=events
    licks(find(time>thisL,1))=1;
end
    
cue=zeros(1,length(fluo));
cue(time>Analysis.AllData.Time.Cue(thisTrial,1) & time<Analysis.AllData.Time.Cue(thisTrial,2))=1;
outcome=zeros(1,length(fluo));
outcome(time>Analysis.AllData.Time.Outcome(thisTrial,1) & time<Analysis.AllData.Time.Outcome(thisTrial,2))=1;



xglm=[wheel;pupil;licks;cue;outcome]';

yglm=fluo';

[B,DEV,STATS]=glmfit(xglm,yglm);
