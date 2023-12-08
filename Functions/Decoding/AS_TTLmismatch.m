function Analysis=AS_TTLmismatch(Analysis)
%%   
    sprintf('Bpod trial nb %.0d - TTL trial nb %.0d', Analysis.Parameters.nTrials,length(Analysis.Core.TS_Behavior))
    
    if Analysis.Parameters.nTrials > length(Analysis.Core.TS_Behavior)
       disp('Too many bpod trials');
       if ceil(Analysis.Core.TS_Behavior(2)-Analysis.Core.TS_Behavior(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            for indexTTLFix=length(Analysis.Core.TS_Behavior)+1:Analysis.Parameters.nTrials
                Analysis.Core.TS_Behavior(indexTTLFix)=Analysis.Core.TS_Behavior(indexTTLFix-1)...
                    +(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1));
            end
            disp('TTL mismatch resolved')
        else
            disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.Spikes.Spikes=0;
            return
       end
    else
%%
       disp('Too many TTLs');
        if ceil(Analysis.Core.TS_Behavior(2)-Analysis.Core.TS_Behavior(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            Analysis.Core.TS_Behavior=Analysis.Core.TS_Behavior(1:Analysis.Parameters.nTrials);
        disp('TTL mismatch resolved')
        else
           disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.Spikes.Spikes=0;
            return
        end
    end
%    Analysis.AllData.Spikes.Time.Behavior=Analysis.AllData.Spikes.Time.Behavior(Analysis.Filters.ignoredTrials);
end