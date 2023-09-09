%此为程序主文件，包含主要功能单元，以及对子函数进行调用 
close all;clear, clc;

try 

%% 实验步骤一：彩色、灰度变换 
h=imread('hehua.jpeg');    %读入彩色图片
c=rgb2gray(h);    %把彩色图片转化成灰度图片，256级 
figure,
imshow(c),title('原始图象');    %显示原始图象 
g=imnoise(c,'gaussian',0.1,0.002);    %加入高斯噪声 
figure,
imshow(g),title('加入高斯噪声之后的图象');    %显示加入高斯噪声之后的图象


%% 实验步骤二：用系统预定义滤波器进行均值滤波 
n=input('请输入均值滤波器模板大小\n'); 
A=fspecial('average',n); %生成系统预定义的3X3滤波器 
Y=filter2(A,g)/255; %用生成的滤波器进行滤波,并归一化 
figure,imshow(Y),title('用系统函数进行均值滤波后的结果'); %显示滤波后的图象


%% 实验步骤三:用自己的编写的函数进行均值滤波 
Y2=avefilt(g,n); %调用自编函数进行均值滤波，n为模板大小 
figure,
imshow(Y2),title('用自己的编写的函数进行均值滤波之后的结果'); 
%显示滤波后的图象


%% 实验步骤四:用Matlab系统函数进行中值滤波 
n2=input('请输入中值滤波的模板的大小\n'); 
Y3=medfilt2(g,[n2 n2]); %调用系统函数进行中值滤波，n2为模板大小 
figure,
imshow(Y3),title('用Matlab系统函数进行中值滤波之后的结果'); 
%显示滤波后的图象

%% 实验步骤五:用自己的编写的函数进行中值滤波 
Y4=midfilt(g,n2); %调用自己编写的函数进行中值滤波， 
figure,
imshow(Y4),title('用自己编写的函数进行中值滤波之后的结果');


%% 实验步骤六:用matlab系统函数进行高斯滤波 
n3=input('请输入高斯滤波器的均值\n'); 
k=input('请输入高斯滤波器的方差\n'); 
A2=fspecial('gaussian',k,n3); %生成高斯序列 
Y5=filter2(A2,g)/255; %用生成的高斯序列进行滤波 
figure,
imshow(Y5),title('用Matlab函数进行高斯滤波之后的结果'); 
%显示滤波后的图象


%% 实验步骤七:用自己编写的函数进行高斯滤波 
Y6=gaussfilt(n3,k,g); %调用自己编写的函数进行高斯滤波，n3为均值，k为方差 
figure,
imshow(Y6),title('用自编函数进行高斯滤波之后的结果'); 
%显示滤波后的图象 


catch %捕获异常 
    disp(lasterr); %如果程序有异常，输出 
end
