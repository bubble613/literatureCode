% 快速二维直方图OTSU分割（迭代法）
% 作者： 黄聪
% 目标函数：最大类间方差
%% 清理命令
clear;
close all;
clc;

%% 导入图像，只支持灰度图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if size(image, 3) == 3
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

[M, N] = size(image);
% figure,
% imshow(image),
% title('原始图像');

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
% figure,
% imshow(g),
% title('平均邻域灰度后的图像');

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


%% 使用离差矩阵的迹作为评价指标，具体参见论文《灰度图像的二维Otsu曲线阈值分割法》
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

%% 类间方差的计算和最终阈值
% 采用类间的离差矩阵的迹作为类间的离散度测量
for i = 1 : 256
    for j = 1 : 256
        if P0(i, j) ~= 0 && P1(i, j) ~= 0
            trSB(i, j) = ((u_T0 * P0(i, j) - u_i(i, j))^2 + (u_T1 * P0(i, j) - u_j(i, j))^2) / (P0(i, j) * P1(i, j));
        else
            trSB(i ,j) = 0;
        end
    end
end

% trSB_max存储最大的类间方差
trSB_max = max(trSB(:));
s = 0;
t = 0;
for i = 1 : 256
    for j = 1 : 256
        if trSB(i, j) == trSB_max
            s = i - 1;
            t = j - 1;
            continue;
        end
    end
end

trSB_max
s
t

%% 展示图像
seg1 = ones(M, N);
seg2 = ones(M, N);
% for i = 1 : M
%     for j = 1 : N
%         if double(f(i, j)) + double(g(i, j)) <= s+t
%             seg1(i, j) = 0;
%         end
%     end
% end
for i = 1 : M
    for j = 1 : N
        if f(i, j) <= s && g(i, j) <= t
            seg2(i, j) = 0;
        end
    end
end
figure,
% subplot(121), imshow(seg1, []), title('鲁棒的二维Otsu分割后的图像');
imshow(seg2), title('二维Otsu分割后的图像');
str1 = strcat('二维Otsu类间方差最大：', num2str(trSB_max));
str2 = strcat('阈值（i）：', num2str(s));
str3 = strcat('阈值（j）：', num2str(t));
% str4 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
fprintf('result：%s; %s; %s.\n', str1, str2, str3);