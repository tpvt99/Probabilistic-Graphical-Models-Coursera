function love = ahhi()
global emiu;
if isempty('emiu')
    emiu = 101;
    for i = 1:10
        emiu = emiu + 1;
    end
    disp('emiu not existed. Created one');
else
    disp('emiu existed');
end
    