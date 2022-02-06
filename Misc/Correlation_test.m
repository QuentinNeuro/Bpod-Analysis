v=Analysis.Core.Photometry{1, 2}{2, 1};
a=Analysis.Core.Photometry{1, 2}{1, 1};
[cR,lagsR] = xcorr(v,a,'normalized');
[cV,lagsV] = xcov(v,a,'normalized');
[R,P] = corrcoef(a,v);
figure()
subplot(1,2,1)
stem(lagsR,cR)
subplot(1,2,2)
stem(lagsV,cV);

figure()