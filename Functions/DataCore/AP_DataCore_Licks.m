function Licks=AP_DataCore_Licks(SessionData,Analysis,thisTrial)

LickPort=Analysis.Parameters.Licks.Port;
try
    Licks=SessionData.RawEvents.Trial{1,thisTrial}.Events.(LickPort);
catch
    Licks=NaN;  
end
end