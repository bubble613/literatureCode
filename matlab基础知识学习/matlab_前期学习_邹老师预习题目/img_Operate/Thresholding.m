function [i] =Thresholding(img,t)
%获取img的大小
[m,n] = size(img);
%将输入图像img赋值给输出图像i
i = img;
%对输入图像img进行完全遍历
for p = 1:m;
    for q = 1:n;
        %若img当前像素大于t，则将其处理为最白灰度级
        if img(p,q)>t
            i(p,q)=256;
        %若img当前像素小于t，则将其处理为最黑灰度级
        else
            i(p,q)=0;
        end
    end
end
end