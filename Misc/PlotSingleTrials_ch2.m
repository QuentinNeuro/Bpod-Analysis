% [Analysis,thisFilter]=A_FilterMeta(Analysis,'rewlick',{'Reward','LicksOutcome'});
% Analysis=AP_DataSort_Filter(Analysis,'rewlick',thisFilter);

%% Plot Paramaters
thistype='type_1';
Feature1='Wheel';
Feature2='Photo_470b';
trialsnb=10;
step=10;
steps=0:step:trialsnb*step-1;
xstep=20;
xsteps=0:xstep:trialsnb*xstep-1;

figure('Name','DA - Uncued Reward','numbertitle','off');
subplot(2,4,1);



time=Analysis.(thistype).(Feature1).Time(1,:);
%% DFF1
DFF1=Analysis.(thistype).(Feature1).Distance(1:trialsnb,:);
steppedDFF1=DFF1+steps';
steppedDFF1AVG=Analysis.(thistype).(Feature1).DFFAVG+trialsnb*step;
DFF2=Analysis.(thistype).(Feature2).DFF(1:trialsnb,:);
steppedDFF2=DFF2+steps';
steppedDFF2AVG=Analysis.(thistype).(Feature2).DFFAVG+trialsnb*step;

xDFF=DFF1.*DFF2;
steppedxDFF=xDFF+xsteps';
%% Figure
figure('Name','DA - Uncued Reward','numbertitle','off');
subplot(2,4,1);
plot(time,steppedDFF1,'-k'); hold on
plot([0 0],[-5 step*trialsnb],'-r');
title('BLA')
set(gca,'XLim',Analysis.Properties.PlotEdges,'YLim',[-step step*trialsnb]);
subplot(1,2,2);
plot(time,steppedDFF1,'-r'); hold on
plot(time,steppedDFF2,'-k'); hold on
plot([0 0],[-5 step*trialsnb],'-r');
title('VS');
set(gca,'XLim',Analysis.Properties.PlotEdges,'YLim',[-step step*trialsnb]);