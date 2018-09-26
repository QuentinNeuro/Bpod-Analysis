function Analysis=AP_Sensor_Performance(Analysis,GTT)
% GTT (Group to test) should be a cell array containing 4 trial type names.
% The first trial type is beeing tested for the collection of the reward
% (>80%)
% The second trial type is beeing tested for the presence of anticipatory
% licking for the cue vs its own baseline
% The two other trial types are being compared to one another to assess a
% difference in the anticipatory licking for the cue period (also works
% when no cue is presented).
% 
%% Parameters
ThreshOutcome=0.8; %
ThreshROC=0.7; %
%% Run tests
% Outcome collection
OutcomeTest=sum(Analysis.(GTT{1}).Licks.Outcome>0/Analysis.(GTT{1}).nTrials);
testIO(1)=OutcomeTest>ThreshOutcome;
% Cue vs baseline
IntraTest{1}=round(Analysis.(GTT{2}).Licks.Baseline);
IntraTest{2}=round(Analysis.(GTT{2}).Licks.Cue);
IntraROC=mroc(IntraTest{1},IntraTest{2});
IntraTT=ttest2(IntraTest{1},IntraTest{2});
testIO(2)=IntraROC>ThreshROC;
testIO(3)=IntraTT==1;
if size(GTT,2)==4
% Cue vs (un)Cue
InterTest{1}=round(Analysis.(GTT{3}).Licks.Cue);
InterTest{2}=round(Analysis.(GTT{4}).Licks.Cue);
InterROC=mroc(InterTest{1},InterTest{2});
InterTT=ttest2(InterTest{1},InterTest{2});
testIO(4)=InterROC>ThreshROC;
testIO(5)=InterTT==1;
end
%% Compute decision variable
Analysis.Parameters.Decision=sum(testIO)==length(testIO);

end

