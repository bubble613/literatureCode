% function imgNoise = AddNoise(image, noiseType, ~)
%{
函数说明： 对灰度图添加噪声
函数参数：
        image：灰度图
函数返回值：
        imgNoise：添加噪声后的图像
-------------------------------------------------------------------
调用实例：
        imgNoise = AddNoise(image, noiseType)；
%}
% imgNoise = imnoise(image, noiseTypes);
% end

%% 清理命令
clear;
close all;

%% 导入图像，只支持灰度图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
path_fileName = strcat(pathName, fileName);
image = imread(path_fileName);

[M, N] = size(image);
figure,
imshow(image),
title('原始图像');

%% 向图片添加噪声

% J = imnoise(I,'gaussian',m,var_gauss) 添加高斯白噪声，均值为 m，方差为 var_gauss。
imgNg = imnoise(image,'gaussian');
imgNs = imnoise(image, 'salt & pepper', 0.1);
imwrite(imgNg, strcat('Ng', fileName));
imwrite(imgNs, strcat('Ns', fileName));
