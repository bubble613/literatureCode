% function threshold=th_DA(vHist, m, n) % 求不为零的灰度值的概率
% 
% P= vHist(find(vHist > O)) / (m * n); % 求不为零的灰度值概率倒数的加权累加和
% cl = sum((find(vHist > 0)) ./ p); % 求不为零的灰度值概率倒数的累加和
% c2 = sum(ones(size(p)) ./ p); % 求出灰度值的加权平均值，即为待求阈值
% threshold = cl / c2;
% end

clc,clear;

y_img=imread("/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif");

figure(1),
subplot(121); imshow(y_img); title('原图');
if ndims(y_img) == 3
    bin_img = rgb2gray(y_img);
else
    bin_img = y_img;
end
subplot(122); imshow(bin_img); title('原图灰度图');

% X为待处理图像，map为图像的调色板
h_p = imhist(bin_img); 

[m, n] = size(bin_img); %直方图尺寸 m*n


p = h_p(find(h_p > 0)) / (m * n); % 求不为零的灰度值概率倒数的加权累加和
c1 = sum((find(h_p > 0)) ./ p); % 求不为零的灰度值概率倒数的累加和
c2 = sum(ones(size(p)) ./ p); % 求出灰度值的加权平均值，即为待求阈值
threshold = c1 / c2;

level = threshold / 255
img_th = imbinarize(bin_img, level);
figure(2),
imshow(img_th); title('直方图双峰阈值分割图像');