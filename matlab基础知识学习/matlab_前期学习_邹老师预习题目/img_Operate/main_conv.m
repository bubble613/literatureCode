clear,  clc;
img1=imread('hehua.jpeg');
img_raw = rgb2gray(img1);
img = double(img_raw);
freq_img = fft2(img);  % 原图像的傅里叶变换

gaussian = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 16;  % Gaussian 模板
laplacian = [0, 1, 0; 1, -4, 1; 0, 1, 0];  % Laplacian 模板
filter = zeros(size(img));  % 滤波器大小与图像大小一致
filter_gau = filter;  filter_gau(1:3, 1:3) = gaussian;
filter_lap = filter;  filter_lap(1:3, 1:3) = laplacian;
freq_gau = fft2(filter_gau);  % Gaussian 滤波器的傅里叶变换
freq_lap = fft2(filter_lap);  % Laplacian 滤波器的傅里叶变换

% 利用时域（空域）卷积定理将傅里叶变换后的图像与滤波器点乘，再求反变换，得到滤波后的图像
img_gau = ifft2(freq_gau .* freq_img);  % Gaussian 滤波图像
img_gau = uint8(real(img_gau));
img_lap = ifft2(freq_lap .* freq_img);  % Laplacian 滤波图像
img_lap = uint8(real(img_lap));

% 使用自带卷积函数
img_gau_conv = uint8(conv2(img, gaussian, 'same'));
img_lap_conv = uint8(conv2(img, laplacian, 'same'));

% 画图
subplot(2, 3, 1);  imshow(img_raw);  title('原图');
subplot(2, 3, 2);  imshow(img_gau);  title('Gaussian 滤波图（定理）');
subplot(2, 3, 3);  imshow(img_gau_conv);  title('Gaussian 滤波图（conv2）');
subplot(2, 3, 5);  imshow(img_lap);  title('Laplacian 滤波图（定理）');
subplot(2, 3, 6);  imshow(img_lap_conv);  title('Laplacian 滤波图（conv2）');