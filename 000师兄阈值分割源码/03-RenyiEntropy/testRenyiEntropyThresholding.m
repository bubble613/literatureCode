% 测试Renyi熵阈值分割的程序
close all;

% 1、选取图像（限定灰度图像）
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

%   1.1、如果是彩色图像直接转化为灰度图像
if (size(image,3) == 3)  % 如果是三通道图像，将其转化为单通道图像
    figure,imshow(image),title('Original Color Image');
    image = rgb2gray(image);
end

% 2、计算直方图并归一化
Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
alpha = 1.1;

% 3、利用Renyi熵进行阈值选择并记录时间
tic;
threshold = renyiEntropyThresholding(alpha, Histogram);
time = toc;

% 4、根据选取的阈值进行二值化处理
[imgbw] = subim2bw(image, threshold);

% 5、绘制并展示图像
figure, subplot(2, 2, 1),
imshow(image), title('原始图像');
subplot(2, 2, 2),
imhist(image), title('原始图像直方图');
subplot(2, 2, 3),
imshow(imgbw), title('基于Renyi熵的阈值分割结果');
subplot(2, 2, 4),
gtext(strcat('熵参数alpha = ', num2str(alpha))),
gtext(strcat('最佳阈值threshold = ', num2str(threshold))),
gtext(strcat(strcat('程序运行时间：', num2str(time)), '秒')),
title('最优阈值及其程序运行时间');