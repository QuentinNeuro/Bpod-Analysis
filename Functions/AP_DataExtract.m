function [TimeToZero,LickData, Photo, Wheel, thisphase, Raw]=AP_DataExtract(SessionData,Analysis,thisTrial)
%AP_DataExtract extracts licks timestamp, raw and normalized photometry value together with
%a time array of the trial 'thistrial' from the 'sessiondata' file. This
%function is using the parameters contained in the 'Analysis' structure
%
%function designed by Quentin 2016 for Analysis_Photometry

thisphase=NaN;
%% Timing parameters
StateToZero=Analysis.Parameters.StateToZero;
TimeToZero=SessionData.RawEvents.Trial{1,thisTrial}.States.(StateToZero)(1);

%% Licks
LickPort=Analysis.Parameters.LickPort;
try
    LickData=SessionData.RawEvents.Trial{1,thisTrial}.Events.(LickPort);
catch
    LickData=NaN;  
end
Raw.Lick=LickData;
%% FirstLick
if Analysis.Parameters.ZeroFirstLick
    LicksDuringZeroState  =LickData(LickData> TimeToZero & LickData < TimeToZero+1);
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
% Data
Photo=cell(length(Analysis.Parameters.PhotoCh),1);
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    ExpectedSize=Duration*SRDecimated;
    Data=NaN(ExpectedSize,1);
    Time=linspace(0,Duration,ExpectedSize)-TimeToZero;
    if Analysis.Parameters.Modulation
        thisNidaqField=char(Analysis.Parameters.PhotoField{thisCh});
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoAmpField{thisCh}));
        if thisAmp~=0
        thisFreq=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoFreqField{thisCh}));
        thisRawData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
%         if Analysis.Parameters.NewDemod
%             [thisData, thisphase] = AP_IQ_Demodulation(thisRawData, SampRate, thisFreq,'PaddingType', 'Rand','CutOff', 15);
%         else
           switch Analysis.Parameters.recordedMod
            case 0
                thisModulation=AP_Modulation(Analysis,thisAmp,thisFreq);
            case 1
                thisModulation=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Parameters.PhotoModulData(thisCh));
            end
        thisData=AP_Demodulation(thisRawData,thisModulation,SampRate,thisAmp,thisFreq,15);
%         end
            thisData=decimate(thisData,DecimateFactor);

        else    % Amplitude=0 for this channel for this trial
            thisData=Data;
        end
    else        % no modulation of this channel for this trial
        thisData=decimate(SessionData.NidaqData{1,thisTrial}(:,1),DecimateFactor);
    end
% Reshape if Variable time before 'zero' or ZeroAtFirstLick
if Analysis.Parameters.TimeReshaping
	[Time,Data]=AP_TimeReshaping(Analysis,Time,thisData,SRDecimated,Analysis.Parameters.ReshapedTime);
else % Make sure Data are the correct size
    if length(thisData)>=ExpectedSize
        Data=thisData(1:length(Data));
    else
        Data(1:length(thisData))=thisData;
    end  
end
% DFF, z-score, zero at zero
    DFFBaseline=AP_Baseline(Analysis,Data,Baseline);
    DFFSTD=std2(Data(Baseline(1):Baseline(2)));
    if Analysis.Parameters.Zscore
        DFF=(Data-DFFBaseline)/DFFSTD;
    else
    DFF=100*(Data-DFFBaseline)/DFFBaseline;
    end

    if Analysis.Parameters.ZeroAtZero
        DFF=DFF-mean(DFF(Time>-0.1 & Time<=0));
    end
% Output    
    Photo{thisCh}(1,:)=Time;
    Photo{thisCh}(2,:)=Data;
    Photo{thisCh}(3,:)=DFF;
    Raw.Photometry{thisCh}=thisData;
end  
    else
        Photo=[];
end

%% Wheel
if Analysis.Parameters.Wheel==1
% Timimg parameters 
SRDecimated=Analysis.Parameters.NidaqDecimatedSR;
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
Duration=Analysis.Parameters.NidaqDuration;
ExpectedSize=Duration*SRDecimated;
% Expected Data set   
DataWheel=NaN(ExpectedSize,1);
% Data
Time=linspace(0,Duration,ExpectedSize)-TimeToZero;
signedData = SessionData.NidaqWheelData{1,thisTrial};
signedThreshold = 2^(Analysis.Parameters.WheelCounterNbits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^Analysis.Parameters.WheelCounterNbits;
DataDeg  = signedData * 360/Analysis.Parameters.WheelEncoderCPR;
DataDeg  = decimate(DataDeg,DecimateFactor);
Raw.Wheel=DataDeg;
% Reshape if Variable ITI before 'zero' or ZeroAtFirstLick
if Analysis.Parameters.TimeReshaping
	[Time,DataWheel]=AP_TimeReshaping(Analysis,Time,DataDeg,SRDecimated,Analysis.Parameters.ReshapedTime);
else % Make sure Data are the correct size
    if length(DataDeg)>=ExpectedSize
        DataWheel=DataDeg(1:length(DataWheel));
    else
        DataWheel(1:length(DataDeg))=DataDeg;
    end  
end
% Deg to Distance
DataWheelDistance=DataWheel.*(Analysis.Parameters.WheelPolarity*Analysis.Parameters.WheelDiameter*pi/360);
% Output
Wheel(1,:)=Time;
Wheel(2,:)=DataWheel;
Wheel(3,:)=DataWheelDistance;

else
    Wheel=[];
end
end