% [Analysis,thisFilter]=A_FilterMeta(Analysis,'rewlick',{'Reward','LicksOutcome'});
% Analysis=AP_DataSort_Filter(Analysis,'rewlick',thisFilter);

%% Plot Paramaters
thistype='Uncued_Reward';
Feature='Photo_470b';
trialsnb=15;
step=5;

time=Analysis.(thistype).(Feature).Time(1,:);
steps=0:step:trialsnb*step-1;
DFF=Analysis.(thistype).(Feature).DFF(1:trialsnb,:);
steppedDFF=DFF+steps';
steppedDFFAVG=Analysis.(thistype).(Feature).DFFAVG+trialsnb*step;

%% Figure
figure('Name','Single traces','numbertitle','off');
plot(time,steppedDFF,'-k'); hold on
plot(time,steppedDFFAVG,'-r');
labelx='Time (sec)';   
labely='DF/F';
set(gca,'XLim',Analysis.Properties.PlotEdges);

