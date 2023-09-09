clc; 
clear all; 
close all; 

[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

% if size(image, 3) == 3
%     figure, imshow(image), title('Original Color Image');
%     image = rgb2gray(image);
% end

img=image; 
img_0=rgb2gray(img); 
img_1=imnoise(img_0,'salt & pepper',0.2);
img_2=medfilt2(img_1); 
subplot(2,2,1);
imshow(img);
title('原始图像'); 
subplot(2,2,2);
imshow(img_0);
title('灰度图像'); 
subplot(2,2,3);
imshow(img_1);
title('加入噪声后图像'); 
subplot(2,2,4);
imshow(img_2);
title('中值滤波后图像');