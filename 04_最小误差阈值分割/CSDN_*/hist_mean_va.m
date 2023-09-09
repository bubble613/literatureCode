clc;clear;
A1=imread('hehua.jpeg');

subplot(4,4,1);imshow(A1);title('原图');

Ar=A1(:,:,1);%R通道 
Ag=A1(:,:,2);%G通道 
Ab=A1(:,:,3);%B通道 

subplot(4,4,4),imshow(A1(:,:,1));title('红色分量图'); %R通道 
subplot(4,4,7),imshow(A1(:,:,2));title('绿色分量图'); %G通道 
subplot(4,4,10),imshow(A1(:,:,3));title('蓝色分量图'); %B通道 

% subplot（A，B，K）可以在一张figure里显示多张图片，A，B意思是几行几列的图片，
% K是那行的第几个图，是图片的话后面用imshow，直方图用imhist()，，title是该小图的标题，
% 一般默认居中。

% h=imhist（f，b）；f为输入图像，b意为将0-256区间分为256/b个区间段；
% imhist( i );直接显示图像i的灰度直方图；
% imhist（i，n）n为指定灰度级显示直方图；
% [count, x] = imhist( i ) 获取直方图信息，count为每一级灰度像素个数，x为灰度级

subplot(4,4,5),imhist(Ar);title('红色分量直方图');
subplot(4,4,8),imhist(Ag);title('绿色分量直方图');
subplot(4,4,11),imhist(Ab);title('蓝色分量直方图');

subplot(4,4,6),imhist(Ar,10);title('红色指定灰度级');
subplot(4,4,9),imhist(Ag,25);title('绿色指定灰度级');
subplot(4,4,12),imhist(Ab,50);title('蓝色指定灰度级');

if length(size(A1))>2
    %size获得矩阵的大小，length获得矩阵最大维度
    A1=rgb2gray(A1);
end
%上面if语句可以自动判断是否为彩色图像，都会转化成二维的灰度图

subplot(4,4,2);imshow(A1);title('原图灰度化');
subplot(4,4,3);imhist(A1);title('原直方图');

%用imadjust对灰度图像进行灰度变换，用histeq进行直方图均衡处理
ima = imadjust(A1); %按默认参数进行对比度调整
his = histeq(A1); %按默认参数对直方图进行均衡化
subplot(4,4,13);imshow(ima);title('对比度默认拉伸图');
subplot(4,4,14);imhist(ima);title('对比度默认拉伸后的直方图');
subplot(4,4,15);imshow(his);title('灰度图均衡后图');
subplot(4,4,16);imhist(his);title('灰度图均衡后直方图');

%求图像矩阵均值、方差、信息熵
%求矩阵所有元素(像素)的和
[row,col] = size(A1);%获取行数 和 列数
A1 = double(A1);%要先转换成double 否则不能实现累加,matlab读入图像的数据是uint8，而matlab中数值一般采用double型（64位）存储和运算
sum = 0; 
for i = 1 : row
    for j = 1 : col
        sum = sum+A1(i, j);
    end
end
disp(sum);

%求均值
mid=sum/(row*col);
disp(['均值mid:',num2str(mid)]);

%求方差
s=0;
for x=1:row
    for y=1:col
        s=s+(A1(x,y)-mid)^2;%求得所有像素与均值的平方和。
    end
end
var=s/(row*col);%方差
disp(['方差var:',num2str(var)]);

%求信息熵，通信原理上面有
[M,N]=size(A1);
temp=zeros(1,256);%设置空白矩阵，用于记录概率，一行256列的0矩阵。
for m=1:M
    for n=1:N
        if A1(m,n)==0%如果数值为0
            i=1;%序号为1
        else
            i=A1(m,n);%否则为原来序号
        end
        
        temp(i)=temp(i) + 1;%统计每个灰度值出现的次数
    end
end

temp=temp / (M * N); % 所有值除以元素个数，表示概率 即公式中的P(i)
com=0;
for i=1 : length(temp)% 返回temp的行列中的最大值 即256
    if temp(i) == 0 % 如果概率为0 则不累加 0要单独处理
        
    else
        com=com - temp(i) * log2(temp(i));
    end
end
disp(['信息熵com:', num2str(com)]);