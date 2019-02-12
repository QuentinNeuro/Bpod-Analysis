function [LickData, Photo, Wheel]=AP_DataExtract(SessionData,Analysis,thisTrial)
%AP_DataExtract extracts licks timestamp, raw and normalized photometry value together with
%a time array of the trial 'thistrial' from the 'sessiondata' file. This
%function is using the parameters contained in the 'Analysis' structure
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Timing parameters
StateToZero=Analysis.Parameters.StateToZero;
StateZeroOffset=Analysis.Parameters.StateZeroOffset;
TimeToZero=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateToZero)(1);
if ~isempty(StateZeroOffset)
ZeroOffset=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateZeroOffset)(1);
end
%% Licks
LickPort=Analysis.Parameters.LickPort;
try
    LickData=SessionData.RawEvents.Trial{1,thisTrial}.Events.(LickPort);
catch
    LickData=NaN;  
end

%% FirstLick
if Analysis.Parameters.ZeroFirstLick
    LicksDuringZeroState  =LickData(LickData> TimeToZero & thislick < TimeToZero+1);
    if ~isempty(LicksDuringZeroState)
        TimeToZero   = LicksDuringZeroState(1);                                 
    end
end
LickData=LickData-TimeToZero;

%% Nidaq
if Analysis.Parameters.Photometry==1
% Parameters  
SampRate=Analysis.Parameters.NidaqSamplingRate;
SRDecimated=Analysis.Parameters.NidaqDecimatedSR;
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
Baseline=Analysis.Parameters.NidaqBaselinePoints;         %points with decimated SR
Duration=Analysis.Parameters.NidaqDuration;
ExpectedSize=Duration*SRDecimated;
% Time vector
Time=linspace(0,Duration,ExpectedSize)-TimeToZero;
% Data
Photo=cell(length(Analysis.Parameters.PhotoCh),1);
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    Data=NaN(ExpectedSize,1);
    if Analysis.Parameters.Modulation
        thisNidaqField=char(Analysis.Parameters.PhotoField{thisCh});
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoAmpField{thisCh}));
        if thisAmp~=0
        thisFreq=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoFreqField{thisCh}));
        switch Analysis.Parameters.recordedMod
            case 0
                thisModulation=AP_Modulation(Analysis,thisAmp,thisFreq);
            case 1
                thisModulation=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Parameters.PhotoModulData(thisCh));
        end
        thisData=AP_Demodulation(SessionData.(thisNidaqField){1,thisTrial}(:,1),thisModulation,SampRate,thisAmp,thisFreq,15);
        thisData=decimate(thisData,DecimateFactor);
        else    % Amplitude=0 for this channel for this trial
            thisData=Data;
        end
    else        % no modulation of this channel for this trial
        thisData=decimate(SessionData.NidaqData{1,thisTrial}(:,1),DecimateFactor);
    end
% Resize data vector according to the length of expected data  
    if length(thisData)>ExpectedSize
        Data=thisData(1:length(Data));
    else
        Data(1:length(thisData))=thisData;
    end  
% DFF 
    DFFBaseline=mean(Data(Baseline(1):Baseline(2)));
    DFFSTD=std2(Data(Baseline(1):Baseline(2)));
    if Analysis.Parameters.Zscore
        DFF=(Data-DFFBaseline)/DFFSTD;
    else
    DFF=100*(Data-DFFBaseline)/DFFBaseline;
    end
%     DFF=100*(Data-DFFBaseline)/DFFBaseline;
%     if Analysis.Parameters.Zscore
%         DFFZBaseline=mean(DFF(Baseline(1):Baseline(2)));
%         DFFZSTD=std2(DFF(Baseline(1):Baseline(2)));
%         DFF=(DFF-DFFZBaseline)/DFFZSTD;
%     end
    
    if Analysis.Parameters.ZeroAtZero
        DFF=DFF-mean(DFF(Time>-0.1 & Time<=0));
    end

    Photo{thisCh}(1,:)=Time;
    Photo{thisCh}(2,:)=Data;
    Photo{thisCh}(3,:)=DFF;

% remove variable ITI at beggining of the session
% QC 9/21 should I ceil or not the ZeroOffsetPoints? / is adding a point on line 83 necessary) 
if ~isempty(StateZeroOffset)
NewPhoto=NaN(3,ExpectedSize);
ZeroOffsetPoints=round(ZeroOffset*SRDecimated);
if ZeroOffsetPoints==0
    ZeroOffsetPoints=1;
end
NewTime=linspace(0,Duration+ZeroOffset,ExpectedSize+ZeroOffsetPoints)-TimeToZero;
NewTime=NewTime(ZeroOffsetPoints:end);
NewPhoto(1,1:length(NewTime))=NewTime;
NewPhoto([2 3],1:(ExpectedSize-ZeroOffsetPoints+1))=Photo{thisCh}([2 3],ZeroOffsetPoints:end);
Photo{thisCh}=NewPhoto;
end
    
end  
    else
        Photo=[];
end

%% Wheel
if Analysis.Parameters.Wheel==1
% Timimg parameters 
    if Analysis.Parameters.Photometry==0
SRDecimated=Analysis.Parameters.NidaqDecimatedSR;
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
Duration=Analysis.Parameters.NidaqDuration;
ExpectedSize=Duration*SRDecimated;
Time=linspace(0,Duration,ExpectedSize)-TimeToZero;
    end
DTsec=0.01; % in sec
DTpoints=SRDecimated*DTsec;

% Expected Data set   
DataWheel=NaN(ExpectedSize,1);
% Data
signedData = SessionData.NidaqWheelData{1,thisTrial};
signedThreshold = 2^(Analysis.Parameters.WheelCounterNbits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^Analysis.Parameters.WheelCounterNbits;
DataDeg  = signedData * 360/Analysis.Parameters.WheelEncoderCPR;
DataDeg  = decimate(DataDeg,DecimateFactor);

if length(DataDeg)>ExpectedSize
        DataWheel=DataDeg(1:length(DataWheel));
    else
        DataWheel(1:length(DataDeg))=DataDeg;
end  

DataWheelDistance=DataWheel.*(Analysis.Parameters.WheelPolarity*Analysis.Parameters.WheelDiameter*pi/360);

Wheel(1,:)=Time;
Wheel(2,:)=DataWheel;
Wheel(3,:)=DataWheelDistance;

% remove variable ITI at beggining of the session
if ~isempty(StateZeroOffset)
NewWheel=NaN(3,ExpectedSize);
ZeroOffsetPoints=round(ZeroOffset*SRDecimated);
if ZeroOffsetPoints==0
    ZeroOffsetPoints=1;
end
NewTime=linspace(0,Duration+ZeroOffset,ExpectedSize+ZeroOffsetPoints)-TimeToZero;
NewTime=NewTime(ZeroOffsetPoints:end);
NewWheel(1,1:length(NewTime))=NewTime;
NewWheel([2 3],1:(ExpectedSize-ZeroOffsetPoints+1))=Wheel([2 3],ZeroOffsetPoints:end);
Wheel=NewWheel;
end

else
    Wheel=[];
end
end