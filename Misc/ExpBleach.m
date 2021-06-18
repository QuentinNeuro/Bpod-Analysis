trials=[1 199];
Time1=2250:2350;
Time2=20250:20350;

thisBaseline=Analysis.AllData.Photo_470.Baseline(trials(1):trials(2))';
% thisBaseline=thisBaseline-min(thisBaseline);
thisTime=linspace(0,Analysis.Core.TrialStartTS(trials(2)+1)-Analysis.Core.TrialStartTS(trials(1)),length(thisBaseline));
f1 = fit(thisTime',thisBaseline,'exp1');
f2 = fit(thisTime',thisBaseline,'exp2');


AllData=[];
for i=trials(1):trials(2)
AllData=[AllData ; Analysis.Core.Photometry{1,i}{1,1}];
AllDataTime=(0:length(AllData)-1)/20;
end
% AllData=(AllData-mean(AllData(1:200)))/mean(AllData(1:200));

figure()
subplot(3,3,1);
plot(f1,thisTime,thisBaseline)
xlabel('Time');ylabel('Baseline');

subplot(3,3,2);
plot(f2,thisTime,thisBaseline)
title('double exp because it was late yesterday')
xlabel('Time');ylabel('Baseline');
legend off

subplot(3,3,3);
plot(f2,thisTime,thisBaseline,'Residuals')
xlabel('Time');ylabel('Baseline residual');
legend off

subplot(3,3,4)
plot(f2,AllDataTime,AllData);
ylabel('Fluorescence');
legend off

subplot(3,3,7)
plot(f2,AllDataTime,AllData,'-b','Residuals');
xlabel('Time');ylabel('Residual fluorescence');
legend off

subplot(3,3,5)
plot(f2,AllDataTime(Time1),AllData(Time1),'-b')
legend off;

subplot(3,3,8)
plot(f2,AllDataTime(Time1),AllData(Time1),'-b','Residuals')
legend off;

subplot(3,3,6)
plot(f2,AllDataTime(Time2),AllData(Time2),'-b')
xlabel('Time');
legend off
subplot(3,3,9)
plot(f2,AllDataTime(Time2),AllData(Time2),'-b','Residuals')
xlabel('Time');
legend off
