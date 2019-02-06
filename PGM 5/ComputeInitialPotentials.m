%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

%C = InitPotential.INPUT;
function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P.edges = C.edges;
% copy Input nodes to Result cliqueList
for i = 1:N
    P.cliqueList(i).var = C.nodes{i};
end

% Create a list of cardinalities
maxx = 0;
for i = 1:length(C.factorList)
    mm = max(C.factorList(i).var);
    if mm > maxx
        maxx = mm;
    end
end
cardList = zeros(1, maxx);
for i = 1:length(C.factorList)
    for z = 1:length(C.factorList(i).var)
        cardList(C.factorList(i).var(z)) = C.factorList(i).card(z);
    end
end

% Loop through factorList
fList = [];
for z = 1:length(C.factorList)
    factor = C.factorList(z); % a struct
    sortFactor = sort(factor.var);
    maxList = Inf;
    for k = 1:length(C.nodes)
        clique = C.nodes{k}; % clique is a list, e.g. [1,7]
        if sum(ismember(sortFactor, clique)) == length(sortFactor)
            if length(clique) < maxList
                maxList = length(clique);
                chosenClique = k;
            end
        end
    end
    fList = [fList, chosenClique];
end

for i = 1:N
    Factor = struct('var', [], 'card', [], 'val', []);
    for t = 1:length(fList)
        if fList(t) == i
            Factor = FactorProduct(Factor, C.factorList(t));
        end
    end
    % Check if 2 cardinality is different
    diffList = ismember(P.cliqueList(i).var, Factor.var);
    % If there is 0 in diffList
    for t = 1:length(diffList)
        if diffList(t) == 0
            fac = struct('var', [P.cliqueList(i).var(t)],...
                'card', [cardList(P.cliqueList(i).var(t))], ...
                'val', ones(1,cardList(P.cliqueList(i).var(t))));
            Factor = FactorProduct(Factor, fac);
        end
    end
    Factor = OrderFactors(Factor);
    P.cliqueList(i).card = Factor.card;
    P.cliqueList(i).val = Factor.val;
end

