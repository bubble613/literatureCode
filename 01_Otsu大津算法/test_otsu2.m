clc,clear;

I = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

% img = rgb2gray(I);

if ndims(I) == 3
    bin_img = rgb2gray(I);
else
    bin_img = I;
end

[height,width]=size(bin_img); 

Y1 = zeros(height, width); 
for i = 1 : height
    for j = 1 : width 
        X1(i, j) = bin_img(i, j); 
    end 
end 

level = my_otsu2(bin_img);
level_my = level / 255
level_gt = graythresh(bin_img) %graythresh计算出的阈值
% img2 = imbinarize(bin_img, level);

for i = 1 : height     
    for j = 1 : width     
        if X1(i, j) >= level        
            Y1(i, j) = 255; 
        else
            Y1(i, j) = 0;
        end 
    end 
end
%上面一段代码实现分割

figure(1),
imshow(bin_img);
title('原始灰度图像');
figure(2),
imshow(Y1);
title('灰度门限分割图像');
figure(3),
imhist(bin_img);%绘制直方图 
title('原灰度直方图');

