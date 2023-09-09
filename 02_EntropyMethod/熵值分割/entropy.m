% Kapuret
% A New Method forGray-Level Picture ThresholdingUsing the Entropy of the Histogram
% 使用图像熵值分割

clear;
clc;
I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'); %替换图片

a=rgb2gray(I);
% a=I;
figure(1),
imshow(a);

count = imhist(a);    %统计的是图像上对应像素值的个数，是1-256的列向量            
[m, n]=size(a); 
count = count / (m * n); %归一化数据，概率百分比，每一个灰度级别的概率


function thresh=threshEntropy(input)
maxh=0;thresh=0;
%input=imread('D:/MATLAB/code/DIP/Image/cameraman.jpg');
input=double(input);
input=round((input-min(input(:)))/(max(input(:))-min(input(:)))*255);
for i=0:max(input(:))-1
    P1=length(input(input<=i))/length(input(:));
    P2=1-P1;h1=0;h2=0;h=0;
    for j=0:i
        p1=length(input(input==j))/length(input(:));
        if p1==0
            continue;
        else
        h1=h1-p1/P1*log(p1/P1);
        end
    end
    for k=i+1:max(input(:))-1
        p2=length(input(input==k))/length(input(:));
        if p2==0
            continue;
        else
            h2=h2-p2/P2*log(p2/P2);
        end
    end
    h=h1+h2;
    if h>maxh
        maxh=h;
        thresh=i;
    end
end