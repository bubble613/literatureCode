clear, clc;
img1 = imread('hehua.jpeg');
img2 = rgb2gray(img1);  %将RGB图转换为灰度图
[M,N] = size(img2);  %获取原始图像大小
img2 = double(img2);  %将图像转为double类型,conv2函数不支持uint8类型数据

k1 = [1, 1, 1;1, 1, 1;1, 1, 1]/9;  %大小3X3的均值滤波器
gaussian = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 16;  % Gaussian 模板
laplacian = [0, 1, 0; 1, -4, 1; 0, 1, 0];  % Laplacian 模板
filter = zeros(size(img2));  % 滤波器大小与图像大小一致
filter_avg = filter;  filter_avg(1:3, 1:3) = k1;
filter_gau = filter;  filter_gau(1:3, 1:3) = gaussian;
filter_lap = filter;  filter_lap(1:3, 1:3) = laplacian;

%调用conv2函数实现卷积
img_same = uint8(conv2(img2,k1,'same'));  %与图像大小相同的卷积
img_full = uint8(conv2(img2,k1,'full'));  %完全卷积
% 使用自带卷积函数
img_gau_conv = uint8(conv2(img2, gaussian, 'same'));
img_lap_conv = uint8(conv2(img2, laplacian, 'same'));

figure(1),
subplot(131);  imshow(uint8(img2));  title('原图像');
subplot(132);  imshow(img_same);  title('与图像大小相同的卷积');
subplot(133);  imshow(img_full);  title('完全卷积')

%不调用conv2函数进行卷积
n = size(filter_avg,1); %获得滤波器的边长
halfn = floor(n/2); %向下取整
img_n_conv = zeros(M,N);

%不考虑边缘进行卷积
for i = 1+halfn:M-halfn
    for j = 1+halfn:N-halfn
        img_n_conv(i,j) = sum(sum(filter_avg .* img2(i-halfn:i+halfn,j-halfn:j+halfn)));
    end
end

figure(2),
subplot(131);  imshow(uint8(img2));  title('原图像');
subplot(132);  imshow(img_same);  title('使用conv2函数实现卷积');
subplot(133);  imshow(img_n_conv);  title('不使用conv2函数实现卷积')

figure(3),
subplot(131);  imshow(uint8(img2));  title('原图像');
subplot(132);  imshow(img_gau_conv);  title('使用conv2函数实现Gaussian 滤波');
subplot(133);  imshow(img_lap_conv);  title('使用conv2函数实现Laplacian 滤波')