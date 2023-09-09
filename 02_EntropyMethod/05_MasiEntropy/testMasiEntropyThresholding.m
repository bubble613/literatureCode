% 测试Tsallis熵阈值分割的程序
close all;clc, clear;

% 1 选取图像
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

% 1.1 如果是彩色图像直接转化为灰度图像
if size(image, 3) == 3
    figure, imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

% 2 直方图归一化
Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
r = 1.8;

% 3 利用Tsallis熵进行阈值选择并记录运行时间
tic;
threshold = masiEntropyThresholding(r, Histogram);
runTime = toc;

% 4 根据选取的阈值进行二值化处理
imgbw = subim2bw(image, threshold);

NU = RegionNonuniformity(image, imgbw);
QQ = Q(image, imgbw);
Res = F(image, imgbw);

% 5 绘制结果图像
figure,
subplot(221), imshow(image), title('Original gray-level image');
subplot(222), imhist(image), title('原始灰度直方图');
subplot(223), imshow(imgbw), title('熵阈值分割后的图像');

str1 = strcat('Masi熵参数r：', num2str(r));
str2 = strcat('最佳阈值：', num2str(threshold));
str3 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
% str3 = strcat('区域不均匀性NU=', num2str(NU));
% disp('result：');
str4 = strcat('区域不均匀性NU：', num2str(NU));
str5 = strcat('Q = ', num2str(QQ));
str6 = strcat('F = ', num2str(Res));

fprintf('result：%s; %s; %s.\n', str1, str2, str3);
fprintf('result：%s; %s; %s.\n', str4, str5, str6);