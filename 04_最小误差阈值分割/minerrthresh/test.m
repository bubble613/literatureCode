clc,clear;

img = rgb2gray(imread('hehua.jpeg'));

thresh = minerrthresh(img,'Gaussian');

a = im2bw(img, thresh/256);

subplot(121),
imshow(img);
title('原始图像');
subplot(122),
imshow(a);
title('阈值分割');