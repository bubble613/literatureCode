%% 清理命令
clear;
close all;
clc;

%% 导入图像，只支持灰度图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'; '*.png'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if size(image, 3) == 3
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

[M, N] = size(image);
figure,
imshow(image),
title('原始图像');

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
                a = i + k;
                b = j + m;
                % 边界值处理
                if(a < 1 || a > M)
                    a = i;
                end
                if(b < 1 || b > N)
                    b = j;
                end
                g(i, j) = g(i, j) + f(a, b);
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
Hist2D = zeros(256, 256);
for i = 1 : M
    for j = 1 : N
        a = f(i, j) + 1;
        b = g(i, j) + 1;
        Hist2D(a, b) = Hist2D(a, b) + 1;
    end
end

figure,
mesh(Hist2D),
xlim([0 256]),
ylim([0 256]),
colorbar,
% view(2),
% view(90,0),
title('二维灰度直方图');

%% 新方法
% 两次求一维Otsu得到阈值向量（s, t）
% 归一化二维直方图
p = Hist2D / (M * N);
% P0存储目标区域概率，u_T0及u_T1表示二维直方图在i和j方向上的总的均值矢量
P0 = zeros(256, 256);
u_i = zeros(256, 256);
u_j = zeros(256, 256);

% 迭代计算P0
P0(1, 1) = p(1, 1);
% 先计算两侧的累积概率
for i = 2 : 256
    P0(1, i) = P0(1, i - 1) + p(1, i);
end
for i = 2 : 256
    P0(i, 1) = P0(i - 1, 1) + p(i, 1);
end
for i = 2 : 256
    for j = 2 : 256
        P0(i, j) = P0(i - 1, j) + P0(i, j - 1) - P0(i - 1, j - 1) + p(i, j);
    end
end
P1 = ones(256, 256) - P0;

% 迭代计算u_i
u_i(1, 1) = 0 * p(1, 1);  % 均值 = 点 * 概率
for i = 2 : 256
    u_i(1, i) = u_i(1, i - 1) + (1 - 1) * p(1, i);
end
for i = 2 : 256
    u_i(i, 1) = u_i(i - 1, 1) + (i - 1) * p(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_i(i, j) = u_i(i - 1, j) + u_i(i, j - 1) - u_i(i - 1, j - 1) + (i - 1) * p(i, j);
    end
end

% 迭代计算u_j
u_j(1, 1) = 0 * p(1, 1);  % 均值 = 点 * 概率
for i = 2 : 256
    u_j(1, i) = u_j(1, i - 1) + (i - 1) * p(1, i);
end
for i = 2 : 256
    u_j(i, 1) = u_j(i - 1, 1) + (1 - 1) * p(i, 1); 
end
for i = 2 : 256
    for j = 2 : 256
        u_j(i, j) = u_j(i - 1, j) + u_j(i, j - 1) - u_j(i - 1, j - 1) + (j - 1) * p(i, j);
    end
end

% 计算u_T0和u_T1
u_T0 = 0;
u_T1 = 0;
for i = 1 : 256
    for j = 1 : 256
        u_T0 = u_T0 + (i - 1) * p(i, j);
        u_T1 = u_T1 + (j - 1) * p(i, j);
    end
end

%% 求Hgradient
Hgradient = zeros(1, 256);

for m = 1:256
    pTemp = 0.0;
    for i = 1:256
        for j = 1:256
            if abs(i - j) == (m - 1)
                pTemp = pTemp + p(i, j);
            end
        end
    end
    Hgradient(m) = pTemp;
end

t = myOtsu(Hgradient);

%% 求Hnew
for y = 1:256
    % 原始灰度级投影
    p_yj = 0.0;
    % 领域均值灰度级投影
    p_iy = 0.0;
    
    for j = 1:256
        if abs(y - j) <= t
            p_yj = p_yj + p(y, j);
        end
        
    end
    
    for i = 1:256
        if abs(i - y) <= t
            p_iy = p_iy + p(i, y);
        end
    end
    
    Hnew(y) = p_yj + p_iy;
end
s = otsu_weight2(Hnew);

%% 使用新的阈值向量(s, t)分割图像
imgbw = ones(M, N);

for x = 1:M
    for y = 1:N
%         if abs(f(x, y) - g(x, y)) <= t && f(x, y) <= s
%             imgbw(x, y) = 0;
%         end
        
%         if abs(f(x, y) - g(x, y)) > t && g(x, y) <= s
%             imgbw(x, y) = 0;
%         end
        
        if f(x, y) + g(x, y) <= t + s
            imgbw(x, y) = 0;
        end


    end
end

imshow(imgbw, []);
