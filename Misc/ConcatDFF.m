%% Parameters
nboftrials=100;
IndTrialFit=0;
opol = 6;
colors='br';
counter=0;
figure()
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    counter=counter+1;
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
%% ini
thisData=Analysis.AllData.(thisChStruct).DFF(1,:);
thisNaN=~isnan(thisData);
AllData=thisData(thisNaN);
%% concat
for thistrial=2:nboftrials
   thisData=Analysis.AllData.(thisChStruct).DFF(thistrial,:);
   thisNaN=~isnan(thisData);
   thisData=thisData(thisNaN);
   if IndTrialFit
    thisTime=1:length(thisData);
    [p,s,mu] = polyfit(thisTime,thisData,opol);
    f_y = polyval(p,thisTime,[],mu);
    thisData=thisData-f_y;
   end
   thisData=thisData+thisData(1)+AllData(end);
   AllData=[AllData thisData];
end
t=(1:length(AllData))/LauncherParam.NewSamplingRate;
%% Exp fit
fexp = fit(t',AllData','exp1');
[p,s,mu] = polyfit(t,AllData,opol);
f_y = polyval(p,t,[],mu);
AllData_dtr=AllData-f_y;
%% figure
subplot(2,1,1)
hold on
plot(AllData,colors(counter));
plot(f_y);
subplot(2,1,2)
plot(AllData_dtr,colors(counter));
hold on
end


%% save excel
% thisexcel=[t' AllData'];
% cd 'C:\Users\quent\Desktop\Data Local\Photometry\Test'
% 
% save('youhouACh.txt','thisexcel','-ascii','-tabs')


% threshold=0.3
% AllData_diff=diff(AllData_dtr);
% AllData_detect=AllData_diff>threshold
% AllData_detect_Artifact=AllData_diff<1;
% AllData_detect=AllData_detect.*AllData_detect_Artifact
% AllData_detect_point=AllData_dtr(1:end-1).*AllData_detect;
% figure()
% plot(AllData_dtr);
% hold on
% plot(AllData_detect_point,'or')
% findpeaks(AllData_dtr);