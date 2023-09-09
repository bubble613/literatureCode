clear;
clc;
I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'); %替换图片

a=rgb2gray(I);
% a=I;
figure(1),
subplot(221);
imshow(a);
subplot(222);
imhist(a);
subplot(223);
imshow(I);
subplot(224);
imhist(I);

% count = imhist(a);    %统计的是图像上对应像素值的个数，是1-256的列向量            
% [m, n]=size(a); 
% count = count / (m * n); %归一化数据，概率百分比，每一个灰度级别的概率

b = Histogram_equalization1(a);
c = Histogram_equalization1(I);
figure(2),
subplot(121);
imshow(b);
subplot(122);
imhist(b);

figure(3),
subplot(121);
imshow(c);
subplot(122);
imhist(c);

function [output] = Histogram_equalization1(input_image)
    if numel(size(input_image)) == 3   %如果图像为rgb图像
        %this is a RGB image
        %here is just one method, if you have other ways to do the
        %equalization, you can change the following code
        r=input_image(:,:,1);
        v=input_image(:,:,2);
        b=input_image(:,:,3);
        r1 = hist_equal(r);
        v1 = hist_equal(v);
        b1 = hist_equal(b);
        output = cat(3,r1,v1,b1);    
    else                              %图像为灰值图像
        [output] = hist_equal(input_image);  
    end
    
    function [output2] = hist_equal(input_channel)
        [m,n]=size(input_channel);
        output2=zeros(m,n);
        N=zeros(256,1);
        P=zeros(256,1);
        C=zeros(256,1);
        for i=1:m                    %统计各灰度级个数
            for j=1:n
                N(input_channel(i,j)+1)=N(input_channel(i,j)+1)+1;
            end
        end
        for i=1:256                 %计算原始图像直方图各灰度级的频度
            P(i)=N(i)/(m*n);
        end
        C(1)=P(1);                  %计算累计分布函数
        for i=2:256
            C(i)=C(i-1)+P(i);
        end
        for i=1:m                   %通过映射关系获得输出直方图
            for j=1:n
                output2(i,j)=floor(255*C(input_channel(i,j)+1)+0.5);
            end
        end
        
        output2=uint8(output2);
    end
end 

