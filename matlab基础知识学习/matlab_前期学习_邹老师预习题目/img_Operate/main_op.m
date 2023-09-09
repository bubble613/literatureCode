clear;
clc;
img = imread('hehua.jpeg');
%将图像img转为二值图像
binimg = im2bw(img);
str = input('请输入图形学操作：','s');
%调用所定义函数Operate
img1 = Operate(binimg,str);
%由于部分形态学操作之后变化较小，这里判断下两张图是否相等
isequal(binimg,img1)
figure
%subplot(1,2,1);
%imshow(img);
%title('原图像');
subplot(121);
imshow(binimg);
title('二值图像');
subplot(122);
imshow(img1);
title('执行操作后的图像');
