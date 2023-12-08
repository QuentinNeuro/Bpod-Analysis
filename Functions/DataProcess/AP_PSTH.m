function [timeTW,dataTW]=AP_PSTH(data,tw,timeToZero,sampRate)

if size(data,2)==1
    data=data';
end

%% Time window
dt=1/sampRate;
expectedSizeTW=diff(tw)*sampRate;
time=[0:1:length(data)-1] * dt; 
timeZ=time-timeToZero;
timeTW=linspace(tw(1),tw(2),expectedSizeTW);
idxZeroT=find(timeZ>=0,1);
idxZeroTW=find(timeTW>=0,1);

%% Padding Parameters
dataBef=data(1:(idxZeroT-1));
dataAft=data(idxZeroT:end);
sizeDBef=length(dataBef);
sizeDAft=length(dataAft);

sizeTBef=length(timeTW(1:(idxZeroTW-1)));
sizeTAft=length(timeTW(idxZeroTW:end));

%% Padding data
dataTW=nan(size(timeTW));
if sizeDBef>=sizeTBef
    dataTW(1:idxZeroTW-1)=dataBef(end-sizeTBef+1:end);
else
    dataTW(idxZeroTW-sizeDBef:idxZeroTW-1)=dataBef;
end
if sizeDAft>=sizeTAft
    dataTW(idxZeroTW:end)=dataAft(1:sizeTAft);
else
    dataTW(idxZeroTW:idxZeroTW+sizeDAft-1)=dataAft(1:sizeDAft);
end
end







% if size(data,2)==1
%     data=data';
% end
% %% Parameters
% % Time window
% dt=1/sampRate;
% expectedSizeTW=diff(tw)*sampRate;
% time=[0:1:length(data)-1] * dt; 
% timeZ=time-timeToZero;
% timeTW=linspace(tw(1),tw(2),expectedSizeTW);
% 
% %% timeWindow
% % Finding the time window index
% timeZ_IO=false(size(timeZ));
% timeTW_IO=false(size(timeTW));
% timeZ_IO(timeZ>=tw(1) & timeZ<=tw(2))=true;
% timeZinTW=timeZ(timeZ_IO);
% timeTW_IO(timeTW>=timeZinTW(1) & timeTW<=timeZinTW(end))=true;
% % Extract corresponding data
% dataTW=data(timeZ_IO);
% % padding
% k=find(timeTW_IO);
% padStart=k(1)-1;
% padStop=length(timeTW_IO)-k(end);
% dataTW=[nan(1,padStart) dataTW nan(1,padStop)];
% % adjust length to expected length
% switch length(dataTW)-length(timeTW)
%     case 1
%         dataTW=dataTW(1:end-1);
%     case 2
%         dataTW=dataTW(2:end-1);
% end
% end