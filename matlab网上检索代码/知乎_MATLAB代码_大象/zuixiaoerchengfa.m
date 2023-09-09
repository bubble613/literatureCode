function chengxu()
%第1步
close all
I=imread('1.jpg');  %读取图像
I=rgb2gray(I);    %彩色图像转换成灰度图
 
% I=im2bw(I);      %二值化
I=edge(double(I)); %检测图像的边缘
figure
imshow(I)          %显示边缘检测的结果
 
%第2步
 
[m,n]=size(I);     %计算图像的尺寸
 
M=3;             %定义X方向分割的块数
N=3;             %定义Y方向分割的块数
mm=floor(m/M);   %子块行的长度
nn=floor(n/N);   %子块列的长度
count=1;         %计数器
figure
for i=1:M
    for j=1:N
        A=I((i-1)*mm+1:i*mm,(j-1)*nn+1:j*nn);    %分割原图像，得到一个子块
        subplot(M,N,count)
        imshow(A)               %显示一个子块
        zuoshangjiao=[(i-1)*mm+1 (j-1)*nn+1];  %子块左上角的坐标
        [x,y,k,b]=zikuai(A,zuoshangjiao);      %得到子块里白色像素点拟合得到的直线的斜率k和截距b（调用zikuai函数）
        X{count}=x;       %保存子块里所有白色像素的x坐标
        Y{count}=y;       %保存子块里所有白色像素的y坐标
        K(count)=k;       %保存子块里拟合得到的直线的斜率k
        B(count)=b;       %保存子块里拟合得到的直线的截距b
        count=count+1;    %计数器加1，进行下一个子块的计算
    end
end