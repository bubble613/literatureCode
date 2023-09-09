clear;
clc;
img=imread('hehua.jpeg');
I=rgb2gray(img);
J1=imnoise(I,'salt & pepper',0.03);
subplot(231),
imshow(I);
title('原始图像');
subplot(232),
imshow(J1);
title('添加椒盐噪声图像');
k1=medfilt2(J1);
subplot(233),
imshow(k1,[]);
title('椒盐噪声被过滤后的图像');
J2=imnoise(I,'gaussian',0.03);

subplot(234),
imshow(J2);
title('高斯噪声');
k2=medfilt2(J2);
subplot(235),
imshow(k2);
title('高斯噪声被过滤后的图像');