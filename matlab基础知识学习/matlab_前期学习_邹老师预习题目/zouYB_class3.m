clc;clear;close all;

img = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));

imgcopy = img;
imgcopy2 = img;

imgcopy(1:end-1, :) = img(2:end, :);
diff = double(imgcopy) - double(img);
figure,imshow(mat2gray(abs(diff)));

imgcopy2(:, 1:end-1) = img(:, 2:end);
diff2 = double(imgcopy2) - double(img);
figure,imshow(mat2gray(abs(diff2)));

grad = sqrt(diff.^2 + diff2.^2);
figure,imshow(mat2gray(grad));

