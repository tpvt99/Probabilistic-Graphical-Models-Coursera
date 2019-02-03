% Copyright (C) Daphne Koller, Stanford University, 2012

%I = I3;
function [MEU, OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);
  F = I.RandomFactors;
  MEU = 0;
  OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  EUF = CalculateExpectedUtilityFactor(I);
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


