function Analysis=AP_CuedOutcome_FiltersAndPlot_Cells(Analysis) 

thisType={'AnticipLick_CS_Reward','AnticipLick_CS_Reward','NoAnticipLick_NS','Uncued_Reward','Uncued_Reward'};
thisCellFilter={'posRew','posRewInv','posRew','posRew','posRewInv'};
% thisType={'Uncued_Reward','Uncued_Reward'};
% thisCellFilter={'posRew','posRewInv'};

%% FilterCells
    Analysis=A_FilterCell(Analysis,'posRew','OutcomeMAX','preSTD','Uncued_Reward');
    Analysis=A_FilterCell(Analysis,'posCue','CueMAX','preSTD','CS');
    for tc=1:size(thisType,2)
        Analysis=AP_DataSort_SingleCells(Analysis,thisType{tc},thisCellFilter{tc});
    end

%% Figures
if Analysis.Parameters.PlotCells
thisDirFig=[Analysis.Parameters.DirFig 'cellFilter' filesep];
mkdir(thisDirFig);
    for tc=1:size(thisType,2)
        thisTC=[thisType{tc} '_' thisCellFilter{tc}];
        AP_PlotData_filter(Analysis,thisTC);
        saveas(gcf,[thisDirFig Analysis.Parameters.Legend thisTC '.png']);
    end
end
end
    