clc;close;clear;

A0=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

I=rgb2gray(A0);%转换为灰度图像
I=im2double(I);

se=strel('disk',10);
ft=imtophat(I,se);
Th=graythresh(ft);                        
Th;
G=im2bw(ft,Th);  

imshow(G),title('局部阈值分割效果图');