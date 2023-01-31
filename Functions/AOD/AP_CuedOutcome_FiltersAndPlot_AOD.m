function Analysis=AP_CuedOutcome_FiltersAndPlot_AOD(Analysis) 

    thisDirFig=[Analysis.Parameters.DirFig 'filter' filesep];
    if isfolder(thisDirFig)==0
    mkdir(thisDirFig);
    end
%     if Analysis.Parameters.PlotFiltersSummary
%     AP_Plot_AOD(Analysis,'filter')
%     saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter.png']);
%     end
%     if Analysis.Parameters.PlotFiltersSingle
    for thisC=1:Analysis.Parameters.AOD.nCells
        AP_Plot_AOD(Analysis,'cells',thisC);
        thisCName=sprintf('cell%.0d',thisC);
        saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_' thisCName '.png']);
        %close gcf
    end
%     end
    
    % cell specific
%     Analysis=A_FilterCell(Analysis,'posRew','OutcomeAVG',Analysis.Parameters.AOD.rewT,'Uncued_Reward');
%     Analysis=AP_DataSort_AOD(Analysis,'CueA_Reward',[],'posRew');
%     Analysis=AP_DataSort_AOD(Analysis,'CueB_Omission',[],'posRew');
%     Analysis=AP_DataSort_AOD(Analysis,'Uncued_Reward',[],'posRew');
%     thisDirFig=[Analysis.Parameters.DirFig 'filter_posR' filesep];
%     if isfolder(thisDirFig)==0
%     mkdir(thisDirFig);
%     end
% %     if Analysis.Parameters.PlotFiltersSummary
% %     AP_Plot_AOD(Analysis,'cells')
% %     saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_posR.png']);
% %     end
% %     if Analysis.Parameters.PlotFiltersSingle
%     thisCIndex=find(Analysis.Filters.posRew);
%     for thisC=thisCIndex
%         AP_Plot_AOD(Analysis,'cells',thisC);
%         thisCName=sprintf('cell%.0d',thisC);
%         saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_posR_' thisCName '.png']);
%         close gcf
%     end
%     end
end
    