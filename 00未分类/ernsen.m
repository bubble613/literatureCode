clc;
clear all;
[fn pn fi]=uigetfile('*.*','choose a picture');
Img=imread([pn fn]);
Img_gray=rgb2gray(Img);
Img_bw=binary_bernsen(Img_gray);%这里修改对应的函数
figure;
imshow(Img_bw);
imwrite(Img_bw,'bw.jpg')

function [ b1 ] = binary_bernsen( f1 )
% 局部二值化方法，局部区域采用简单阈值。
[m,n]=size(f1);
s = 15; %根据实际情况设定
t1 = 20; %根据实际情况设定
exI = uint8(ones(m+ 1, n+ 1));%扩展图片，预分配一个矩阵
re = uint8(ones(m, n));
exI(1:m+ 1, 1: n+ 1) = f1;%把原图片赋给矩阵
%==========对矩阵进行填充==========%
exI( , : )=exI( , : );
exI(m+ , :)=exI(m+ , :);
exI( : , )=exI( : , );
exI(:, n+ )=exI(:, n+ );
 
for i= : m +
    for j= : n +
        %===========求3*3区域内的阈值并对图像进行二值化，结果存在re中==========%
        ma=max(max(exI(i- : i+, j- : j+)));
        mi=min(min(exI(i-:i+,j-:j+)));
        t=(ma+mi)/;
        if ma-mi>s
             if exI(i,j)>t
                 re(i-,j-)=;
             else
                re(i-,j-)=;
             end
        else
            if t>t1
                re(i-,j-)=;
             else
                re(i-,j-)=;
            end
        end
 
    end
end
 
b1=re;

end