% function AOD_threshold_helper(Analysis)
figure()
subplot(4,2,[1 2])
plot(Analysis.AllData.AOD.time(:,1),Analysis.Uncued_Reward.AOD.AllCells.Data,'-k');
subplot(4,2,[3 4])
plot(Analysis.AllData.AOD.time(:,1),Analysis.Uncued_Reward.AOD.AllCells.Data(:,[1 10 20 30]),'-k');
hold on
plot(Analysis.AllData.AOD.time(:,1),Analysis.Uncued_Reward.AOD.AllCells.DataAVG,'-r');
subplot(4,2,[5 6])
plot(Analysis.AllData.AOD.time(:,1),Analysis.CueA_Reward.AOD.AllCells.Data);

