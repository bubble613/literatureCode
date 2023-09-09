% 测试Tsallis熵阈值分割
close all;
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if (size(image,3) == 3)  % 如果是三通道图像，将其转化为单通道图像
    figure,imshow(image),title('Original Color Image');
    image = rgb2gray(image);
end

Histogram = imhist(image);
Histogram = Histogram / sum(Histogram);
r = 0.8;
q = 0.9;

tic;
threshold = sharmaMittalEntropyThresholding(r, q, Histogram);
time = toc;
[imgbw] = subim2bw(image, threshold);

figure,subplot(2,2,1),
imshow(image),title('原始图像');
subplot(2,2,2),
imhist(image),title('原始图像直方图');
subplot(2,2,3),
imshow(imgbw),title('基于Sharma-Mittal Entropy的阈值分割结果');
subplot(2,2,4),
gtext(strcat('熵参数r = ',num2str(r))),
gtext(strcat('熵参数q = ',num2str(q))),
gtext(strcat('最佳阈值：',num2str(threshold))),
gtext(strcat(strcat('程序运行时间：',num2str(time)),'秒')),
title('最优阈值及其程序运行时间');