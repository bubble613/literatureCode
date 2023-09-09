clc;close;clear;
img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

I=rgb2gray(img);%转换为灰度图像  
I=double(I);
T=(min(I(:))+max(I(:)))/2;
done=false;
i=0;
while ~done 
   r1 = find(I <= T);
   r2 = find(I > T);
   Tnew = (mean(I(r1)) + mean(I(r2)))/2;
   done = abs(Tnew - T)<1;
   T = Tnew;
   i = i+1;
end
I(r1)=0;
I(r2)=1;

imshow(I);
title('迭代法阈值分割效果图');