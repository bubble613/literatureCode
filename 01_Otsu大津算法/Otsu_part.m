clc;
clear;
[fn,pn,fi]=uigetfile('*.*','choose a picture');
Img=imread([pn, fn]);
Img_gray=rgb2gray(Img);
Img_bw = Otsu_partitial(Img_gray,1,2);%这里修改对应的函数
figure;
imshow(Img_bw);
imwrite(Img_bw, 'bw.jpg')


function [b1] = Otsu_partitial(gray_image, a, b)
% 采用局部二值化，各个局部采用otus法
[m, n] = size(gray_image);
result = zeros(m, n);
for i = 1:a:m
    for j = 1:b:n
        if ((i+a)>m)&&((j+b)>n)     %分块
            block1=gray_image(i:end, j:end); %右下角区块
        elseif ((i+a)>m)&&((j+b)<=n)
            block1=gray_image(i:end, j:j+b-1); %最右列区块
        elseif ((i+a)<=m)&&((j+b)>n)
            block1=gray_image(i:i+a-1, j:end);  %最下行区块
        else
             block1=gray_image(i:i+a-1, j:j+b-1); %普通区块
        end 
 
        [block,~]=binary_otus(block1);
        if ((i+a)>m)&&((j+b)>n)            %合并结果
            result(i:end,j:end)=block;
        elseif ((i+a)>m)&&((j+b)<=n)
           result(i:end, j:j+b-1)=block;
        elseif ((i+a)<=m)&&((j+b)>n)
            result(i:i+a-1 , j : end) = block;
        else
            result(i:i+a-1 , j:j+b-1) = block;
        end
    end
end 
 
b1 = result;
end