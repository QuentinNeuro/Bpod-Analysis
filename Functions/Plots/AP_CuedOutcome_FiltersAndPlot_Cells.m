function Analysis=AP_CuedOutcome_FiltersAndPlot_Cells(Analysis) 

if Analysis.Parameters.Spikes.Spikes
    switch Analysis.Parameters.Behavior.Phase
        case {'RewardA','RewardB'}
    thisType={'Uncued_Reward','CS_Reward','NS_Omission'};
    thisCellFilter={'Tag_Early','Tag_Early','Tag_Early'};
        case {'RewardAPunishB','RewardBPunishA'}
    thisType={'Uncued_Reward','HVS_Reward','LVS_Omission'};
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
        Analysis=AP_DataSort_SingleCells(Analysis,thisType{tc},thisCellFilter{tc});
    end

%% Figures
if Analysis.Parameters.Plot.Cells
thisDirFig=[Analysis.Parameters.DirFig 'cellFilter' filesep];
mkdir(thisDirFig);
    for tc=1:size(thisType,2)
        thisTC=[thisType{tc} '_' thisCellFilter{tc}];
        AP_PlotData_filter(Analysis,thisTC);
        saveas(gcf,[thisDirFig Analysis.Parameters.Legend thisTC '.png']);
    end
end
end
    