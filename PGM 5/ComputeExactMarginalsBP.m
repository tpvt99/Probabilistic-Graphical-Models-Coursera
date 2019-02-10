%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% F = ExactMarginal.INPUT;
% E = [];
% isMax = 0;

function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(isMax);
if isMax == 0
    cliqueTree = CreateCliqueTree(F, E);
    calibrateTree = CliqueTreeCalibrate(cliqueTree, isMax);
    varList = [];
    cardList = [];
    for i = 1:length(F)
        for z = 1:length(F(i).var)
            if ~ismember(F(i).var(z), varList)
                varList = [varList, F(i).var(z)];
                cardList = [cardList, F(i).card(z)];
            end
        end
    end
    result = repmat(struct('var', [], 'card', [], 'val', []), length(varList), 1);
    for i = 1:length(varList)
        result(i).var = varList(i);
        result(i).card = cardList(i);
        for z = 1:length(calibrateTree.cliqueList)
            if ismember(result(i).var, calibrateTree.cliqueList(z).var)
                F = FactorMarginalization(calibrateTree.cliqueList(z),...
                    calibrateTree.cliqueList(z).var(...
                        find(result(i).var ~= calibrateTree.cliqueList(z).var)...
                        ));
                break;
            end
        end
        F = ComputeMarginal(F.var, F, []);
        result(i).val = F.val;
        M = result;
    end
else
    M = [];
end



