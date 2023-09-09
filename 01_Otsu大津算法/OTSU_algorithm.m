clear;clc;
I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'); %替换图片

a=rgb2gray(I);
% a=I;
figure(1),
imshow(a);

count = imhist(a);    %统计的是图像上对应像素值的个数            
[m, n]=size(a); 
count = count / (m * n); %归一化数据，概率百分比，每一个灰度级别的概率

figure(2),
[n] = imhist(a, 256);  %n是落在该灰度值的个数，xout是中心点的刻度
xout = 125;
bar(xout, n);
xlim([0 255]);      %把x轴的范围设置在0-255之间

%%%%%%%%%%%%%%%%%%%%%%%%%%
%方法1 
%   otsu法来求阈值分割图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%
E = [];   %E是一个行向量，存储中间变量的值
for TH = 1:1:256  %阈值从1开始计算   
    av0 = 0;
    av1 = 0;
    w0 = sum(count(1 : TH));  %统计  1~（阈值+1）处的总的概率和w0
    w1 = 1 - w0;
    %第一类  背景区域
    for i=1 : TH
        av0 = av0 + i * count(i);   % 求背景区域的平均灰度值
    end 
    u0 = av0 / w0;                 %平均灰度值/背景的总概率
    %第二类
    for i = TH+1:256
        av1 = av1 + i * count(i);   %这是一个计算前景均值的方法
    end 
    u1 = av1 / w1;      %平均灰度值/背景的总概率
    E(TH) = w0 * w1 * (u1 - u0) * (u1 - u0);   %将两者的平均值相加
end 
postion = find(E == max(E));  %找到E最大处的值的位置，这个位置就可以确定为阈值  
th = postion; 

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%
% %%   根据阈值来分割图像   %%
% %%%%%%%%%%%%%%%%%%%%%%%%%
%
for i = 1 : m
    for j = 1 : n
        if a(i, j) > th
            a(i, j) = 255;
        else 
            a(i, j) = 0;
        end 
    end 
end 
figure(3);
imshow(a)