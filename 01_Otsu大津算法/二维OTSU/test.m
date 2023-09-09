% 测试二维OTSU阈值分割的程序
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

% 3 使用二维OTSU方法分割图像并显示运行时间
tic;
threshold = OTSU2D(image);
runTime = toc;

% 4 根据选取的阈值进行二值化处理
imgbw = subim2bw(image, threshold);
figure,
imshow(imgbw);

% 5 绘制结果图像
% figure,
% subplot(221), imshow(image), title('Original gray-level image');
% subplot(222), imhist(image), title('原始灰度直方图');
% subplot(223), imshow(imgbw), title('二维OTSU阈值分割后的图像');
% 
% str1 = strcat('OTSU：', num2str());
% str2 = strcat('最佳阈值：', num2str(threshold));
% str3 = strcat(strcat('程序运行时间：', num2str(runTime)), '秒');
% % disp('result：');
% 
% fprintf('result：%s; %s; %s.\n', str1, str2, str3);
% fprintf('result：%s; %s; %s.\n', str4, str5, str6);