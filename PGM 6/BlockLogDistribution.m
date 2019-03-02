%BLOCKLOGDISTRIBUTION
%
%   LogBS = BlockLogDistribution(V, G, F, A) returns the log of a
%   block-sampling array (which contains the log-unnormalized-probabilities of
%   selecting each label for the block), given variables V to block-sample in
%   network G with factors F and current assignment A.  Note that the variables
%   in V must all have the same dimensionality.
%
%   Input arguments:
%   V -- an array of variable names
%   G -- the graph with the following fields:
%     .names - a cell array where names{i} = name of variable i in the graph 
%     .card - an array where card(i) is the cardinality of variable i
%     .edges - a matrix such that edges(i,j) shows if variables i and j 
%              have an edge between them (1 if so, 0 otherwise)
%     .var2factors - a cell array where var2factors{i} gives an array where the
%              entries are the indices of the factors including variable i
%   F -- a struct array of factors.  A factor has the following fields:
%       F(i).var - names of the variables in factor i
%       F(i).card - cardinalities of the variables in factor i
%       F(i).val - a vectorized version of the CPD for factor i (raw probability)
%   A -- an array with 1 entry for each variable in G s.t. A(i) is the current
%       assignment to variable i in G.
%
%   Each entry in LogBS is the log-probability that that value is selected.
%   LogBS is the P(V | X_{-v} = A_{-v}, all X_i in V have the same value), where
%   X_{-v} is the set of variables not in V and A_{-v} is the corresponding
%   assignment to these variables consistent with A.  In the case that |V| = 1,
%   this reduces to Gibbs Sampling.  NOTE that exp(LogBS) is not normalized to
%   sum to one at the end of this function (nor do you need to worry about that
%   in this function).
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% V = exampleINPUT.t6a1;
% V=[1,2,3,4,6,7,10,14];
% G = exampleINPUT.t6a2;
% F = exampleINPUT.t6a3;
% A = exampleINPUT.t6a4;


function LogBS = BlockLogDistribution(V, G, F, A)
if length(unique(G.card(V))) ~= 1
    disp('WARNING: trying to block sample invalid variable set');
    return;
end

% d is the dimensionality of all the variables we are extracting
d = G.card(V(1));

LogBS = zeros(1, d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute LogBS by multiplying (adding in log-space) in the correct values from
% each factor that includes some variable in V.  
%
% NOTE: As this is called in the innermost loop of both Gibbs and Metropolis-
% Hastings, you should make this fast.  You may want to make use of
% G.var2factors, repmat, unique, and GetValueOfAssignment.
%
% Also you should have only ONE for-loop, as for-loops are VERY slow in matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1. find the factorList which is factors of variables in V(1)
%2. Observe those factors where variables are not in V
%3. Log-space those factors
%4. Add them together
%5. Observe variable in V
%6. Add to LogBS by get value in V as index of LogBS and not in V by A

% factorList = unique([G.var2factors{V}]);
% Factor = struct('var', [], 'card', [], 'val', []);
% 
% for i = factorList
%     factor = F(i);
%     a = [];
%     for t = factor.var
%         if ~ismember(t, V)
%             a = [a; t, A(t)];
%         end
%     end
%     factor.val = log(factor.val);
%     factor = ObserveEvidence(factor, a);
%     Factor = FactorSum(Factor, factor);
% end
% 
% 
% for i = 1:length(LogBS)
%     a = [];
%     for t = Factor.var
%         if ismember(t, V)
%             a=[a,i];
%         else
%             a=[a,A(t)];
%         end
%     end
%     LogBS(i) = GetValueOfAssignment(Factor, a);
% end



%%% Copy
uniqueFInds = unique([G.var2factors{V}]);
newF = F(uniqueFInds);
newA = repmat(A, d, 1);
newA(:,V) = repmat([1:d]', 1, length(V));


for i=1:length(newF)
    LogBS = LogBS + log(GetValueOfAssignment(newF(i), newA(:, newF(i).var)));
end;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Re-normalize to prevent underflow when you move back to probability space
LogBS = LogBS - min(LogBS);



