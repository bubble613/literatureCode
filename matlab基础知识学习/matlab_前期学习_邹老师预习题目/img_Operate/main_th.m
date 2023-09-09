clear;
clc;
img1= imread('hehua.jpeg');
img2 = rgb2gray(img1);
t1 = 128;
img3 = Thresholding(img2,t1)
figure
subplot(121);
imshow(img2);
title('灰度图像');
subplot(122);
imshow(img3);
title('二值化分割后的图像');