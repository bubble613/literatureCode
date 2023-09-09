% Muti-Thresholding Image Segemention Using Genetic Algonithm
% 基于遗传算法的多阈值图像分割
% 作者： 黄聪
% data : 2021/10/31
% 目标：最大化改进的谷点强调法
% 编码：二进制编码 根据灰度值范围确定位数thsld_len 根据预设的阈值个数thsld_mount
%       综合确定每个染色体上的长度为：thsld_len * thsld_mount
% 适应度函数：自适应谷加权法
% 选择：轮盘赌
% 变异：单点变异
 
%%
%(0) 清空
clc;
clear;
close all;

%%
%(1) 确定参数
pop_size = 20;               % 种群大小
pc = 0.8;                    % 交叉概率
pm = 0.1;                    % 变异概率
iter_max = 500;              % 最大迭代次数
thsld_mount = 10;             % 阈值数目
thsld_len = log2(256);       % 每个阈值的位数
elite_pro = 0.1;             % 精英保留中父代占的比例

%%
%（2）图像预处理
[fileName, pathName] = uigetfile({'*.*'}, 'Select the  original image file');
image_path = strcat(pathName, fileName);
init_image = imread(image_path);     % 读入图片

[image_hsv, image_hsv_h, hist, breakpoint] = CircleHistogramToLinearizedHistogram(init_image);  % 扩展环形直方图为线性化直方图
q = selectEntropyQ(hist);

subplot(2, 2, 1);
imshow(init_image);
title('RGB Image');

subplot(2, 2, 2);
imshow(image_hsv);
title('HSV Image');

subplot(2, 2, 3);
imshow(image_hsv_h, []);
title('HSV Image H');
 
subplot(2, 2, 4);
bar(hist);
title('Histogram');
%% 代码逻辑部分
t_start = clock;
% 初始化种群
pop = init_pop(pop_size, thsld_mount);

% 保存记录
history = zeros(iter_max, 2);                     % 每代最好的适应度值  每代平均适应度值
history_pop = zeros(iter_max, thsld_mount);       % 每代最好适应度的阈值   每代各个阈值段的平均值
 
% 最大迭代代数内迭代
flag = ceil(iter_max * (1 - 0.4));
tim = zeros(iter_max, 6);
for iter = 1 : iter_max
    % 交叉
    cross_pop = crossing(pop, pc, thsld_len);
    % 变异
    muta_pop = mutation(cross_pop, pm, thsld_len);
    % 选择
    [pop, best_fit_aver_fit, cur_best_pop ] = selection(pop, muta_pop, thsld_mount, hist, elite_pro, q);
    history(iter, :) = best_fit_aver_fit;
    history_pop(iter, :)= cur_best_pop;
    tim(iter, :) = clock;
    fprintf('%d:best fitness:%f\n', iter, history(iter,1));
    fprintf('%d:best pop answer:%s\n\n', iter, num2str(history_pop(iter, :)));
    % 调整选择和编译概率
    if iter == flag              
        pc = pc * 0.4;
        pm = pm * 0.4;
    end
end
t_end = clock;

%% 图形输出结果
subplot(3, 3, 5);
plot(history(:, 1));
title('Best fitness');
xlabel('Generation');
ylabel('Fitness');
text(1, history(1, 1),num2str(history(1, 1)));
text(20, history(20, 1),num2str(history(20, 1)));
text(iter_max, history(iter_max, 1),num2str(history(iter_max, 1)));
 
subplot(3, 3, 6);
plot(history(:, 2));
title('Average fitness');
xlabel('Generation');
ylabel('Fitness');
text(1, history(1, 2), num2str(history(1, 2)));
text(20, history(20, 2), num2str(history(20, 2)));
text(iter_max, history(iter_max, 2), num2str(history(iter_max, 2)));
 
subplot(3, 3, 7);
plot(history_pop);
title('Thlsd value');
xlabel('Generation');
ylabel('Thlsd value');
 
for t = 1 : thsld_mount
    text(iter_max - 10, history_pop(iter_max - 10, t), num2str(history_pop(iter_max - 10, t)));  % 将位置标注在了迭代次数-10处
end

subplot(3, 3, 8);
plot(hist);
title('Cut-off Rule');
hold on
y = max(hist);
color = ['r','g','b','c','y','m','b'];
for t = 1 : thsld_mount
    pos = rem(t, 7);
    if pos == 0
        pos = 7;
    end
    plot([history_pop(iter_max, t), history_pop(iter_max, t)], [0, y], color(pos));
    text(history_pop(iter_max, t), y - (t * 100) , num2str(history_pop(iter_max, t)));
end

% 重新绘图
last_thsld = history_pop(iter_max, :);
last_thsld = sort(last_thsld, 2);
label = zeros(size(image_hsv_h));
L = length(last_thsld);
for i = L : -1 : 1
    label(mod((image_hsv_h - breakpoint + 256), 256) <= last_thsld(i)) = uint8(255 / L * i);
end

if L == 1
    label(label == 255) = 2;
    label(label == 0) = 1;
else
    for i = L : -1 : 1
        label(label == uint8(255 / L * i)) = i;
    end
    label(label == 0) = L + 1;
end

Lseg=Label_image(init_image, label);
figure,
imshow(Lseg);
title('Result Image');
run_time = etime(t_end, t_start);
disp(run_time);