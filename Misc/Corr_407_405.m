%% 405 vs 470 plot

thistype='AllData';
%% example trace
thistrial=10;
startpoint=10;
photo470=Analysis.(thistype).Photo_470.DFF(thistrial,startpoint:end);
photo405=Analysis.(thistype).Photo_405.DFF(thistrial,startpoint:end);

%% remove nan and reshape data
sizephoto470=size(Analysis.(thistype).Photo_470.DFF);
sizephoto405=size(Analysis.(thistype).Photo_405.DFF);
if sizephoto470~=sizephoto405
    disp('470 and 405 data do not have the same size')
end
totallength=sizephoto470(1)*sizephoto470(2);
reshapedphoto470=reshape(Analysis.(thistype).Photo_470.DFF,[1,totallength]);
reshapedphoto405=reshape(Analysis.(thistype).Photo_405.DFF,[1,totallength]);
noNaNphoto470=reshapedphoto470(~isnan(reshapedphoto470));
noNaNphoto405=reshapedphoto405(~isnan(reshapedphoto405));
if size(noNaNphoto470)~=size(noNaNphoto405)
    disp('470 and 405 data do not have the same NaN numbers')
end

model=fitlm(noNaNphoto470,noNaNphoto405);
TempLgd={'TA','TB'};
thisleg{1}=sprintf('y=%.2f*x+%.2f',model.Coefficients.Estimate(2),model.Coefficients.Estimate(1));
thisleg{2}=sprintf('R2=%.2f p-val=%.5f',model.Rsquared.Ordinary,model.Coefficients.pValue(2));

figure()
subplot(1,2,1); hold on;
plot(photo470,'-b');
plot(photo405,'-k');
subplot(1,2,2); hold on;
plot(noNaNphoto470,model.Fitted,'-r');
plot(noNaNphoto470,noNaNphoto405,'ok','markerSize',5);
lgd=legend(TempLgd,'Location','northeast','FontSize',8);
anno=annotation('textbox',lgd.Position,'String',thisleg);
anno.Color='red'; legend('off');