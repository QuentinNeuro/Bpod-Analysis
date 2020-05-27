function [TimeNew,DataNew]=AP_TimeReshaping(DataOG,TW,TZ,SR)

%% Initialize expected arrays
ExpectedSize=diff(TW)*SR+1;
DataNew=NaN(1,ExpectedSize);
TimeNew=TW(1):1/SR:TW(2);

if ~isempty(DataOG)
%% Create Time Array Matching Data
DataSize=length(DataOG);
Time=(1/SR:1/SR:(1/SR*DataSize))-TZ;
Index0=find(~TimeNew);
%% Reshape the data
DataBegin=DataOG(Time>=TW(1) & Time<=0);
DataEnd=DataOG(Time>=0 & Time<=TW(2));
if (Index0-length(DataBegin))==0
    IndexBegin=[1 Index0];
    IndexEnd=[Index0 Index0+length(DataEnd)-1];
else
    IndexBegin=[Index0-length(DataBegin) Index0-1];
    IndexEnd=[Index0 Index0+length(DataEnd)-1];
end    
DataNew(IndexBegin(1):IndexBegin(2))=DataBegin;
DataNew(IndexEnd(1):IndexEnd(2))=DataEnd;

% DataNew(Index0-length(DataBegin):Index0-1)=DataBegin;
% DataNew(Index0:Index0+length(DataEnd)-1)=DataEnd;

if length(DataNew)>length(TimeNew)
    DataNew=DataNew(1:length(TimeNew));
end
end
end