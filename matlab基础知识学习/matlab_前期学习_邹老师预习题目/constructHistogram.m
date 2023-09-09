function [p] = constructHistogram()

img = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));
[m, n] = size(img);
p = zeros(1, 256);

for i = 1:m
    for j = 1:n
        p(img(i, j) + 1) = p(img(i, j) + 1) + 1;
    end
end

p = p/(m*n);
figure,plot(p, '*r-');