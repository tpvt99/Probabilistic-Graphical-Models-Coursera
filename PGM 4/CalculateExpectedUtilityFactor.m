% Copyright (C) Daphne Koller, Stanford University, 2012
%I = I1;
function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  F = [I.RandomFactors];
  D = I.DecisionFactors;
  U = I.UtilityFactors(1);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  New = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(F)
      New = FactorProduct(New, F(i));
  end
  for i = 1:length(U)
      New = FactorProduct(New, U(i));
  end
  VarsToEliminate = [];
  for i = New.var
      if ~ismember(i, D.var)
          VarsToEliminate = [VarsToEliminate, i];
      end
  end
  A = VariableElimination(New, VarsToEliminate);
  % Step to Order the Utility
EUF = A;