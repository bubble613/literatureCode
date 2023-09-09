clc;close;clear;
% 求平均阈值分割的图像
img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
img = rgb2gray(img);
HistGram = imhist(img);
th = GetMeanThreshold(img, HistGram);

th = th / 255;
img_th = imbinarize(mat2gray(img), th);
imshow(img_th);


function [th] =  GetMeanThreshold(image, HistGram)
    sum = 0;
    amount = 0;
    for i = 1:256
        amount = amount + HistGram(i); %像素总数
        sum = sum + (i * HistGram(i)); %总期望
    end
    th = sum / amount; %平均期望
end
    