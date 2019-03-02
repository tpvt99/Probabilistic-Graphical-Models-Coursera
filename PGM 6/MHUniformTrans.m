% MHUNIFORMTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the uniform proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% A = exampleINPUT.t9a1{1};
% G = exampleINPUT.t9a2{1};
% F = exampleINPUT.t9a3{1};

function A = MHUniformTrans(A, G, F)

% Draw proposed new state from uniform distribution
A_prop = ceil(rand(1, length(A)) .* G.card);

p_acceptance = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Prob_x = BlockLogDistribution(unique([F.var]), G, F, A);
Prob_x_dash = BlockLogDistribution(unique([F.var]), G, F, A_prop);


pi_x = LogProbOfJointAssignment(F, A);
pi_x_dash = LogProbOfJointAssignment(F, A_prop);

p_acceptance = min(1, exp(pi_x_dash)*exp(Prob_x)/(exp(pi_x) * exp(Prob_x_dash)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
    % disp('Accepted');
    A = A_prop;
end