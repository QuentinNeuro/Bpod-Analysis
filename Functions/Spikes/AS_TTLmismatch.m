function Analysis=AS_TTLmismatch(Analysis)
%%   
    if Analysis.Parameters.nTrials > length(Analysis.AllData.Spikes.Time.Behavior)
       disp('Too many bpod trials');
       if ceil(Analysis.AllData.Spikes.Time.Behavior(2)-Analysis.AllData.Spikes.Time.Behavior(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            for indexTTLFix=length(Analysis.AllData.Spikes.Time.Behavior)+1:Analysis.Parameters.nTrials
                Analysis.AllData.Spikes.Time.Behavior(indexTTLFix)=Analysis.AllData.Spikes.Time.Behavior(indexTTLFix-1)...
                    +(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1));
            end
            disp('TTL mismatch resolved')
        else
            disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.SpikesAnalysis=0;
            return
       end
    else
%%
       disp('Too many TTLs');
        if ceil(Analysis.AllData.Spikes.Time.Behavior(2)-Analysis.AllData.Spikes.Time.Behavior(1))...
                ==ceil(Analysis.Core.TrialStartTS(2)-Analysis.Core.TrialStartTS(1))
            Analysis.AllData.Spikes.Time.Behavior=Analysis.AllData.Spikes.Time.Behavior(1:Analysis.Parameters.nTrials);
        disp('TTL mismatch resolved')
        else
           disp('dont know how to correct the mismatch in TTL yet')
            Analysis.Parameters.SpikesAnalysis=0;
            return
        end
    end
%    Analysis.AllData.Spikes.Time.Behavior=Analysis.AllData.Spikes.Time.Behavior(Analysis.Filters.ignoredTrials);
end