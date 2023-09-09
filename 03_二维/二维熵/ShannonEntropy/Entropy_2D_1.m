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
figure,
imshow(image),
title('原始图像');

% 计算平均邻域灰度的一维灰度直方图
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

% 计算并展示二维直方图
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
title('二维灰度直方图');

% 求P0
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

% Entropy
Hst = zeros(256);
% 求Hst = - pij * ln(pij)
HTemp = 0;
for i = 1 : 256
    for j = 1 : 256
        if h(i, j) ~= 0
            for m = 1 : i
                for n = 1 : j
                    % Hst(i, j) = 0;
                    if h(m, n) ~= 0
                        HTemp = HTemp + (h(m, n) * log(h(m, n)));
                    end
                end
            end
            % HTemp = -HTemp;
            Hst(i, j) = -HTemp;
        else
            Hst(i, j) = 0;
        end
    end
end

% 求Hmm （假定远离对角线的像素的灰度值的概率为0）
% Hmm = zeros(256);
Hmm = 0;
for i = 1 : 256
    for j = 1: 256
        if h(i, j) ~= 0
            Hmm = Hmm + (h(i, j) * log(h(i, j)));
        end
    end
end
Hmm = -Hmm;

HA = zeros(256);
HB = zeros(256);
for i = 1:256
    for j = 1:256
        for s = 1 : i
            for t = 1 : j
                if P0(s, t) ~= 0 && h(s, t) ~= 0
                    HA(i, j) = HA(i, j) - (h(s, t) / P0(s, t)) * log(h(s, t) / P0(s, t));
                end
            end
        end
        
        for s = i+1 : 256
            for t = j+1 : 256
                if P0(s, t) ~= 1 && h(s, t) ~= 0
                    HB(i, j) = HB(i, j) - (h(s, t) / (1 - P0(s, t))) * log(h(s, t) / (1 - P0(s, t)));
                end
            end
        end
        
    end
end


fi = HA + HB;

% for i = 1 : 256
%     for j = 1 : 256
%         if P0(i, j) ~= 0 && P1(i, j) ~= 0
%             % trSB(i, j) = ((u_T0 * P0(i, j) - u_i(i, j))^2 + (u_T1 * P0(i, j) - u_j(i, j))^2) / (P0(i, j) * P1(i, j));
%             fi(i, j) = log((P0(i, j)) * (1 - P0(i, j))) + Hst(i, j) / (P0(i, j)) + (Hmm - Hst(i, j)) / (1 - P0(i, j));
%         else
%             fi(i ,j) = 0;
%         end
%     end
% end

% fi_max存储最大的类间方差
fi_max = max(fi(:));
s = 0;
t = 0;
for i = 1 : 256
    for j = 1 : 256
        if fi(i, j) == fi_max
            s = i - 1;
            t = j - 1;
            continue;
        end
    end
end

fi_max
s
t

%% 展示图像
img_p = double(f) + double(g);
seg1 = ones(M, N);
seg2 = ones(M, N);
for i = 1 : M
    for j = 1 : N
        if img_p(i, j) <= s+t
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
subplot(121), imshow(seg1), title('鲁棒的二维分割后的图像');
subplot(122), imshow(seg2), title('普通二维分割后的图像');