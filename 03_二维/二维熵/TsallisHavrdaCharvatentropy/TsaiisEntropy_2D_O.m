%% 清理命令
clear;
close all;

%% 导入图像，只支持灰度图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);
tic;

[M, N] = size(image);
figure,
imshow(image),
title('原始图像');
%% 计算平均邻域灰度的一维灰度直方图
% f存储原图
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
title('二维灰度直方图');

%% 计算P0
% 归一化二维直方图
h = h / (M * N);
% P0存储目标区域概率
P0 = zeros(256, 256);

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

% 计算全局Tsallis熵及最终阈值
q = 0.1;
for i = 1 : 255
    for j = 1 : 255
        if P0(i, j) == 0
            H_A(i, j) = 0;
        else
            H_A(i, j) = (1 - sum(sum(power(h(1 : i, 1 : j) ./ P0(i, j), q)))) / (q - 1);
        end
        
        if P1(i, j) == 0
            H_B(i, j) = 0;
        else
            H_B(i, j) = (1 - sum(sum(power(h(i + 1 : 256, j + 1 : 256) ./ P1(i, j), q)))) / (q - 1);
        end
        
        H_T(i, j) = H_A(i, j) + H_B(i, j) + (1 - q) * H_A(i, j) * H_B(i, j); 
    end
end

HT_max = 0;
% HT_max存储最大Tsaliis熵
HT_max = max(H_T(:));
s = 0;
t = 0;
for i = 1 : 255
    for j = 1 : 255
        if H_T(i, j) == HT_max
            s = i - 1;
            t = j - 1;
            continue;
        end
    end
end

HT_max
s
t

%% 展示图像
seg = ones(M, N);
for i = 1 : M
    for j = 1 : N
        if f(i, j) <= s && g(i, j) <= t
            seg(i, j) = 0;
        end
    end
end
figure,
imshow(seg);
toc