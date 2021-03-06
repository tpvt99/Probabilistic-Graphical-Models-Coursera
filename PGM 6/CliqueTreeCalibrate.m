%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% P = MaxSumCalibrate.INPUT;
% isMax = 1;
function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 if isMax == 0
     while true
         [from, to] = GetNextCliques(P, MESSAGES);
         if from == 0 && to == 0
             break;
         end
         Phi = P.cliqueList(from);
         Factor = FactorProduct(Phi, ...
             struct('var', [], 'card', [], 'val', []));
         edges = P.edges(from,:); % 1-8
         for r = 1:length(edges)
             if edges(r) == 1 && r ~= to
                 mess = MESSAGES(r,from);
                 Factor = FactorProduct(Factor, mess);
             end
         end
         T = Factor;
         sameNode = intersect(P.cliqueList(from).var,...
             P.cliqueList(to).var);
         for z = 1:length(Factor.var)
             if ~ismember(Factor.var(z), sameNode)
                 T = FactorMarginalization(T, ...
                     [Factor.var(z)]);
             end
         end
         T = ComputeMarginal(T.var, T, []);
         MESSAGES(from, to) = T;
     end
 else
     % log
     for i = 1:length(P.cliqueList)
         P.cliqueList(i).val = log(P.cliqueList(i).val);
     end
     while true
         [from, to] = GetNextCliques(P, MESSAGES);
         if from == 0 && to == 0
             break;
         end
         Phi = P.cliqueList(from);
         Factor = FactorSum(Phi, ...
             struct('var', [], 'card', [], 'val', []));
         edges = P.edges(from,:); % 1-8
         for r = 1:length(edges)
             if edges(r) == 1 && r ~= to
                 mess = MESSAGES(r,from);
                 Factor = FactorSum(Factor, mess);
             end
         end

         diffNode = setdiff(P.cliqueList(from).var, ...
             intersect(P.cliqueList(from).var, P.cliqueList(to).var));
         Factor = FactorMaxMarginalization(Factor, diffNode);
         MESSAGES(from, to) = Factor;
     end
 end
 
 % From messages to calculate beliefs
 for i = 1:length(P.cliqueList)
     initialBeliefs = P.cliqueList(i);
     if isMax == 0
        Factor = FactorProduct(initialBeliefs, struct('var', [], 'card', [], 'val', []));
     else
        Factor = FactorSum(initialBeliefs, struct('var', [], 'card', [], 'val', []));
     end
     edges = P.edges(i,:);
     for r = 1:length(edges)
         if edges(r) == 1 && r ~= i
             mess = MESSAGES(r,i);
             if isMax == 0
                Factor = FactorProduct(Factor, mess);
             else
                Factor = FactorSum(Factor, mess);
             end
         end
     end
     P.cliqueList(i) = Factor;
 end
 
 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



return
