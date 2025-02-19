function Analysis=AB_CuedOutcome_FiltersAndPlot_Cells(Analysis) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Combine behavior and cell filters
thisType={};
if Analysis.Parameters.Spikes.Spikes
    switch Analysis.Parameters.Behavior.Phase
        case {'RewardA','RewardB'}
    thisType={'Uncued_Reward','CS_Reward','NS'};
    thisCellFilter={'Tag_Early','Tag_Early','Tag_Early'};
        case {'RewardAPunishB','RewardBPunishA','RewardAPunishBValues','RewardBPunishAValues'}
    thisType={'Uncued_Reward','HVS_Reward','LVS'};
    thisCellFilter={'Tag_Early','Tag_Early','Tag_Early'};
    end
end

if Analysis.Parameters.AOD.AOD
    thisType={'Uncued_Reward','Uncued_Reward'};
    thisCellFilter={'posRew','posRewInv'};
    Analysis=A_FilterCell(Analysis,'posRew','OutcomeMAX','preSTD','Uncued_Reward');
    % thisType={'AnticipLick_CS_Reward','AnticipLick_CS_Reward','NoAnticipLick_NS','Uncued_Reward','Uncued_Reward'};
    % thisCellFilter={'posRew','posRewInv','posRew','posRew','posRewInv'};
    % Analysis=A_FilterCell(Analysis,'posCue','CueMAX','preSTD','CS');
end

%% FilterCells
    for tc=1:size(thisType,2)
        Analysis=AP_DataSort_Filter_SingleCell(Analysis,thisType{tc},thisCellFilter{tc});
    end

%% Figures
if Analysis.Parameters.Plot.Cells
thisDirFig=[Analysis.Parameters.DirFig 'cellFilter' filesep];
mkdir(thisDirFig);
theseTypeCells={};
    for tc=1:size(thisType,2)
        theseTypeCells{tc}=[thisType{tc} '_' thisCellFilter{tc}];
        AB_PlotData_Filter(Analysis,theseTypeCells{tc});
        saveas(gcf,[thisDirFig Analysis.Parameters.Plot.Legend theseTypeCells{tc} '.png']);
    end
    AB_PlotData(Analysis,'CellFilter',theseTypeCells);
    saveas(gcf,[thisDirFig Analysis.Parameters.Plot.Legend 'CellFilter.png']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spikes
if Analysis.Parameters.Spikes.Spikes && Analysis.Parameters.Plot.Cells_Spike
    thisDirFig=[Analysis.Parameters.DirFig 'Spikes' filesep];
    mkdir(thisDirFig);
    GroupPlot_Spikes=AP_CuedOutcome_FilterGroups_Spikes(Analysis);
    
    tempCellFilter=false(1,Analysis.Parameters.nCells);
    for e=1:size(Analysis.Parameters.Spikes.tagging_EpochNames,2)
        tempCellFilter=tempCellFilter+Analysis.Filters.(['Tag_' Analysis.Parameters.Spikes.tagging_EpochNames{e}]);
    end

    for c=1:Analysis.Parameters.nCells
        if tempCellFilter(c)
        AB_PlotData_Spikes(Analysis,c,GroupPlot_Spikes);
        cellID=Analysis.AllData.AllCells.CellName{c};
        cellID_Label=[Analysis.AllData.(cellID).LabelCluster '_' Analysis.AllData.(cellID).LabelTag];
        saveas(gcf,[thisDirFig Analysis.Parameters.Plot.Legend '_' cellID '_' cellID_Label '.png']);
        close
        end
    end


end

end
    