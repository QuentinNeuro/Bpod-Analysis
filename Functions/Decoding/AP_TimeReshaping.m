function [ReshapedTime,ReshapedData]=AP_TimeReshaping(Analysis,Time,Data,SampRate,TimeBoundaries)

%% Input check
if nargin==4
    try
        TimeBoundaries=Analysis.Parameters.ReshapedTime;
    catch
        disp('Error in AP_TimeReshaping /n');
        disp('Cannot find parameters for reshaping data with new time boundaries /n');
        return
    end
end
% if ~size(Time)==[1 2] && ~size(Time)==[2 1]
%     disp('Error in AP_TimeReshaping /n');
%     disp('Time array should be a one dimension vector');
%         return
% end
% if size(Data,1)>size(Data,2)
%     Data=Data';
% end
    
%% Reshape the data
Data=Data(Time>=TimeBoundaries(1) & Time<=TimeBoundaries(2));
Time=Time(Time>=TimeBoundaries(1) & Time<=TimeBoundaries(2));

%% Output the data with the expected size
ExpectedSize=diff(TimeBoundaries)*SampRate-1;
ReshapedData=NaN(ExpectedSize,1);
ReshapedTime=NaN(ExpectedSize,1);
if length(Data)>=ExpectedSize
    ReshapedTime=Time(1:ExpectedSize);
    ReshapedData=Data(1:ExpectedSize);
else
    ReshapedTime(1:length(Data))=Time;
    ReshapedData(1:length(Data))=Data;
    disp('Warning in AP_TimeReshaping /n');
    disp('Might have NaNs in data /n');
end 
end