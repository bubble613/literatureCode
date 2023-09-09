clc;
clear;
close all;
img=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

I=double(img(:,:,1));
fxy=zeros(1,256);
[m,n]=size(I);
for i=1:m
    for j=1:n
        c=I(i,j);
        fxy(c+1)=fxy(c+1)+1;
    end
end
figure(1);plot(fxy);
p1={'Input Num:'};
p2={'180'};
p3=inputdlg(p1,'Input Num:1-256',1,p2);
p=str2num(p3{1});
for i=1:m
    for j=1:n
        if I(i,j)<p
            image1(i,j)=0;
        else
            image1(i,j)=1;
        end
    end
end

imshow(image1);title('p参数法阈值分割效果图 ');