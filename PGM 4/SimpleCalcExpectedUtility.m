% Copyright (C) Daphne Koller, Stanford University, 2012
%I1 = I;
%I = I3;
function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  D = I.DecisionFactors;
  U = I.UtilityFactors(1);
  EU = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  New = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(F)
      New = FactorProduct(New, F(i));
  end
  VarsToEliminate = [];
  for i = New.var
      if ~ismember(i, U.var)
          VarsToEliminate = [VarsToEliminate, i];
      end
  end
  A = VariableElimination(New, VarsToEliminate);
  % Step to Order the Utility
  U = OrderFactors(U);
  EU = U.val * A.val';

