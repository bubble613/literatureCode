function pop = init_pop(pop_size, thsld_mount)
% �������[0 255]֮���ʮ������ֵ
    pop = zeros(pop_size, thsld_mount);
    for i = 1 : pop_size
        pop(i, :) = randperm(256, thsld_mount);
    end
end