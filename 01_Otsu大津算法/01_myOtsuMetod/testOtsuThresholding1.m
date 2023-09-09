% 测试Otsu阈值分割
clc,clear; close all;

% 相关图像操作
[fileName,pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'; '*.tif'}, 'Select the original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if (size(image,3) == 3)  % 如果是三通道图像，将其转化为单通道图像
    figure,imshow(image),title('Original Color Image');
    image = im2double(rgb2gray(image));
end
    
% 2 计算直方图，并归一化直方图
Histogram = imhist(image);% 图像每个灰度级的像素数
Histogram = (Histogram / sum(Histogram))';% 归一化 将竖轴显示为每种灰度级的概率

% 3 使用OTSU方法进行阈值分割，并记录运行时间
tic;
threshold = myOtsu(Histogram);
runTime = toc;

% 4 根据选择的阈值进行二值化处理
[imgbw] = subim2bw(image, threshold);

NU = RegionNonuniformity(image, imgbw);
QQ = Q(image, imgbw);
Res = F(image, imgbw);

% 5 绘制结果图像
figure,
subplot(131), imshow(image), title('原始图像');
subplot(132), imhist(image), title('原始图像直方图');
subplot(133), imshow(imgbw), title('基于Otsu的阈值分割结果');
