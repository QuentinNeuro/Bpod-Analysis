thistype='Uncued_Reward';
thischannel='Photo_470';
nboftrials=10;
deltaY=10;
scaleupfirst=-nboftrials*deltaY+nboftrials:deltaY:0;
scaleuplast=deltaY:deltaY:deltaY*nboftrials;

AVG_470=Analysis.(thistype).(thischannel).DFFAVG
Time_470=Analysis.(thistype).(thischannel).Time(1,:);
First_470=Analysis.(thistype).(thischannel).DFF(1:nboftrials,:)'+scaleupfirst;
Last_470=Analysis.(thistype).(thischannel).DFF(51:50+nboftrials,:)'+scaleuplast;

figure()
subplot(3,1,[1 2]); hold on;
plot(Time_470,First_470,'-k');
plot(Time_470,Last_470,'-b');
subplot(3,1,3);
plot(Time_470,AVG_470,'-r');

