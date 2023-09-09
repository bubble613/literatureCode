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

[height, width] = size(bin_img);
N = height * width;
count = imhist(bin_img);
count = count / N;

Histogram = zeros(1, 256);
% Histo = zeros(1, 256);
for i = 1 : height
    for j = 1 : width
        Histogram(bin_img(i, j) + 1) = Histogram(bin_img(i, j) + 1) + 1;
%         Histo(bin_img(i, j) + 1) = Histogram(bin_img(i, j) + 1) / N;
    end
end

figure(2),
imhist(bin_img); title('原灰度图直方图'); %自定义绘制直方图函数

graySum = 0;
for i=1:256
    graySum = graySum + Histogram(i)*(i-1);
end

m1 = 0;
n2 = 0;
n1 = 0;
n1sum = 0;
n2sum = 0;
Et1 = 0;
Et2 = 0;
temp = 256;
T = zeros(1, 256);

for i=1 : 256
    n1 = n1 + Histogram(i); %阈值为i时前景个数
    n2 = N - n1; %阈值为i时背景个数
    
    w0 = n1 / N; %前景像素占总数比
    w1 = n2 / N; %背景像素占总数比
    if n1 == 0
        continue
    end
    if n2 == 0
        break
    end
    %前景平均灰度
    n1sum = n1sum + Histogram(i) * (i - 1);
    m1 = n1sum / n1;
    Et1 = Et1 + (i - m1).^2;
    %背景平均灰度
    n2sum = graySum - n1sum;
    m2 = n2sum / n2;
    Et2 = Et2 + (i - m2).^2;
    
%     g = w0*w1*(m1-m2)*(m1-m2);
    Et = ((1 / (n1 - 1)) .* Et1) + ((1 / (n2 - 1)) .* Et2);
    
    if (Et < temp)  
         temp = Et;
         if(i-1 > m2)
             T(i) = i-1;
         end
    end 
    
end

my_t = find(T > 0, 1 );

my_t = (my_t - 1) / 255

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
figure(3),

imshow(bw); title('自编函数阈值划分后的灰度图');
