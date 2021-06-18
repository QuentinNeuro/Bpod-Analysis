Trials=350:356;
showMeThisTrial=[];
thisYlabel='DF/Fo (%)';
thisCh=3;
thisChName={'Photo_470','Photo_470b'};
showEvents=1;
showRun=1;
showPup=1;
showTrialTag=1;
showUR=0;
limY1=[];
limY2=[];
limYUR=[];
limX1=[0 100];
thistype='type_1';
%% Ini
RewState=Analysis.Parameters.StateOfOutcome;
CueState=Analysis.Parameters.StateOfCue;

testch=size(Analysis.Parameters.PhotoCh,2)==2;
testwheel=Analysis.Parameters.Wheel;
testpup=Analysis.Parameters.Pupillometry;
Fluo=[];
Fluo2=[];
Wheel=[];
Licks=[];
Pupil=[];
TrialTag=NaN(2,length(Trials));
RewTag=NaN(1,length(Trials));
CueTag=NaN(1,length(Trials));
%% Loop
for i=1:length(Trials)
    thisTime=(0:length(Analysis.Core.Photometry{1,Trials(i)}{1,1})-1)/20;
    % Licks
    thisLicks=Analysis.Core.Licks{1,Trials(i)};
    Licks=[Licks thisLicks(thisLicks<=thisTime(end))+length(Fluo)/20];
    % Events
    if showTrialTag
    TrialTag(1,i)=length(Fluo)/20;
    if Analysis.Filters.Reward(Trials(i))
        RewTag(i)=Analysis.Core.States{1,i}.(RewState)(1)+length(Fluo)/20;
    end
    if ~Analysis.Filters.Uncued(Trials(i))
        CueTag(i)=Analysis.Core.States{1,i}.(CueState)(1)+length(Fluo)/20;
    end
    end
    % Photometry
    if thisCh==3
        Fluo=[Fluo ; Analysis.Core.Photometry{1,Trials(i)}{1,1}];
        if testch
            Fluo2=[Fluo2 ; Analysis.Core.Photometry{1,Trials(i)}{2,1}];
        end
    else
        Fluo=[Fluo ; Analysis.Core.Photometry{1,Trials(i)}{thisCh,1}];
    end
    % Running
    if testwheel   
    Wheel=[Wheel ; diff(Analysis.Core.Wheel{1,Trials(i)},1) ; NaN];
    end
    % Pupil
    if testpup
        Pupil=[Pupil Analysis.Core.PupSmooth{1,Trials(i)}(1:length(thisTime))];
    end
    TrialTag(2,i)=Fluo(end-length(thisTime)+1);
end
Time=(0:length(Fluo)-1)/20;
% TimeFromTS=Analysis.Core.TrialStartTS(Trials(end)+1)-Analysis.Core.TrialStartTS(Trials(1));
%% DFF
% FluoSort=sort(Fluo);
% Fluo10Index=ceil(length(Fluo)*0.1);
% FluoBase=mean(FluoSort(1:Fluo10Index));
FluoBase=nanmean(Fluo(20:40));
FluoStd=std(Fluo(1:50));
FluoDFF=100*(Fluo-FluoBase)/FluoBase;
% FluoDFF=(Fluo-FluoBase)/FluoStd;
if testch
    Fluo2Base=nanmean(Fluo2(20:40));
    Fluo2DFF=100*(Fluo2-Fluo2Base)/Fluo2Base;
end
if showTrialTag
TrialTag(2,:)=100*(TrialTag(2,:)-FluoBase)/FluoBase;
end
MaxFluo=ceil(max(FluoDFF));
%% Licks
LicksY=MaxFluo*ones(1,length(Licks));
CueY=(MaxFluo+1)*ones(1,length(Trials));
RewY=(MaxFluo+1.1)*ones(1,length(Trials));
%% Wheel
if testwheel 
WheelA=abs(Wheel);
WheelB=zeros(length(WheelA),1);
WheelB(WheelA>0.001)=1;
end
%% Pupil
if testpup
PupBase=nanmean(Pupil(20:40));
Pupil=100*(Pupil-PupBase)/PupBase;
end

%% Show me this Trial
if ~isempty(showMeThisTrial)
    thisFluo=Analysis.Core.Photometry{1,showMeThisTrial}{thisCh,1};
    thisFluoDFF=100*(thisFluo-FluoBase)/FluoBase;
    thisWheel=diff(Analysis.Core.Wheel{1,showMeThisTrial},1);
    thisLicks=Analysis.Core.Licks{1,showMeThisTrial};
    thisTime=(0:length(thisFluo)-1)/20;
    thisLicks=thisLicks(thisLicks<=thisTime(end));
    thisRew=NaN;
    thisCue=NaN;
    % Events
    if Analysis.Filters.Reward(Trials(i))
        thisRew=Analysis.Core.States{1,showMeThisTrial}.(RewState)(1);
    end
    if ~Analysis.Filters.Uncued(Trials(i))
        thisCue=Analysis.Core.States{1,showMeThisTrial}.(CueState)(1);
    end
end

%% Uncued Reward
if thisCh==3
    thisCh=1;
end
thisFluoRew=Analysis.(thistype).(thisChName{thisCh}).DFF;
thisFluoRew_Time=Analysis.(thistype).(thisChName{thisCh}).Time;
thisFluoRew_AVG=Analysis.(thistype).(thisChName{thisCh}).DFFAVG;

%% Plot
figure()
%% Show concatenated trials
subplot(1,4,[1 2])
hold on
title(Analysis.Parameters.Animal);
if showTrialTag
plot(TrialTag(1,:),TrialTag(2,:),'xr')
end
% Fluo
plot(Time,FluoDFF,'-k')
if testch
    plot(Time,Fluo2DFF,'-b')
end
% Events
if showEvents
plot(Licks,LicksY,'vb')
plot(CueTag,CueY,'sr')
plot(RewTag,RewY,'sb')
end

% Run
if showRun && testwheel
plot(Time,WheelA,'-g');
end
% Pupil
if showPup && testpup
    plot(Time,Pupil,'-r')
end
% Axis
if ~isempty(limY1)
    ylim(limY1)
end
xlabel('Time (s)'); ylabel(thisYlabel);
xlim(limX1);
% legend(sprintf('Total time from trial %.0f to %.0f : %.2f sec',Trials(1),Trials(end),TimeFromTS));
%% Show one trial
if ~isempty(showMeThisTrial)
subplot(1,4,3)
hold on
plot(thisTime,thisFluoDFF,'-k')
% Events
if showEvents
plot(thisLicks,max(thisFluo)*ones(length(thisLicks),1),'vb')
plot(thisCue,max(thisFluo)+0.1,'sr')
plot(thisRew,max(thisFluo)+0.2,'sb')
end
% Axis
xlabel('Time (s)'); ylabel(thisYlabel);
legend(sprintf('Trial %.0f',showMeThisTrial));
if ~isempty(limY2)
    ylim(limY2)
end
end
%% Show average reward response
if showUR
subplot(1,4,4)
title('Uncued Reward')
hold on
plot(thisFluoRew_Time(1,:),thisFluoRew(1:20,:),'-k');
plot(thisFluoRew_Time(1,:),thisFluoRew_AVG,'-r');
% Axis
xlim([-1 2]);
xlabel('Time from reward (s)'); ylabel(thisYlabel);
if ~isempty(limYUR)
    ylim(limYUR)
end
end
