% 测试Renyi熵阈值分割图像
close all;
clc, clear;

% 1 选取图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the Original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);
% 对非灰度图进行转化
if (size(image, 3) == 3)
   figure, imshow(image), title('original color image');
   image = rgb2gray(image);
end

% 2 计算直方图并且归一化
Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
alpha = 0.9;

% 3 运用Renyi熵进行阈值分割并记录程序运行时间
tic;
threshold = renyiEntropyThresholding(alpha, Histogram);
runTime = toc;

% 4 用Renyi熵分割图像
[imgbw] = subim2bw(image, threshold);

% 5 绘制结果图像，并显示结果
figure,
subplot(221), imshow(image), title('原始灰度图');
subplot(222), imhist(image), title('原始灰度直方图');
subplot(223), imshow(imgbw), title('Renyi熵分割后的二值化图像');

str1 = strcat('Renyi熵参数：', num2str(alpha));
str2 = strcat('最佳阈值：', num2str(threshold));
str3 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
% str3 = strcat('区域不均匀性NU=', num2str(NU));
% disp('result：');
fprintf('result：%s; %s; %s.\n', str1, str2, str3);
