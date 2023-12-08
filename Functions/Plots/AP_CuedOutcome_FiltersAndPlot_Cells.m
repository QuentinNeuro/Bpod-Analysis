function Analysis=AP_CuedOutcome_FiltersAndPlot_Cells(Analysis) 

thisType={'CS_Reward','CS_Reward','NS','Uncued_Reward'};
thisCellFilter={'posRew','posRewInv','posRew','posRew'};

%% FilterCells
    Analysis=A_FilterCell(Analysis,'posRew','OutcomeAVG_Cell',Analysis.Parameters.AOD.rewT,'Uncued_Reward');
    for tc=1:size(thisType,2)
        Analysis=AP_DataSort_SingleCells(Analysis,thisType{tc},thisCellFilter{tc});
    end

%% Figures
thisDirFig=[Analysis.Parameters.DirFig 'cellFilter' filesep];
mkdir(thisDirFig);
    for tc=1:size(thisType,2)
        thisTC=[thisType{tc} '_' thisCellFilter{tc}];
        AP_PlotData_filter(Analysis,thisTC);
        saveas(gcf,[thisDirFig Analysis.Parameters.Legend thisTC '.png']);
    end


% % %     if Analysis.Parameters.PlotFiltersSingle
% %     thisCIndex=find(Analysis.Filters.posRew);
% %     for thisC=thisCIndex
% %         AP_Plot_AOD(Analysis,'cells',thisC);
% %         thisCName=sprintf('cell%.0d',thisC);
% %         saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_posR_' thisCName '.png']);
% %         close gcf
% %     end

% 
% 
%     thisDirFig=[Analysis.Parameters.DirFig 'filter' filesep];
%     if isfolder(thisDirFig)==0
%     mkdir(thisDirFig);
%     end
%     if Analysis.Parameters.PlotFiltersSummary
%     AP_Plot_AOD(Analysis,'filter')
%     saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter.png']);
%     end
%     if Analysis.Parameters.PlotFiltersSingle
%     for thisC=1:Analysis.Parameters.AOD.nCells
%         AP_Plot_AOD(Analysis,'cells',thisC);
%         thisCName=sprintf('cell%.0d',thisC);
%         saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_' thisCName '.png']);
%         %close gcf
%     end
%     end
% 
%     % cell specific
%     Analysis=A_FilterCell(Analysis,'posRew','OutcomeAVG',Analysis.Parameters.AOD.rewT,'Uncued_Reward');
%     Analysis=AP_DataSort_AOD(Analysis,'CS_Reward',[],'posRew');
%     Analysis=AP_DataSort_AOD(Analysis,'NS',[],'posRew');
%     Analysis=AP_DataSort_AOD(Analysis,'Uncued_Reward',[],'posRew');
%     thisDirFig=[Analysis.Parameters.DirFig 'filter_posR' filesep];
% %     if isfolder(thisDirFig)==0
% %     mkdir(thisDirFig);
% %     end
% % %     if Analysis.Parameters.PlotFiltersSummary
% % %     AP_Plot_AOD(Analysis,'cells')
% % %     saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_posR.png']);
% % %     end
% % %     if Analysis.Parameters.PlotFiltersSingle
% %     thisCIndex=find(Analysis.Filters.posRew);
% %     for thisC=thisCIndex
% %         AP_Plot_AOD(Analysis,'cells',thisC);
% %         thisCName=sprintf('cell%.0d',thisC);
% %         saveas(gcf,[thisDirFig Analysis.Parameters.Legend '_filter_posR_' thisCName '.png']);
% %         close gcf
% %     end
% %     end
end
    