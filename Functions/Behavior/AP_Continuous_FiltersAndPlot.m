% function Analysis=AP_Continuous_FiltersAndPlot(Analysis)
thisTrial=1;

decFac=100;

wheelThresh=0.2;
wheelMov=1;
wheelMult=1;


nbOfTrials=Analysis.AllData.nTrials;

counterTrial=0;

thisWheel=Analysis.AllData.Wheel.Distance(thisTrial,:);
thisWheelT=Analysis.AllData.Wheel.Time(thisTrial,:);
thisFluo=Analysis.AllData.Photo_470.DFF(thisTrial,:);
thisFluoT=Analysis.AllData.Photo_470.Time(thisTrial,:);

wheel=thisWheel(~isnan(thisWheel));
wheelT=thisWheelT(~isnan(thisWheel));
fluo=thisFluo(~isnan(thisFluo));
fluoT=thisFluoT(~isnan(thisFluo));

wheelD=decimate(wheel,decFac,'fir');
wheelDT=decimate(wheelT,decFac);
fluoD=decimate(fluo,decFac);
fluoDT=decimate(fluoT,decFac);


figure()
subplot(3,2,[1 2]); hold on;
plot(fluoDT,fluoD); ylabel('DFF'); xlabel('Time');
yyaxis right
plot(wheelDT,wheelD); ylabel('Distance');

subplot(3,2,3); hold on;
scatter(fluoD,wheelD);
xlabel('DFF'); ylabel('Distance');




% for thisT=1:nbOfTrials
% 
% subplot(nbOfTrials,3,[1 2]+counterTrial); hold on;
% 
% thisChStruct1=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{1}));
% thisY_Fluo1=decimate(Analysis.AllData.(thisChStruct1).DFF(thisT,:),decFac);
% thisX_Fluo1=decimate(Analysis.AllData.(thisChStruct1).Time(thisT,:),decFac);
% plot(thisX_Fluo1,thisY_Fluo1)
% 
% % if length(Analysis.Parameters.PhotoCh)==2
% %     thisChStruct2=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{2}));
% %     thisY_Fluo2=Analysis.AllData.(thisChStruct2).DFF(thisT,:);
% %     thisX_Fluo2=Analysis.AllData.(thisChStruct2).Time(thisT,:);
% %     plot(thisX_Fluo2,thisY_Fluo2);
% % end
% 
% if Analysis.Parameters.Wheel
%     yyaxis right; hold on;
%     thisY_Wheel(thisT,:)=diff(decimate(Analysis.AllData.Wheel.Distance(thisT,:),decFac));
%     thisY_Wheel(thisT,thisY_Wheel(thisT,:)<0)=0;
%     thisY_Wheel(thisT,:)=movmean(thisY_Wheel(thisT,:),5);
%     
%     thisY_WheelIO(thisT,:)=zeros(1,length(thisY_Wheel(thisT,:)));
%     thisY_WheelIO(thisT,thisY_Wheel(thisT,:)>wheelThresh)=max(thisY_Wheel(thisT,:))
%     thisX_Wheel=decimate(Analysis.AllData.Wheel.Time(thisT,1:end-1),decFac);
%     plot(thisX_Wheel,thisY_Wheel(thisT,:));
%     plot(thisX_Wheel,thisY_WheelIO(thisT,:));
% end
% % if Analysis.Parameters.Pupillometry
% % yyaxis right hold on
% % thisData=Analysis.AllData.Pupil.Data
% % thisTime=Analysis.AllData.Pupil.
% % end
% counterTrial=counterTrial+3;
% end
% 
% 
% thisFluo1=Analysis.AllData.(thisChStruct1).DFF(:,1:end-1);
% thisFluo1=thisFluo1(:);
% if length(Analysis.Parameters.PhotoCh)==2
%     thisFluo2=Analysis.AllData.(thisChStruct2).DFF(:,1:end-1);
%     thisFluo2=thisFluo2(:);
%     subplot(nbOfTrials,3,9)
%     scatter(thisFluo1,thisFluo2);
% end
% 
% if Analysis.Parameters.Wheel
%     thisWheel=thisY_Wheel(:);
%     thisWheelIO=ones(length(thisWheel),1);
%     thisWheelIO(thisWheel>0.01)=2;
%     subplot(nbOfTrials,3,12)
%     scatter(thisFluo1,thisWheel,[],thisWheelIO);
% %     if length(Analysis.Parameters.PhotoCh)==2
% %         scatter(thisFluo2,thisWheel);
% %     end
% end
% 
% 
% % end