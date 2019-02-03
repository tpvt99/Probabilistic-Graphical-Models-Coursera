% Copyright (C) Daphne Koller, Stanford University, 2012

%I = I4;
function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = 0;
  OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  F = I.RandomFactors;
  D = I.DecisionFactors;
  U = I.UtilityFactors;
  EUFList = [];
  New = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(U)
      Z.RandomFactors = F;
      Z.DecisionFactors = D;
      Z.UtilityFactors = U(i);
      EUF = CalculateExpectedUtilityFactor(Z);
      EUFList = [EUFList, EUF];
  end

  New = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(EUFList)
      New = FactorSum(New, EUFList(i));
  end
  
  EUF = New;
  MEU = 0;
  OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
  if length(D.var) == 1 
      % It does not have parents
      [MEU, index] = max(EUF.val);
      OptimalDecisionRule.var = [D.var 0];
      OptimalDecisionRule.card = D.card;
      for i = 1:length(EUF.val)
          if i == index
            OptimalDecisionRule.val(i) = 1;
          else
              OptimalDecisionRule.val(i) = 0;
          end
      end
  else
      OptimalDecisionRule.var = EUF.var;
      OptimalDecisionRule.card = EUF.card;
      OptimalDecisionRule.val = zeros(1, prod(EUF.card));
      % Finding var of D
      varD = D.var(1);
      posD = find(EUF.var == varD);
      cardD = EUF.card(posD);
      parentVars = [];
      parentCard = [];
      for z = 1:length(D.var)
          if D.var(z) ~= varD
              parentVars = [parentVars, D.var(z)];
              parentCard = [parentCard, D.card(z)];
          end
      end
      for i = 1:prod(parentCard) % loop through parent index
          Assign = IndexToAssignment(i, parentCard);
          maxX = -inf;
          for z = 1:prod(cardD)
              NewAssign = [Assign(1:posD-1), z, Assign(posD:end)];
              if GetValueOfAssignment(EUF, NewAssign) > maxX
                  maxX = GetValueOfAssignment(EUF, NewAssign);
                  maxAssign = NewAssign;
              end
          end
          MEU = MEU + maxX;
          OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule, maxAssign, 1);
      end
  end