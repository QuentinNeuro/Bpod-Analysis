function Analysis=AP_DataProcess_Normalize(Analysis)

%% Baseline calculation
if Analysis.Parameters.Photometry.Photometry
    Analysis=AP_Photometry_Baseline(Analysis);
    if Analysis.Parameters.Photometry.Fit_470405
    Analysis=AP_Photometry_2ChFit(Analysis);
    end
    if Analysis.Parameters.Data.BaselineFit
        disp('BaselineFit is not ready yet')
    end
end


%% Normalize

        baselineAVG=Analysis.AllData.(thisC_Name).BaselineAVG(t);
        baselineSTD=Analysis.AllData.(thisC_Name).BaselineSTD(t);   
        % DFF / z-scoring
        if fitTest && c==1
            try
            [time,data405]=AP_PSTH(Analysis.Core.Photometry{t}{2},PSTH_TW,timeToZero,sampRate);
            p=Analysis.Parameters.PhotometryFit;
            data405=data405*p(1)+p(2);
            data=100*(data-data405)./data405;
            catch
                data=100*(data-baselineAVG)/baselineAVG;
            end
        else
        data=data-baselineAVG;
        if Analysis.Parameters.Data.Zscore
            data=data/baselineSTD;
        else
            data=100*data/baselineAVG;
        end
        end

        dataZero=0;
        switch Analysis.Parameters.Timing.ZeroAt
            case 'Zero'
                dataZero=mean(data(time>-0.1 & time<0),'omitnan');
            case '2sBefCue'
                dataZero=mean(data(time>cueTime(1)-2.2 & time<=cueTime(1)-1.8),'omitnan');
            otherwise
                if isnumeric(Analysis.Parameters.Timing.ZeroAt)
                    thisZeroTime=Analysis.Parameters.Timing.ZeroAt;
                    dataZero=mean(data(time>thisZeroTime-0.1 & time<=thisZeroTime+0.1),'omitnan');
                end
        end
        if isnan(dataZero)
            dataZero=0;
        end
        data=data-dataZero;



end