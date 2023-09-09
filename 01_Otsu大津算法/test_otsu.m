clc,clear;

I = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

% img = rgb2gray(I);
% img = im2bw(img, level);%根据阈值level划分图像
if ndims(I) == 3
    bin_img = rgb2gray(I);
else
    bin_img = I;
end
level = my_otsu(bin_img)%x就是所得阈值
level_gt = graythresh(bin_img)%graythresh计算出的阈值

img1 = imbinarize(bin_img, level_gt);
img2 = imbinarize(bin_img, level);
figure(1);clf;

subplot(121);
imshow(bin_img);title('原始灰度图像');
subplot(122);
imhist(bin_img); title('原始灰度图像直方图');
figure(2);clf;
subplot(121);  
imshow(img1,[]);  title('matlab内置graythresh');
subplot(122);  
imshow(img2,[]);  title('自编最大类间方差');
% figure(3),
% subplot(121);
% imhist(img1); title('内置函数划分图像直方图');
% subplot(122);
% imhist(img2); title('自编函数划分图像直方图');

