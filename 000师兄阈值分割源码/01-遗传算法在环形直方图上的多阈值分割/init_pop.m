function pop = init_pop(pop_size, thsld_mount)
% 随机生成[0 255]之间的十进制阈值
    pop = zeros(pop_size, thsld_mount);
    for i = 1 : pop_size
        pop(i, :) = randperm(256, thsld_mount);
    end
end