% Muti-Thresholding Image Segemention Using Genetic Algonithm
% �����Ŵ��㷨�Ķ���ֵͼ��ָ�
% ���ߣ� �ƴ�
% data : 2021/10/31
% Ŀ�꣺��󻯸Ľ��Ĺȵ�ǿ����
% ���룺�����Ʊ��� ���ݻҶ�ֵ��Χȷ��λ��thsld_len ����Ԥ�����ֵ����thsld_mount
%       �ۺ�ȷ��ÿ��Ⱦɫ���ϵĳ���Ϊ��thsld_len * thsld_mount
% ��Ӧ�Ⱥ���������Ӧ�ȼ�Ȩ��
% ѡ�����̶�
% ���죺�������
 
%%
%(0) ���
clc;
clear;
close all;

%%
%(1) ȷ������
pop_size = 20;               % ��Ⱥ��С
pc = 0.8;                    % �������
pm = 0.1;                    % �������
iter_max = 500;              % ����������
thsld_mount = 10;             % ��ֵ��Ŀ
thsld_len = log2(256);       % ÿ����ֵ��λ��
elite_pro = 0.1;             % ��Ӣ�����и���ռ�ı���

%%
%��2��ͼ��Ԥ����
[fileName, pathName] = uigetfile({'*.*'}, 'Select the  original image file');
image_path = strcat(pathName, fileName);
init_image = imread(image_path);     % ����ͼƬ

[image_hsv, image_hsv_h, hist, breakpoint] = CircleHistogramToLinearizedHistogram(init_image);  % ��չ����ֱ��ͼΪ���Ի�ֱ��ͼ
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
%% �����߼�����
t_start = clock;
% ��ʼ����Ⱥ
pop = init_pop(pop_size, thsld_mount);

% �����¼
history = zeros(iter_max, 2);                     % ÿ����õ���Ӧ��ֵ  ÿ��ƽ����Ӧ��ֵ
history_pop = zeros(iter_max, thsld_mount);       % ÿ�������Ӧ�ȵ���ֵ   ÿ��������ֵ�ε�ƽ��ֵ
 
% �����������ڵ���
flag = ceil(iter_max * (1 - 0.4));
tim = zeros(iter_max, 6);
for iter = 1 : iter_max
    % ����
    cross_pop = crossing(pop, pc, thsld_len);
    % ����
    muta_pop = mutation(cross_pop, pm, thsld_len);
    % ѡ��
    [pop, best_fit_aver_fit, cur_best_pop ] = selection(pop, muta_pop, thsld_mount, hist, elite_pro, q);
    history(iter, :) = best_fit_aver_fit;
    history_pop(iter, :)= cur_best_pop;
    tim(iter, :) = clock;
    fprintf('%d:best fitness:%f\n', iter, history(iter,1));
    fprintf('%d:best pop answer:%s\n\n', iter, num2str(history_pop(iter, :)));
    % ����ѡ��ͱ������
    if iter == flag              
        pc = pc * 0.4;
        pm = pm * 0.4;
    end
end
t_end = clock;

%% ͼ��������
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
    text(iter_max - 10, history_pop(iter_max - 10, t), num2str(history_pop(iter_max - 10, t)));  % ��λ�ñ�ע���˵�������-10��
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

% ���»�ͼ
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