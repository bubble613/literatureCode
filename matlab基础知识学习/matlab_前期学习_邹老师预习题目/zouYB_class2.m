clc,clear;close all;

img = rgb2gray(imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif'));

w = 1/9*ones(3, 3);
[m, n] = size(img);

img2 = zeros(m+4, n+4);
img2(3:end-2, 3:end-2) = double(img);

outputimg = zeros(m+4, n+4);

for x = 2:m+3
    for y = 2:n+3
%         outputimg(x, y) = img2(x - 1, y - 1)*w(1, 1) + img2(x - 1, y)*w(1, 2) + img2(x - 1, y + 1)*w(1, 3) +...
%                     img2(x, y - 1)*w(2, 1) + img2(x, y)*w(2, 2) + img2(x, y + 1)*w(2, 3) +...
%                     img2(x + 1, y - 1)*w(3, 1) + img2(x + 1, y)*w(3, 2) + img2(x + 1, y + 1)*w(3, 3);
          outputimg(x-1:x+1, y-1:y+1) = img2(x-1:x+1, y-1:y+1) .* w;

    end
end
outputimg2 = outputimg(3:m+2, 3:n+2);

figure,
imshow(img);
% title('Original image');
figure,
imshow(outputimg);
% title('non-proery result');
figure,
imshow(mat2gray(outputimg));
% title('smoothing result');
figure,
imshow(mat2gray(outputimg2));
% title('分割后');


