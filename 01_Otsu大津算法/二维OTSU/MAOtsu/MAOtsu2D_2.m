%% 清理命令
% 使用二维直方图在每一维上分别求s和t 
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

%% 向图片添加噪声

% J = imnoise(I,'gaussian',m,var_gauss) 添加高斯白噪声，均值为 m，方差为 var_gauss。
% imgNg = imnoise(image,'gaussian');
% imgNs = imnoise(image, 'salt & pepper', 0.1);
%% 扩展图像边缘
imgpad = padarray(image, [1 1], 'replicate', 'both'); % 扩展图像

%% 计算中值邻域灰度的一维灰度直方图
% f存储原图，此时转为double类型的数据便于计算
f = double(image);
% double(imgNs) double(imgNg) double(image)

% g存储平均邻域灰度的一维灰度直方图
g = zeros(M, N);
G = zeros(M, N);

% 窗口大小为1
w = 1;
temp = zeros(1 + 2*w);
% 遍历图像 使用3x3均值滤波平滑图像
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
                temp(k+2, m+2) = f(p, q);
                g(i, j) = median(median(temp));
                % g(i, j) = g(i, j) + f(p, q);
            end
        end
        % g(i, j) = (1 / 9) * g(i, j);
    end
end
% g = uint8(g);
figure, imshow(uint8(g)), title('中值邻域灰度后的图像');
% figure, subplot(121),imshow(image);subplot(122),imshow(g);

%% 计算平均邻域灰度的一维灰度直方图

% g存储中值邻域灰度的一维灰度直方图
% G存储中值后均值邻域灰度的一维灰度直方图
G = zeros(M, N);
% 窗口大小为1
w = 1;
% 遍历图像 使用3x3均值滤波平滑图像
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
                G(i, j) = G(i, j) + g(p, q);
            end
        end
        G(i, j) = (1 / 9) * G(i, j);
    end
end
G = uint8(G);
figure, imshow(G), title('中值-平均邻域灰度后的图像');
% figure,
% subplot(221),imshow(image);
% subplot(222),imshow(uint8(g));subplot(223),imshow(G);

%% 计算并展示二维直方图
% 将f的数据类型转换回来
f = uint8(f);
% h存储二维直方图，注意维度大小为灰度可能出现的最大值 每个灰度级（s，t）对 出现的频率
% Histogram = imhist(image);
% length(Histogram); =256 灰度级

h = zeros(256, 256);
for i = 1 : M
    for j = 1 : N
        p = f(i, j) + 1; 
        q = G(i, j) + 1;
        h(p, q) = h(p, q) + 1;
    end
end

figure,
mesh(h), xlim([0 256]), ylim([0 256]), title('二维灰度直方图');
% view(2);

%% 求每一维 f(x, y) and G(x, y) 的使用Otsu得到的阈值作为s 和 t 
Tf = graythresh(f);
TG = graythresh(G);
Tff = Tf * 256;
TGG = TG * 256;
s = uint8(Tff);
t = uint8(TGG);

%% 计算新方法的tr_Sigma_B 使用一维Otsu方法分别在二维直方图的每个维度确定最佳阈值

wi0 = sum(P0) / (256*256);
wi1 = sum(P1) / (256*256);
wj0 = sum(P0, 2) / (256*256);
wj1 = sum(P1, 2) / (256*256);

wi0 = P0; 
wj0 = P0;
wi1 = P1;
wj1 = P1;
U_T0 = u_T0;
U_T1 = u_T1;
U_i = u_i;
U_j = u_j;
U_j0 = (U_T0 - P0 .* U_i) ./ P1;
U_j1 = (U_T1 - P0 .* U_i) ./ P1;

for i = 1 : 256
    for j = 1 : 256
        if(P0(i, j) ~= 0 && P1(i, j) ~= 0)
            trSB(i, j) = P0(i, j) * power((U_i(i, j) - U_T0(i, j)), 2) + P1(i, j) * power((U_j(i, j) - U_T1(i, j)), 2);
        else
            trSB(i, j) = 0;
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
            break;
        end
    end
end

trSB_max
s
t

%% 展示图像
imgbw = ones(M, N);
seg1 = ones(M, N);
seg2 = ones(M, N);
for i = 1 : M
    for j = 1 : N
        if double(f(i, j)) + double(g(i, j)) <= s+t
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
subplot(121), imshow(seg1, []), title('鲁棒的二维Otsu分割后的图像');
subplot(122), imshow(seg2, []), title('二维Otsu分割后的图像');
str1 = strcat('二维Otsu类间方差最大：', num2str(trSB_max));
str2 = strcat('阈值（s）：', num2str(s));
str3 = strcat('阈值（t）：', num2str(t));
% str4 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
fprintf('result：%s; %s; %s.\n', str1, str2, str3);