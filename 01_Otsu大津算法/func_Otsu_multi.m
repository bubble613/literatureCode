
%多阈值分割
clc;
clear all;

Image = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
Image = rgb2gray(Image);
Image2 = Image;
Image = double(Image);
figure(1),
imshow(uint8(Image)),title('原图','fontsize',16);
% 求解灰度图相关参数
[m, n]=size(Image);
Image = double(Image);
Th = 161; % 自定义阈值
count = zeros(256,1);
pcount = zeros(256,1);
for i = 1:m
    for j = 1:n
        pixel = Image(i, j);
        count(pixel + 1) = count(pixel + 1) + 1; %计算每个灰度值的个数
    end
end
dw = 0;
x = 0;
for i=1:m
    for j=1:n
        if(Image(i, j) < Th)
            x = x+1; % 像素灰度级小于阈值的个数
        end
    end
end

% 背景像素的期望
for i = 0 : Th
    pcount(i+1) = count(i+1)/x;%计算每个灰度值在总矩阵中所占的比例，存放在pcount中
    dw = dw + i*pcount(i+1);%计算出图像总体的灰度均值
end

Th1 = 0;%初始化阈值从0开始遍历
ThBest = 0;%初始化最佳阈值为0
dfc = 0;
dfcmax = 0;
while(Th1 >= 0 && Th1 <= Th)%while循环找出最佳阈值
    dp1 = 0;
    dw1 = 0;
    for i = 0:Th1
        dp1 = dp1 + pcount(i+1);%计算出小于Th阈值的比例
        dw1 = dw1 + i*pcount(i+1);%算出小于阈值Th部分的灰度均值
    end
    if dp1 > 0%如果小于Th阈值的比例不为0
        dw1 = dw1/dp1;
    end
    
    dp2=0;
    dw2=0;
    for i=Th1+1:Th
        dp2=dp2+pcount(i+1);%计算出大于Th阈值的比例
        dw2=dw2+i*pcount(i+1);%算出大于阈值Th部分的灰度均值
    end
    if dp2>0
        dw2=dw2/dp2;
    end
    
    dfc = dp1*(dw1-dw)^2+dp2*(dw2-dw)^2;%计算类间方差
    if dfc >= dfcmax %去类间方差的最大值作为最佳阈值
        dfcmax = dfc;
        ThBest = Th1;
    end
    
    Th1=Th1+1;
end

T1 = ThBest;
T1

Th=161;
count1=zeros(256,1);
pcount1=zeros(256,1);
for i=1:m
    for j=1:n
        pixe2=Image2(i,j);
        count1(pixe2+1)=count1(pixe2+1)+1; %计算每个灰度值的个数
    end
end
dw=0;
x=0;
for i=1:m
    for j=1:n
        if(Image2(i,j)>Th)
            x=x+1;
        end
    end
end
for i=Th:255
    pcount1(i+1)=count1(i+1)/x;%计算每个灰度值在总矩阵中所占的比例，存放在pcount中
    dw=dw+i*pcount1(i+1);%计算出图像总体的灰度均值
end
Th2=Th;%初始化阈值从0开始遍历
ThBest=0;%初始化最佳阈值为0
dfc=0;
dfcmax=0;
while(Th2>=Th && Th2<=255)%while循环找出最佳阈值
    dp1=0;
    dw1=0;
    for i=Th:Th2
        dp1=dp1+pcount1(i+1);%计算出小于Th阈值的比例
        dw1=dw1+i*pcount1(i+1);%算出小于阈值Th部分的灰度均值
    end
    if dp1>0%如果小于Th阈值的比例不为0
        dw1=dw1/dp1;
    end
    dp2=0;
    dw2=0;
    for i=Th2+1:255
        dp2=dp2+pcount1(i+1);%计算出大于Th阈值的比例
        dw2=dw2+i*pcount1(i+1);%算出大于阈值Th部分的灰度均值
    end
    if dp2>0
        dw2=dw2/dp2;
    end
    dfc=dp1*(dw1-dw)^2+dp2*(dw2-dw)^2;%计算类间方差
    if dfc>=dfcmax %去类间方差的最大值作为最佳阈值
        dfcmax=dfc;
        ThBest=Th2;
    end
    Th2=Th2+1;
end
T2=ThBest;
T2

I3 = Image2;
for i=1:m
    for j=1:n
        
        if (Image2(i,j)>=0 && Image2(i,j)<T1)
            I3(i,j)=255;
        elseif(Image2(i,j)>=T1 && Image2(i,j)<Th)
            I3(i,j)=170;
        elseif(Image2(i,j)>=Th && Image2(i,j)<T2)
            I3(i,j)=85;
        elseif(Image2(i,j)>=T2 && Image2(i,j)<255)
            I3(i,j)=0;
        end
        
    end
end

figure(2);
imshow(I3),title('Ostu多阈值分割','fontsize',16);