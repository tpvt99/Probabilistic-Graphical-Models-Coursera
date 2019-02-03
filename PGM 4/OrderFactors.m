%U = U;
function F = OrderFactors(U)

F = struct('var', [], 'card', [], 'val', []);

var = U.var;
card = U.card;

[F.var, sortOrder] = sort(var);
F.card = card;
F.val = zeros(1, prod(F.card));

for i = 1:length(U.val)
    OldAssign = IndexToAssignment(i, F.card);
    NewAssign = OldAssign(sortOrder);
    F = SetValueOfAssignment(F, NewAssign, GetValueOfAssignment(U, OldAssign));
end

