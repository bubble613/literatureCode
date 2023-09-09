clc,close,clear;

img1 = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_bw.jpg'));

img = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');
img2 = im2double(rgb2gray(img));

[t, em] = graythresh(img2);
t1 = t*255
em
img3 = imbinarize(img2, t);
img3 = im2double(img3);

[length, width] = size(img2);
count = imhist(img2);

img6 = im2double(imread('junyun1.tiff'));
% img5 = im2double(~(img3 - img6));

%% img5 = img3 - img6;

for i = 1:length
    for j = 1:width
        if img3(i, j) - img6(i, j) < 0
            img5(i, j) = 2;
        elseif img3(i, j) - img6(i, j) > 0
            img5(i, j) = 0;
        else
            img5(i, j) = 1;
        end
    end
end

img7 = edge(img5, 'sobel');

imshow(img5, [])

%% 计算欧氏距离
OrginImage_Gray_Eu = rgb2gray(OrginImage); %将图片转为灰度图
h = imhist(OrginImage_Gray_Eu); %原始灰度图每种灰度级像素个数

Count = imhist(ThreshImage); %阈值灰度图每种灰度级像素个数

EulerDistance = sqrt(sum((h - Count) .* (h - Count))); %计算欧氏距离

