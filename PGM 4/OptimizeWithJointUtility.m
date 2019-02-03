% Copyright (C) Daphne Koller, Stanford University, 2012
% I = I4;
function [MEU OptimalDecisionRule] = OptimizeWithJointUtility( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
    
  % This is similar to OptimizeMEU except that we must find a way to 
  % combine the multiple utility factors.  Note: This can be done with very
  % little code.
  MEU = 0;
  OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  F = [I.RandomFactors];
  D = I.DecisionFactors;
  U = I.UtilityFactors;
  New = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(U)
      New = FactorSum(New, U(i));
  end
  I.UtilityFactors = New;
  
  [MEU, OptimalDecisionRule] = OptimizeMEU( I );

