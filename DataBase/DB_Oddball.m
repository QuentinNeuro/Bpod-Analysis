Oddball.FileList={...
'VIP-GCaMP6f-31_Oddball_Aug02_2017'...
'VIP-GCaMP6f-36_Oddball_Aug02_2017'...
'VIP-GCaMP6f-37_Oddball_Aug02_2017'...
'VIP-GCaMP6f-38_Oddball_Aug02_2017'...
'VIP-GCaMP6f-41_Oddball_Sep06_2017'...
'VIP-GCaMP6f-42_Oddball_Aug02_2017'...
'VIP-GCaMP6f-43_Oddball_Sep06_2017'...
'VIP-GCaMP6f-44_Oddball_Aug02_2017'...
'VIP-GCaMP6f-45_Oddball_Sep06_2017'...
'VIP-GCaMP6f-46_Oddball_Sep06_2017'...
'VIP-GCaMP6f-61_Oddball_Aug07_2018'...
'VIP-GCaMP6f-62_Oddball_Aug07_2018'...
'VIP-GCaMP6f-63_Oddball_Aug07_2018'};

% Removed or to be removed
%'VIP-GCaMP6f-32_Oddball_Aug02_2017' NO
%'VIP-GCaMP6f-36_Oddball_Sep01_2017' OK
%'VIP-GCaMP6f-36_Oddball_Sep01_2017' NO
%'VIP-GCaMP6f-37_Oddball_Aug08_2017' OK
%'VIP-GCaMP6f-38_Oddball_Sep01_2017' OK
%'VIP-GCaMP6f-41_Oddball_Sep06_2017' OK
%'VIP-GCaMP6f-42_Oddball_Aug02_2017'...
%'VIP-GCaMP6f-42_Oddball_Sep06_2017'...
%'VIP-GCaMP6f-44_Oddball_Sep06_2017' OK
%'VIP-GCaMP6f-45_Oddball_Sep06_2017'...
%'VIP-GCaMP6f-46_Oddball_Sep06_2017'

for i=1:size(Oddball.FileList,2)
    thisSession=Oddball.FileList{i}
    load([thisSession '_OddBall.mat']);
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh})); 
        Oddball.(thisChStruct).ratioEO(1,i)=Analysis.Ratio.(thisChStruct).ratioEO;
        Oddball.(thisChStruct).ratioLO(1,i)=Analysis.Ratio.(thisChStruct).ratioLO;
    end
    load([thisSession '_Ctl-0.3.mat']);
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh})); 
        Oddball.(thisChStruct).ratioEO(2,i)=Analysis.Ratio.(thisChStruct).ratioEO;
        Oddball.(thisChStruct).ratioLO(2,i)=Analysis.Ratio.(thisChStruct).ratioLO;
    end
        load([thisSession '_Ctl-0.5.mat']);
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh})); 
        Oddball.(thisChStruct).ratioEO(3,i)=Analysis.Ratio.(thisChStruct).ratioEO;
        Oddball.(thisChStruct).ratioLO(3,i)=Analysis.Ratio.(thisChStruct).ratioLO;
    end    
end

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh})); 
    Oddball.(thisChStruct).NormratioEO=Oddball.(thisChStruct).ratioEO./Oddball.(thisChStruct).ratioEO(3,:);
    Oddball.(thisChStruct).NormratioLO=Oddball.(thisChStruct).ratioLO./Oddball.(thisChStruct).ratioLO(3,:);
end  


%% Figure
theseticks=['Oddball'; 'Ctl-0.3'; 'Ctl-0.5'];
limx=[0.5 3.5];
limy1=[0.5 2];

figure()
subplot(2,3,1)
hold on
title('Auditory Cortex - Early to Odd')
plot(Oddball.Photo_470.NormratioEO)
ylabel('Norm (O1+O2)/(E1+E2)')
ylim(limy1)
xticklabels(theseticks)
xtickangle(30)
xlim(limx);

subplot(2,3,2)
hold on
title('Late to Odd')
plot(Oddball.Photo_470.NormratioLO)
ylabel('Norm (O1+O2)/(L1+L2)')
ylim(limy1)
xticklabels(theseticks)
xtickangle(30)
xlim(limx);

subplot(2,3,3)
title('Early to Odd')
boxplot(Oddball.Photo_470.ratioLO')
ylabel('(O1+O2)/(E1+E2)')
ylim(limy1)
xticklabels(theseticks)
xtickangle(30)
xlim(limx);

subplot(2,3,4)
hold on
title('mPFC - Early to Odd')
plot(Oddball.Photo_470b.NormratioEO)
ylabel('Norm (O1+O2)/(E1+E2)')
xticklabels(theseticks)
xtickangle(30)
xlim(limx);


subplot(2,3,5)
hold on
title('Late to Odd')
plot(Oddball.Photo_470b.NormratioLO)
ylabel('Norm (O1+O2)/(L1+L2)')
xticklabels(theseticks)
xtickangle(30)
xlim(limx);

subplot(2,3,6)
boxplot(Oddball.Photo_470b.ratioEO')
ylabel('(O1+O2)/(E1+E2)')
xticklabels(theseticks)
xtickangle(30)
xlim(limx);
