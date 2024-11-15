function Analysis=AP_Pairing_FiltersAndPlot(Analysis)
Title='PairedStimulus';
switch Analysis.Parameters.Behavior
    case 'AuditoryTuning'
        PairedFilter=logical(Analysis.Filters.type_2+Analysis.Filters.type_3);
        PairedFilter_Inv=~PairedFilter;
        Analysis=AP_DataSort(Analysis,'Paired',PairedFilter);
        Analysis=AP_DataSort(Analysis,'NotPaired',PairedFilter_Inv);
        % AP_PlotData_filter(Analysis,'Paired');
        % AP_PlotData_filter(Analysis,'NotPaired');
        AP_PlotSummary_filter(Analysis,Title,{'Paired','NotPaired'});
    case 'VisualTuning'
        PairedType=sprintf('type_%.0d',Analysis.Core.BpodSettings{1,1}.GUI.Opto_TrialType);
        PairedFilter=Analysis.Filters.(PairedType);
        PairedFilter_Inv=~PairedFilter;
        Analysis=AP_DataSort(Analysis,'Paired',PairedFilter);
        Analysis=AP_DataSort(Analysis,'NotPaired',PairedFilter_Inv);
        % AP_PlotData_filter(Analysis,'Paired');
        % AP_PlotData_filter(Analysis,'NotPaired');
        AP_PlotSummary_filter(Analysis,Title,{'Paired','NotPaired'});
end
end