clc,clear;

y_img=imread("/Users/liwangyang/Desktop/matlab_doc/图片集/Peppers.tif");

figure(1),
subplot(121); imshow(y_img); title('原图');
if ndims(y_img) == 3
    bin_img = rgb2gray(y_img);
else
    bin_img = y_img;
end
subplot(122); imshow(bin_img); title('原图灰度图');

[height, width] = size(bin_img);
N = height * width;
count = imhist(bin_img);
count = count / N;

Histogram = zeros(1, 256);

for i = 1 : height
    for j = 1 : width
        Histogram(bin_img(i, j) + 1) = Histogram(bin_img(i, j) + 1) + 1;
    end
end


figure(2),
imhist(bin_img); title('原灰度图直方图'); %自定义绘制直方图函数

graySum = 0;
for i=1:256
    graySum = graySum + Histogram(i)*(i-1);
end

n0 = 0;
n0sum = 0;
temp = 0;

for i=1:256
    n0 = n0 + Histogram(i); %阈值为i时前景个数
    n1 = N - n0; %阈值为i时背景个数
    w0 = n0 / N; %前景像素占总数比
    w1 = n1 / N; %背景像素占总数比
    if n0 == 0
        continue
    end
    if n1 == 0
        break
    end
    %前景平均灰度
    n0sum = n0sum + Histogram(i) * (i - 1);
    mu0 = n0sum / n0;
    %背景平均灰度
    n1sum = graySum-n0sum;
    mu1 = n1sum/n1;
    
    g = w0*w1*(mu0-mu1)*(mu0-mu1);
    % 找出最大的阈值
    if g > temp  
         temp = g;
         T = i-1;   
    end
end

my_t = T / 255

%二值化
bw = zeros(height, width);
for i = 1:height
    for j = 1 : width
        if bin_img(i, j) > T
            bw(i, j) = 255;
        else
            bw(i, j) = 0;
        end
    end
end

t_origin = graythresh(bin_img)

img_gt = imbinarize(bin_img, t_origin);

figure(3),
subplot(121);
imshow(bw); title('自编函数阈值划分后的灰度图');
subplot(122);
imshow(img_gt); title('graythresh划分后的灰度图');

figure(4),
imhist(Histogram, 256);