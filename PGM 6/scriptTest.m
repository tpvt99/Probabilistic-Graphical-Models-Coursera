load exampleIOPA5.mat 
addpath('gaimc');

% Section 2.1

disp('BlockLogDistribution.m')
disp(BlockLogDistribution(exampleINPUT.t6a1, exampleINPUT.t6a2,...
    exampleINPUT.t6a3, exampleINPUT.t6a4))
disp('expected result:')
disp(exampleOUTPUT.t6)
disp('')

disp('GibbsTrans.m (all 0s expected: diff between actual and expected)')
clear randi;
for i = 1:10
    A = GibbsTrans(exampleINPUT.t7a1{i}, exampleINPUT.t7a2{i},
        exampleINPUT.t7a3{i});
    disp(A-exampleOUTPUT.t7{i})
    disp('')
endfor

% Section 2.1.1

disp('MCMCInference.m - Input 1')
clear randi;
disp(MCMCInference(exampleINPUT.t8a1{1}, exampleINPUT.t8a2{1},
    exampleINPUT.t8a3{1}, exampleINPUT.t8a4{1}, exampleINPUT.t8a5{1},
    exampleINPUT.t8a6{1}, exampleINPUT.t8a7{1}, exampleINPUT.t8a8{1})(2))
disp("expected result (run 1):")
disp(exampleOUTPUT.t8o1{1}(2))

% Section 2.2

disp('MHUniformTrans.m (all 0s expected: diff between actual and expected)')
clear randi;
for i = 1:10
    A = MHUniformTrans(exampleINPUT.t9a1{i}, exampleINPUT.t9a2{i},
        exampleINPUT.t9a3{i});
    disp(A-exampleOUTPUT.t9{i})
    disp('')
end

% MHSWTrans.m (Variant 1)

disp('MHSWTrans.m Variant 1 (all 0s expected: diff between actual and expected)')
clear randi;
for i = 1:10
    A = MHSWTrans(exampleINPUT.t10a1{i}, exampleINPUT.t10a2{i}, 
        exampleINPUT.t10a3{i}, exampleINPUT.t10a4{i});
    disp(A-exampleOUTPUT.t10{i});
    disp('');
endfor

% MHSWTrans.m (Variant 2)

disp('MHSWTrans.m Variant 2 (all 0s expected: diff between actual and expected)')
clear randi;
for i = 1:10
    A = MHSWTrans(exampleINPUT.t11a1{i}, exampleINPUT.t11a2{i}, 
        exampleINPUT.t11a3{i}, exampleINPUT.t11a4{i});
    disp(A-exampleOUTPUT.t11{i});
    disp('');
endfor

% MCMCInference.m - Part 2

disp('MCMCInference.m - PART 2 (MHUniform)')
clear randi;
disp(MCMCInference(exampleINPUT.t12a1{1}, exampleINPUT.t12a2{1},
    exampleINPUT.t12a3{1}, exampleINPUT.t12a4{1}, exampleINPUT.t12a5{1},
    exampleINPUT.t12a6{1}, exampleINPUT.t12a7{1}, exampleINPUT.t12a8{1})(2))
disp("expected result:")
disp(exampleOUTPUT.t12o1{1}(2))

disp('MCMCInference.m - PART 2 (MHSwendsenWang2)')
clear randi;
disp(MCMCInference(exampleINPUT.t12a1{2}, exampleINPUT.t12a2{2},
    exampleINPUT.t12a3{2}, exampleINPUT.t12a4{2}, exampleINPUT.t12a5{2},
    exampleINPUT.t12a6{2}, exampleINPUT.t12a7{2}, exampleINPUT.t12a8{2})(2))
disp("expected result: (doesn't match, but passes grader)")
% curious if anyone else gets an exact match - please reply
disp(exampleOUTPUT.t12o1{2}(2))

