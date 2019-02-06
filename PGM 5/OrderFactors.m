% U = T;
function F = OrderFactors(U)

F = struct('var', [], 'card', [], 'val', []);


[F.var, sortOrder] = sort(U.var);
F.card = U.card(sortOrder);
F.val = zeros(1, prod(F.card));

for i = 1:length(U.val)
    OldAssign = IndexToAssignment(i, U.card);
    NewAssign = OldAssign(sortOrder);
    F = SetValueOfAssignment(F, NewAssign, GetValueOfAssignment(U, OldAssign));
end
