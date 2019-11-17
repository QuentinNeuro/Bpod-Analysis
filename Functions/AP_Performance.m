function Analysis=AP_Performance(Analysis,Group)
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
if ~isempty(Group)
%% Run tests
% Outcome collection
OutcomeTest=sum(Analysis.(Group{1}).Licks.Outcome>0/Analysis.(Group{1}).nTrials);
testIO(1)=OutcomeTest>ThreshOutcome;
% Cue vs baseline
IntraTest{1}=round(Analysis.(Group{2}).Licks.Baseline);
IntraTest{2}=round(Analysis.(Group{2}).Licks.Cue);
IntraROC=mroc(IntraTest{2},IntraTest{1});
IntraTT=ttest2(IntraTest{2},IntraTest{1});
testIO(2)=IntraROC>ThreshROC;
testIO(3)=IntraTT==1;
if size(Group,2)==4
% Cue vs (un)Cue
InterTest{1}=round(Analysis.(Group{3}).Licks.Cue);
InterTest{2}=round(Analysis.(Group{4}).Licks.Cue);
InterROC=mroc(InterTest{1},InterTest{2});
InterTT=ttest2(InterTest{1},InterTest{2});
testIO(4)=InterROC>ThreshROC;
testIO(5)=InterTT==1;
end
%% Compute decision variable
Decision=sum(testIO)==length(testIO)
else
Decision=NaN;
testIO=NaN;
end
%% Save in Analysis Structure
Analysis.Performance.Decision=Decision;
Analysis.Performance.testIO=testIO;
end

