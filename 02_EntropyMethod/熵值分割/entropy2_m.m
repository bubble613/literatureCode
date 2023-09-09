% 一维最大熵

clc;clear;
image = imread('/Users/liwangyang/Desktop/matlab_doc/图片集/lena_std.tif');

if ndims(image)==3
    image = rgb2gray(image);
else
    image = image;
end

[height,width] = size(image);
figure(1),
subplot(121); imshow(image); title('原灰度图');
subplot(122); imhist(image); title('原灰度直方图');

hist = imhist(image);
p = hist / (height * width);
sum_P = cumsum(p);
sum_Q = 1 - sum_P;

c0 = zeros(256, 256);
c1 = zeros(256, 256);

for i = 1:256
    for j = 1:i
        if sum_P(i) > 0
            c0(i, j) = p(j) / sum_P(i);
        else
            c0(i, j) = 0;
        end
        
        for k = i + 1:256
            if sum_Q(i) > 0
                c1(i, k) = p(k) / sum_Q(i);
            else
                c1(i, k) = 0;
            end
        end
    end
end

H0 = zeros(256, 256);
H1 = zeros(256, 256);
for i = 1:256
    for j = 1:i
        if c0(i, j) ~= 0
            H0(i, j) = - c0(i, j) .* log10(c0(i, j));
        end
        
        for k = i + 1:256
            if c1(i, k) ~= 0
                H1(i, k) = - c1(i, k) .* log10(c1(i, k));
            end
        end
    end
end

HH0 = sum(H0, 2);
HH1 = sum(H1, 2);
H = HH0 + HH1;
[value, threshold] = max(H);
th = threshold / 255;

img_th = imbinarize(image, th);
figure(2),
imshow(img_th);
xlabel(['最大熵', num2str(threshold)]);
        
