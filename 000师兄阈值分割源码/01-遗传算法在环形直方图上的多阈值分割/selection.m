function [select_pop best_fit_aver_fit cur_best_pop] = selection(pop,new_pop,thsld_mount,hist,elite_pro,q)
 
[row, list] = size(pop);
% 检查阈值被变异或交叉变成0
new_pop(new_pop == 0) = 1;
 
f_num = ceil(elite_pro * row) ;
 
temp_pop = zeros(size(pop));
select_fit = zeros(1, row);
% 30%保留父代优秀个体
f_fitness = compute_fit(pop, hist, q);
[a, b] = sort(f_fitness,'descend');
temp_pop = pop(b(1 : f_num), :);
select_fit = f_fitness(b(1: f_num));
 
%计算子代适应度
s_fitness = compute_fit(new_pop, hist, q);
 
%根据适应度值计算累积概率
cumulat_fit = zeros(row, 1);    %累积适应度
pro = zeros(row, 1);            %累积概率
c_sum = 0;
 
for i = 1 : row
    c_sum = c_sum + s_fitness(i);
    cumulat_fit(i) = c_sum;
end
por = cumulat_fit / c_sum;
 
%轮盘赌选择row - f_num个个体
s_num = row - f_num;
[a b] = sort(s_fitness, 'descend');
temp_pop(f_num+1 : row, :) = new_pop(b(1 : s_num), :);
history_j = zeros(1, row);
for i=1 : s_num
    r = rand;
    for j = 1 : row
        if por(j) >= r
            history_j(i) = j;
            temp_pop(f_num+i, :) = new_pop(j, :);
            select_fit(f_num + i)= s_fitness(j);
            break;
        end
    end
end
 
%选择后的每一代的最好适应度和平均适应度
best_fit = max(select_fit);
aver_fit = mean(select_fit);
best_fit_aver_fit = [best_fit aver_fit];
 
%选择后最好适应度的解空间
[a, b] = sort(select_fit,'descend');
cur_best_pop = temp_pop(b(1),:);
select_pop =temp_pop;
end