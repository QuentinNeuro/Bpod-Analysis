function Analysis=AB_CuedOutcome_FiltersAndPlot_Cells(Analysis) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Combine behavior and cell filters
thisType={};
if Analysis.Parameters.Spikes.Spikes
    switch Analysis.Parameters.Behavior.Phase
        case {'RewardA','RewardB'}
    thisType={'Uncued_Reward','CS_Reward','NS'};
    thisCellFilter={'TagEarly','TagEarly','TagEarly'};
        case {'RewardAPunishB','RewardBPunishA','RewardAPunishBValues','RewardBPunishAValues'}
    thisType={'Uncued_Reward','HVS_Reward','LVS'};
    thisCellFilter={'TagEarly','TagEarly','TagEarly'};
    end
end

if Analysis.Parameters.AOD.AOD
    % thisType={'Uncued_Reward','Uncued_Reward'};
    % thisCellFilter={'posRew','posRewInv'};
    Analysis=AB_FilterCell(Analysis,'posRew','OutcomeAVGZ',Analysis.Parameters.AOD.rewT,'Uncued_Reward');
    % Analysis=AB_FilterCell(Analysis,'posRew','OutcomeMAXZ',Analysis.Parameters.AOD.rewT,'Uncued_Reward');
    thisType={'AnticipLick_CS_Reward','AnticipLick_CS_Reward','NoAnticipLick_NS','Uncued_Reward','Uncued_Reward'};
    thisCellFilter={'posRew','posRewInv','posRew','posRew','posRewInv'};
    % Analysis=A_FilterCell(Analysis,'posCue','CueMAX','preSTD','CS');
end

%% FilterCells
    for tc=1:size(thisType,2)
        Analysis=AB_DataSort_SingleCell(Analysis,thisType{tc},thisCellFilter{tc});
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
    GroupPlot_Spikes=AB_CuedOutcome_FilterGroups_Spikes(Analysis);
    
    switch Analysis.Parameters.Plot.Cells_Spike
        case 1
            cellFilter=false(1,Analysis.Parameters.Data.nCells);
            for e=1:size(Analysis.Parameters.Spikes.tagging_EpochNames,2)
                cellFilter=cellFilter+Analysis.Filters.(Analysis.Parameters.Spikes.tagging_EpochNames{e});
            end
        case 2
            cellFilter=true(1,Analysis.Parameters.Data.nCells);
    end

    for c=1:Analysis.Parameters.Data.nCells
        if cellFilter(c)
        AB_PlotData_Spikes_Behavior(Analysis,c,GroupPlot_Spikes);
        cellID=Analysis.AllData.AllCells.CellName{c};
        cellID_Label=[Analysis.AllData.(cellID).LabelClustering '_' Analysis.AllData.(cellID).LabelTag];
        saveas(gcf,[thisDirFig Analysis.Parameters.Plot.Legend '_' cellID '_' cellID_Label '.png']);
        % close
        end
    end


end
end
    