% 基于高斯尺度空间下的自适应阈值分割算法

% 本文采用的卷积窗大小为原始图像尺寸中短边的长度，
% 初始σ \sigmaσ=25，最大迭代数为25，迭代步长为sqrt(2)。

close;
clear;
f=imread('4.jpg');
% f=rgb2gray(f);
f=double(f);
f=f/255;
[m,n]=size(f);
figure('Name','原图'),imshow(f);
otsu_thresh=graythresh(f);
figure('Name','直接使用Otsu法分割'),imshow(f>=otsu_thresh);
figure('Name','原始图像直方图'),imhist(f);
%创建二维高斯尺度空间
%设置最大迭代次数
epoch=30;
%设置初始标准差
sigma=25;
%设置卷积窗大小
h=min(m,n);
%设置每层之间标准差的倍数
k=sqrt(2);
%初始化保存高斯尺度空间的矩阵
gaussian_space=zeros(m,n,epoch);
%高斯尺度空间的第一层
G=fspecial('gaussian',[h h],sigma);
gaussian_space(:,:,1)=imfilter(f,G,'replicate');
for i=2:epoch+1
    %更新sigma
    sigma=k*sigma;  
    %计算高斯卷积窗
    G=fspecial('gaussian',[h h],sigma);
    %高斯卷积
    gaussian_space(:,:,i)=imfilter(f,G,'replicate');
    %计算每两层之间的平均差值
    error=sum(abs(gaussian_space(:,:,i)-gaussian_space(:,:,i-1)),'all')/(m*n);
    %如果差值小于一个指定的阈值，则将前一层指定为估计的背景
    if error<=0.00001
        estim_background=gaussian_space(:,:,i-1);
        layer_num=i;
        break;
    end
    if i==epoch+1
        error('设置的最大迭代次数不够');
    end
end
figure('Name','高斯尺度空间的最顶层图像'),imshow(estim_background);
%计算各层目标图像的权值
omega=zeros(i-1,1);
for k=1:i-1
    omega(k)=k/sum(1:i-1);
end
%保存各层的目标图像
target=zeros(m,n,k);
for a=1:k
    target(:,:,a)=abs(f-gaussian_space(:,:,a));
end
%得到最终的目标图像
target_end=zeros(m,n);
for b=1:k
    target_end=omega(b)*target(:,:,b)+target_end;
end
figure('Name','目标图像直方图'),imhist(target_end);
figure('Name','目标图像'),imshow(target_end);
%对目标图像进行GAMMA校正，突出目标信息
target_end=target_end.^1.3;
figure('Name','Gamma校正后的图像'),imshow(target_end);
%对GAMMA校正后的图像进行OTSU阈值分割
otsu_target=graythresh(target_end);
figure('Name','最终的分割图'),imshow(target_end>=otsu_target);