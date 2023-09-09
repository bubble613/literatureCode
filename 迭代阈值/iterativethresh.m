%迭代法是一种比较简单的阈值分割方法，其思想：
%设置阈值的初始值为图像灰度最大值和最小值的平均，
%根据阈值划分图像为目标和背景，并分别将其灰度值求和，
%计算目标和背景的平均灰度，并判断阈值是否等于目标和背景平均灰度的和的平均，
%若相等，则阈值即为其平均，
%否则，将阈值设置为目标和背景灰度平局值的和的一半，继续迭代，直至计算出阈值。

close all;%关闭所有窗口  
clear;%清除变量的状态数据  
clc;%清除命令行  

I=imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');  
figure(1),
subplot(1,2,1);  
imshow(I);  
title('1 原图');
if ndims(I) == 3
    I = rgb2gray(I);
else
    I = I;
end
 

%迭代式阈值分割   
zmax = max(max(I)); %取出最大灰度值  
zmin = min(min(I)); %取出最小灰度值  
tk = (zmax + zmin) / 2;  
bcal = 1;  
[m, n] = size(I);  
while(bcal)  
    %定义前景和背景数  
    iforeground = 0;  
    ibackground = 0;  
    %定义前景和背景灰度总和  
    foregroundsum = 0;  
    backgroundsum = 0;  
    for i = 1:m  
        for j = 1:n  
            tmp = I(i, j);  
            if(tmp >= tk)  
                %前景灰度值  
                iforeground = iforeground+1;  
                foregroundsum = foregroundsum + double(tmp);  
            else  
                ibackground = ibackground+1;  
                backgroundsum = backgroundsum+double(tmp);  
            end  
        end  
    end  
    %计算前景和背景的平均值  
    z1 = foregroundsum/iforeground;  
    z2 = foregroundsum/ibackground;  
    tktmp = uint8((z1 + z2)/2); 
    
    if(tktmp - tk < eps)  
        bcal = 0;   
    end 
    tk = tktmp; 
    %当阈值不再变化时,说明迭代结束  
end  
disp(strcat('迭代的阈值:', num2str(tk)));%在command window里显示出 :迭代的阈值:阈值  
newI = imbinarize(I, double(tk) / 255);
%函数im2bw使用阈值（threshold）变换法把灰度图像（grayscale image）
subplot(1,2,2);  
imshow(newI);  
title('2 迭代分割');
figure(2),
subplot(121);
imshow(I); title('原图灰度图');
subplot(122);
imhist(I); title('灰度直方图');