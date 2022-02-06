thisC=8;
warmUp=50;
thisCell=sprintf('cell%.0d',thisC);

nCells=Analysis.Parameters.AOD.nCells;
nTrials=Analysis.Core.nTrials;
sampRate=Analysis.Parameters.AOD.sampRateRec;
thisC_Index=thisC:nCells:nCells*nTrials;


data=Analysis.AllData.AOD.(thisCell).Data;
vecData=reshape(data,size(data,1)*size(data,2),1);

% vecData=smooth(vecData);
% vecData=100*(vecData-mean(vecData(200:500)))/mean(vecData(200:500));
time=1/sampRate:1/sampRate:length(vecData)/sampRate;
figure()
plot(time,vecData)