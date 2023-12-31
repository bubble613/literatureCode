%% 清理命令
clear;
close all;
clc;

%% 引入图片

[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if size(image, 3) == 3
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

[M, N] = size(image);
figure,
imshow(image),
title('原始灰度图像');


%% 计算平均邻域灰度的一维灰度直方图
% f存储原图，此时转为double类型的数据便于计算
f = double(image);
% g存储平均邻域灰度的一维灰度直方图
g = zeros(M, N);
% 窗口大小为1
w = 1;

for i = 1 : M
    for j = 1 : N
        % 计算(i, j)下的平均邻域灰度，领域大小为w * w
        for k = -w : w
            for m = -w : w
                p = i + k;
                q = j + m;
                % 边界值处理
                if(p < 1 || p > M)
                    p = i;
                end
                if(q < 1 || q > N)
                    q = j;
                end
                g(i, j) = g(i, j) + f(p, q);
            end
        end
        g(i, j) = (1 / 9) * g(i, j);
    end
end
g = uint8(g);
figure,
imshow(g),
title('平均邻域灰度后的图像');

%% 计算并展示二维直方图
% 将f的数据类型转换回来
f = uint8(f);
% h存储二维直方图，注意维度大小为灰度可能出现的最大值
h = zeros(256, 256);
for i = 1 : M
    for j = 1 : N
        p = f(i, j) + 1;
        q = g(i, j) + 1;
        h(p, q) = h(p, q) + 1;
    end
end

figure,
mesh(h),
xlim([0 256]),
ylim([0 256]),
colorbar,
% view(2),
% view(90,0),
title('二维灰度直方图');

%% 计算概率
% 归一化二维直方图
h = h / (M * N);
% P0存储目标区域概率，u_T0及u_T1表示二维直方图在i和j方向上的总的均值矢量
P0 = zeros(256, 256);
u_i = zeros(256, 256);
u_j = zeros(256, 256);

% 迭代计算P0
P0(1, 1) = h(1, 1);
% 先计算两侧的累积概率
for i = 2 : 256
    P0(1, i) = P0(1, i - 1) + h(1, i);
end
for i = 2 : 256
    P0(i, 1) = P0(i - 1, 1) + h(i, 1);
end
for i = 2 : 256
    for j = 2 : 256
        P0(i, j) = P0(i - 1, j) + P0(i, j - 1) - P0(i - 1, j - 1) + h(i, j);
    end
end
P1 = ones(256, 256) - P0;

% 迭代计算u_i
u_i(1, 1) = 0 * h(1, 1);  % 均值 = 点 * 概率
for i = 2 : 256
    u_i(1, i) = u_i(1, i - 1) + (1 - 1) * h(1, i);
end
for i = 2 : 256
    u_i(i, 1) = u_i(i - 1, 1) + (i - 1) * h(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_i(i, j) = u_i(i - 1, j) + u_i(i, j - 1) - u_i(i - 1, j - 1) + (i - 1) * h(i, j);
    end
end

% 迭代计算u_j
u_j(1, 1) = 0 * h(1, 1);  % 均值 = 点 * 概率
for i = 2 : 256
    u_j(1, i) = u_j(1, i - 1) + (i - 1) * h(1, i);
end
for i = 2 : 256
    u_j(i, 1) = u_j(i - 1, 1) + (1 - 1) * h(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_j(i, j) = u_j(i - 1, j) + u_j(i, j - 1) - u_j(i - 1, j - 1) + (j - 1) * h(i, j);
    end
end

% 计算u_T0和u_T1
u_T0 = 0;
u_T1 = 0;
for i = 1 : 256
    for j = 1 : 256
        u_T0 = u_T0 + (i - 1) * h(i, j);
        u_T1 = u_T1 + (j - 1) * h(i, j);
    end
end

%% 计算HT Hw Hb
% 文献中  PK.Sahoo等人通过大量 实验证明 alpha = 0.8  时可以得到最佳闷值。

alpha = 0.8;
Hb = zeros(256);
Hw = zeros(256);
HT = zeros(256);

%% 计算Hb Hw

% Hb(1, 1) = (1 - power((h(1, 1) / P0(1, 1)), alpha)) / (alpha - 1);
% Hw(1, 1) = (1 - power((h(1, 1) / P1(1, 1)), alpha)) / (alpha - 1);
% 
% for i = 2:256
%     Hb(1, i) = (1 - sum(power((h(1, 1 : i) / P0(1, i)), alpha))) / (alpha - 1);
% end
% for i = 2:256
%     Hb(i, 1) = (1 - sum(power((h(1 : i, 1) / P0(i, 1)), alpha))) / (alpha - 1);
% end
% 
% for i = 2:256
%     Hw(1, i) = (1 - sum(power((h(1, 1 : i) / P1(1, i)), alpha))) / (alpha - 1);
% end
% for i = 2:256
%     Hw(i, 1) = (1 - sum(power((h(1 : i, 1) / P1(i, 1)), alpha))) / (alpha - 1);
% end
% Hb(256, 256) = (1 - power((1.0 / P0(256, 256)), alpha)) / (alpha - 1);

% for i = 1:256
%     for j = 1:i
%         sum256 = 0;
%         sum256 = sum256 + power((h(i, j) / P0(256, j)), alpha);
%         Hb(256, i) = (1 - sum256) / (alpha - 1);
%     end
% end

% for i = 1:256
%     for j = 1:i
%         sum256 = 0;
%         sum256 = sum256 + power((h(j, i) / P0(j, 256)), alpha);
%         Hb(i, 256) = (1 - sum256) / (alpha - 1);
%     end
% end

%% 修改后的
% for s = 2 : 256
%     for t = 2 : 256
% 
%         % Hb
%         for i = 1 : s - 1
%             for j = 1 : t - 1
%                 sumb = 0; 
%                 if P0(s-1, t-1) ~= 0
%                     sumb = sumb + power((h(i, j) / P0(s-1, t-1)), alpha);
%                 else
%                     sumb = sumb;
%                 end
%             end    
%         end
%         Hb(s, t) = (1 - sumb) / (alpha - 1);
%         
%         % Hw
%         for i = s : 256
%             for j = t : 256
%                 sumw = 0;
%                 if P0(s, t) ~= 1
%                     sumw = sumw + power((h(i, j) / (1 - P0(s, t))), alpha);
%                 else
%                     sumw = sumw;
%                 end 
%             end
%         end
%         Hw(s, t) = (1 - sumw) / (alpha - 1);
%     end
% end

for i = 1:256
    for j = 1:256
        % Hb 
        if P0(i, j) == 0
            Hb(i, j) = 0;
        else
            Hb(i, j) = (1 - sum(sum(power(h(1 : i, 1 : j) / P0(i, j), alpha)))) / (alpha - 1);
        end
        
        % Hw 
        if P1(i, j) == 0
            Hw(i, j) = 0;
        else
            Hw(i, j) = (1 - sum(sum(power(h(i + 1 : 256, j + 1 : 256) / P1(i, j), alpha)))) / (alpha - 1);
        end
        
        % 记录 准则函数为最大时 s 和 t
        F(i, j) = Hb(i, j) + Hw(i, j) + (1 - alpha) * Hb(i, j) * Hw(i, j);
    end
end
%% HT
for m = 1:256
    for n = 1:256
        sumT = 0;
        for i = 1:m
            for j = 1:n
                sumT = sumT + power(h(i, j), alpha);
            end
        end
        HT(m, n) = (1 - sumT) / (alpha - 1);
    end
end

F_max = max(F(:));
s = 0;
t = 0;
for i = 1 : 256
    for j = 1 : 256
        if F(i, j) == F_max
            s = i - 1;
            t = j - 1;
        end
    end
end

%% 展示图像
seg1 = ones(M, N);
seg2 = ones(M, N);
for i = 1 : M
    for j = 1 : N
        if f(i, j) + g(i, j) <= s+t
            seg1(i, j) = 0;
        end
    end
end

for i = 1 : M
    for j = 1 : N
        if f(i, j) <= s && g(i, j) <= t
            seg2(i, j) = 0;
        end
    end
end
figure,
subplot(121), imshow(seg1), title('鲁棒分割二维分割后的图像');
subplot(122), imshow(seg2), title('普通二维分割后的图像');
str1 = strcat('二维Tsallis熵准则函数最大时的灰度值为：', num2str(F_max));
str2 = strcat('阈值（i）：', num2str(s));
str3 = strcat('阈值（j）：', num2str(t));
% str4 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
fprintf('result：%s; %s; %s.\n', str1, str2, str3);